class ShopsController < ApplicationController
  def callback
    Shop.find_by(shopify_domain: params[:domain]).update(shop_params)
  end

  private

  def shop_params
    params.permit(:plan_name)
  end
end
