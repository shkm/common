class SignupsController < ApiBaseController
  skip_before_action :authenticate_user_from_token!
  before_action :generate_anonymous

  # this method risks getting very messy
  # when we work on it next we should think about what the responsibility of this method is-
  # - register a user, responding with errors or success
  # - only require email
  # - if no password provided, generate one and send mail
  # - be agnostic to other generic params and just save them to the user
  #   - for example, if a 'website' param is provided, save it to the user, if a 'favourite_food' param is provided, save it to the user
  # - then it is the responsibility of the API caller to do special things on a successful registration: not this method
  # meaning:
  # - strip out JobCreationService call from here
  # - remove special logic for 'name' and 'website' params: just treat them as generic
  def create
    existing_user = User.find_by(email: signup_params[:email].downcase, provider: nil)
    @user = nil
    meta = if existing_user and !signup_params[:password]
      if !existing_user.confirmed?
        # create their job, but don't sign them in
        if params[:job]
          JobCreationService.new(filled_roles: job_params[:filled_roles], recommended_for_id: job_params[:recommended_for_id], description: job_params[:description], creating_user: existing_user, job_type: job_params[:job_type]).save
        end
        NewUserMailer.new_password(existing_user).deliver_now
        { signup_success: false, require_password: true, confirmed: false }
      else
        # ask them for password
        { signup_success: false, require_password: true, confirmed: true }
      end
    elsif existing_user
      # check their password is correct and if so create job
      if existing_user.valid_password?(signup_params[:password])
        # create their job
        @user = existing_user
        sign_in @user, store: false
        { signup_success: true, existing_account: true }
      else
        { signup_success: false, require_password: true, password_invalid: true }
      end
    else
      # no existing user, so create this one
      if params['signup']['name']
        params['signup']['name'] = ActionController::Base.helpers.strip_tags(params['signup']['name'])
      end

      unless signup_params[:password]
        params['signup']['password'] = SecureRandom.base64
        send_password_instruction = true
      end

      @user = User.new(signup_params.merge(confirmed: false))

      token = request.headers['Authorization']
      if token
        if user = User.find_by(access_token: token, anonymous: true)
          @user = user
          @user.website = signup_params[:website]
          @user.password = signup_params[:password]
          @user.email = signup_params[:email]
          @user.anonymous = false
          @user.username = signup_params[:email]
        end
      end

      if @user.save
        sign_in @user, store: false

        NewUserMailer.welcome(@user).deliver_now if PR::Common.config.send_welcome_email

        if send_password_instruction
          NewUserMailer.new_password(@user).deliver_now
        else
          NewUserMailer.confirm(@user).deliver_now if PR::Common.config.send_confirmation_email
        end

        { signup_success: true, existing_account: false }
      else
        { signup_success: false, existing_account: false, errors: @user.errors }
      end
    end

    render json: @user, meta: meta, serializer: SessionSerializer
  end

  private

  def generate_anonymous
    if params[:signup][:anonymous]
      signup_params = PR::Common.config.signup_params
      params[:signup][:email] = "help+anonymous_#{Time.now.to_i}#{rand(100)}@pluginseo.com"
      params[:signup][:password] = SecureRandom.hex if signup_params.include? :password
      params[:signup][:name] = 'anonymous' if signup_params.include? :name
      params[:signup][:anonymous] = true
    end
  end

  def signup_params
    params.require(:signup).permit(PR::Common.config.signup_params)
  end

  def job_params
    params.require(:job).permit(:job_type, :fixer_id, :recommended_for_id, :description, :filled_roles => [:id, :name, :admin])
  end
end
