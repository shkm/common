class UserAdminController < ApiBaseController
  def search
    if !current_user.admin?
      render json: {error: 'auth error'}, status: 403
      return false
    end

    results =
      User
        .select(:id, :email, :website, 's.shopify_domain', :active_charge)
        .joins("
          LEFT JOIN shops s
          ON s.id = users.shop_id")
        .where('users.email ILIKE ? OR users.website ILIKE ? OR s.shopify_domain ILIKE ?', "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%")

    render json: results.to_json
  end

  def make_refund
    if !current_user.admin?
      render json: {error: 'auth error'}, status: 403
      return false
    end

    user = User.find(params[:user_id])
    refund = user.make_refund(reason: params[:reason], amount: params[:amount], refunded_by_user_id: current_user.id, test: params[:test])

    render json: refund.to_json
  end

  private
  def search_params
    params.require(:q)
  end
end
