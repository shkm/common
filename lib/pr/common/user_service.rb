module PR
  module Common
    class UserService
      def find_or_create_user_by_shopify(email:, shop:, referrer: nil)
        if user = User.find_by(username: "shopify-#{shop.shopify_domain}", provider: 'shopify')
          Analytics.identify({
                                 user_id: user.id,
                                 traits: {
                                     primaryDomain:  shop.shopify_domain,
                                     email:          email,
                                     product:        'Shopify',
                                     username:       user.username,
                                     activeCharge:   user.active_charge
                                 }
                             })

          return user
        else
          created_user = create(
              username: "shopify-#{shop.shopify_domain}",
              password: SecureRandom.hex,
              provider: 'shopify',
              website:  shop.shopify_domain,
              shop_id:  shop.id,
              email:    email,
              referrer: referrer
          )

          Analytics.identify({
                                 user_id: created_user.id,
                                 traits: {
                                     primaryDomain:  shop.shopify_domain,
                                     email:          email,
                                     product:        'Shopify',
                                     username:       created_user.username,
                                     activeCharge:   created_user.active_charge,
                                     referrer:       referrer
                                 }
                             })

          Analytics.track({
                              user_id: created_user.id,
                              event: 'Registered',
                              properties: {
                                  'registration method': 'shopify',
                                  'email': email
                              }
                          })

          return created_user
        end
      end
    end
  end
end