module PR
  module Common
    class AffiliateRedirect
      def initialize(app)
        @app = app
      end
      def call(env)
        req = Rack::Request.new(env)
        status, headers, body = @app.call(env)

        if req.env['rack.request.query_hash']['ref'] && PR::Common.config.referrer_redirect
          return [302, {'Location' => PR::Common.config.referrer_redirect, 'Content-Type' => 'text/html'}, ['Found']]
        end

        [status, headers, body]
      end
    end
  end
end