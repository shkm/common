class CustomersRedactJob < PR::Common::ApplicationJob
  def perform(params)
    # No customer data stored? Return.
    return
  end
end
