class UserAdminController < ApiBaseController
  def search
    if !current_user.admin?
      render json: {error: 'auth error'}, status: 403
      return false
    end

    results =
      User
        .select(:id, :email, :website, 's.shopify_domain', :plus, 'fc.first_charge_date')
        .joins(ActiveRecord::Base.send(:sanitize_sql_array, ["
          LEFT JOIN shops s
          ON s.id = users.shop_id
          AND s.shopify_domain ILIKE ?", "%#{params[:q]}%"]))
        .joins('LEFT JOIN (select user_id, min(date_created) as first_charge_date
                            from application_charges ac
                            group by user_id) AS fc
                ON fc.user_id = users.id')
        .where('users.email ILIKE ? OR users.website ILIKE ? OR s.id IS NOT NULL', '%' + params[:q] + '%', '%' + params[:q] + '%')

    render json: results.to_json
  end

  def make_refund
    if !current_user.admin?
      render json: {error: 'auth error'}, status: 403
      return false
    end

    user = User.find(params[:user_id])
    refund = user.make_refund(reason: params[:reason], amount: params[:amount], test: params[:test])

    render json: refund.to_json
  end

  private
  def search_params
    params.require(:q)
  end
end
