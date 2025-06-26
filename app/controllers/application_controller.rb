class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  private

  def cookies_to_json(data)
    JSON.generate(data)
  end

  def cookies_to_array(cookies_string)
	  JSON.parse(cookies_string, symbolize_names: true)
  end

end
