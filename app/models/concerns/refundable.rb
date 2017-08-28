module Refundable
  extend ActiveSupport::Concern
  included do
    has_many :refunds

    def make_refund(amount:, reason:, refunded_by_user_id:, test:nil)
      activate_session
      credit = ShopifyAPI::ApplicationCredit.new(amount: amount, description: reason, test: test)
      if credit.save!
        refund = self.refunds.create reason: reason, amount_usd: amount, refunded_by_user_id: refunded_by_user_id
        return refund
      end

    rescue ActiveResource::ClientError, ActiveResource::ResourceInvalid => e
      if credit.valid?
        error = e.message
      else
        error = credit.errors.full_messages.join(' ')
      end

      refund = self.refunds.create reason: reason, amount_usd: amount, errored: true, error_message: error, refunded_by_user_id: refunded_by_user_id
      return refund
    end
  end
end
