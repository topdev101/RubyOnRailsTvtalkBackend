class ProxyController < ApplicationController
  def show
    gracenote_api_client = GracenoteApi.new(requested_by: self.class)
    render json: gracenote_api_client.get(gracenote_api_url)
  end

  # takes the path from the request, adds the TMS host, and assigns the API Key parameter.
  def gracenote_api_url
    api_path = request.fullpath.split('data/').last
    api_url = "https://data.tmsapi.com/#{api_path}"
    uri = URI.parse(api_url)
    uri.query = URI.encode_www_form URI.decode_www_form(uri.query || '').concat([[:api_key, ENV['TMS_API_KEY']]])
    uri.to_s
  end
end
