module Refundable
  extend ActiveSupport::Concern
  included do
    has_many :refunds

    def make_refund(amount:, reason:, refunded_by_user_id:, test:nil)
      activate_session
      credit = ShopifyAPI::ApplicationCredit.new(amount: amount, description: reason, test: test)
      if credit.save
        refund = self.refunds.create reason: reason, amount_usd: amount, refunded_by_user_id: refunded_by_user_id
      else
        if credit.valid?
          error = "Failed.  Response code = 422.  Response message = Unprocessable Entity"
        else
          error = credit.errors.full_messages.join(' ')
        end

        refund = self.refunds.create reason: reason, amount_usd: amount, errored: true, error_message: error, refunded_by_user_id: refunded_by_user_id
      end

      return refund
    end
  end
end
