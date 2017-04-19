class PasswordsController < ApiBaseController
  skip_before_action :authenticate_user_from_token!

  def update
    @user = User.reset_password_by_token(change_password_params.merge(reset_password_token: params[:id]))
    if @user && @user.errors.empty?
      @user.update_attribute(:confirmed, true)
      render json: {}, meta: { success: true }, serializer: EmptySerializer
    else
      render json: {}, meta: { success: false, errors: @user.errors }, status: :unprocessable_entity, serializer: EmptySerializer
    end
  end

  private
  def change_password_params
    params.require(:change_password).permit(:password, :password_confirmation)
  end
end
