require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] ==  [ENV['sidekiq_admin_login'], ENV['sidekiq_admin_password']]
end
