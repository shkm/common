PR::Common.configure do |config|
  config.signup_params           = %i[email website password anonymous]
  config.send_welcome_email      = false
  config.send_confirmation_email = false
  config.referrer_redirect = 'http://localhost:3000/login'

  config.pricing = [
    {
      price:      0,
      trial_days: 0,
      plan_name:  'staff_business',
      name:       'Staff Business',
      terms:      'Staff Business terms',
    },
    {
      price:      0,
      trial_days: 0,
      plan_name:  'affiliate',
      name:       'Affiliate',
      terms:      'Affiliate terms',
    },
    {
      price:      10.0,
      trial_days: 7,
      name:       'Generic with trial',
      terms:      'Generic terms',
    }
  ]
end

