# https://docs.shopify.com/api/introduction/api-call-limit
module ActiveResource

  # 429 Client Error
  class RateLimitExceededError < ClientError # :nodoc:
  end

  class Connection

    RATE_LIMIT_SLEEP_SECONDS = 20 # number of seconds to sleep (by sleeping 20 you reset the clock to get 40 fresh burst calls with the default 2 calls/sec)
    RATE_LIMIT_BUFFER = 5 # you don't want to drain the remaining count to 0 in case you need high priority calls

    cattr_accessor :rate_limit_timer, :current_rate_limit_call_count, :total_rate_limit_calls

    private

    # https://github.com/rails/activeresource/blob/82eb29ab023b3105b29bce31c9a00a3b9a9653aa/lib/active_resource/connection.rb#L117
    def request(method, path, *arguments)
      Rails.logger.debug("#{method} #{path} shopify request #{Rake.application.top_level_tasks.join(', ')}") if ENV["DEBUG_SHOPIFY_RATE_LIMITS"]
      
      result = ActiveSupport::Notifications.instrument("request.active_resource") do |payload|
        payload[:method]      = method
        payload[:request_uri] = "#{site.scheme}://#{site.host}:#{site.port}#{path}"
        payload[:result]      = http.send(method, path, *arguments)
      end
      handle_rate_limit_response(result)
      handle_rate_limits(result)
      handle_response(result)
    rescue RateLimitExceededError => e
      Rails.logger.debug "[Rate limit exceeded]" if ENV["DEBUG_SHOPIFY_RATE_LIMITS"]
      rate_limit_sleep
      retry
    rescue Timeout::Error => e
      raise TimeoutError.new(e.message)
    rescue OpenSSL::SSL::SSLError => e
      raise SSLError.new(e.message)
    end

    def handle_rate_limit_response(response)
      case response.code.to_i
        when 429
          raise RateLimitExceededError.new(response)
      end
    end

    # Note this uses class variables and is not threadsafe or resilient to multiple processes communicating with the API simultaneously
    def handle_rate_limits(response)
      return unless response['x-shopify-shop-api-call-limit']
      # Record the current limits
      self.current_rate_limit_call_count, self.total_rate_limit_calls = response['x-shopify-shop-api-call-limit'].split('/')
      # Start a timer from when we last learned about the current limits
      self.rate_limit_timer = Time.now
      # Print some feedback for debugging
      Rails.logger.debug "[Rate limit: #{self.current_rate_limit_call_count || "??"}/#{self.total_rate_limit_calls || "??"}]" if ENV["DEBUG_SHOPIFY_RATE_LIMITS"]
      # Sleep if we need to sleep
      rate_limit_sleep if rate_limit_need_sleep?
    end

    def rate_limit_elapsed_seconds
      return 0 if self.rate_limit_timer.nil?

      Time.now.to_i - self.rate_limit_timer.to_i
    end

    def rate_limit_sleep
      sleep_seconds = RATE_LIMIT_SLEEP_SECONDS - rate_limit_elapsed_seconds
      return if sleep_seconds < 0
      Rails.logger.debug "[Rate limit sleeping: #{sleep_seconds} seconds]" if ENV["DEBUG_SHOPIFY_RATE_LIMITS"]
      Kernel.sleep(sleep_seconds)
      self.rate_limit_timer = nil
    end

    def rate_limit_need_sleep?
      return false if self.total_rate_limit_calls.nil? || self.current_rate_limit_call_count.nil?
      return false if self.total_rate_limit_calls.to_i - self.current_rate_limit_call_count.to_i > RATE_LIMIT_BUFFER
      return false if rate_limit_elapsed_seconds > RATE_LIMIT_SLEEP_SECONDS
      true
    end
  end
end
