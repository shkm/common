class ApiBaseController < ActionController::Base
  require 'active_model_serializers'
  include PR::Common::TokenAuthenticable
end
