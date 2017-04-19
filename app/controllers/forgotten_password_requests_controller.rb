class ForgottenPasswordRequestsController < ApiBaseController
  skip_before_action :authenticate_user_from_token!

  def create
    # with providers like Shopify, users can have the same email address
    # in future we should aim to move all authentication methods into Common
    users = User.where(email: forgotten_password_requests_params[:email])
    if users.count == 1
      NewUserMailer.new_password(users[0]).deliver_now
    elsif users.count > 1
      NewUserMailer.new_password_duplicate_emails(users).deliver_now
    end

    render json: {}, meta: { success: true }, serializer: EmptySerializer
  end

  private

  def forgotten_password_requests_params
    params.require(:forgotten_password_request).permit(:email)
  end
end
