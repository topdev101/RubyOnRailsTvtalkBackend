
class GracenoteApi
  attr_accessor :requested_by

  # requested_by refers to the class that is calling the API. For usage monitoring.
  def initialize(requested_by: nil)
    @requested_by = requested_by
  end

  def track(url)
    path = URI.parse(url).path
    cache_hit = Rails.cache.exist?(url) ? 'Hit' : 'Miss'
    message = "GracenoteApi::#{requested_by} (Cache #{cache_hit}) - #{path}"
    Rails.logger.info(message)

    current_usage = Rails.cache.fetch("GracenoteApi::Usage")
    Rails.logger.info("GracenoteApi::Usage - #{current_usage.to_i + 1} past 24 hours")
  end

  def get(url, expires_in: nil)
    raise 'url cannot be blank' if url.empty?

    track(url)
    cache_request(url: url, expires_in: expires_in)
  end

  private

  def cache_request(url:, clear_cache: false, expires_in: 12.hours)
    Rails.cache.fetch(url, expires_in: expires_in, force: clear_cache) do
      response = HTTParty.get(url)

      Rails.cache.increment("GracenoteApi::Usage", expires_in: 24.hours)
      Rails.cache.increment("GracenoteApi::Usage::#{requested_by}", expires_in: 24.hours)

      JSON.parse(response.body)
    end
  end
end
