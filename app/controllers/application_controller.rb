class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  private

  def cookies_to_json(data)
    JSON.generate(data)
  end

  def cookies_to_array(cookies_string)
	  JSON.parse(cookies_string, symbolize_names: true)
  end

  def array_snake
    cookies_to_array(cookies[:snake]) || []
  end

  def update_cookies_snake(snake_array)
    cookies[:snake] = cookies_to_json(snake_array)
  end
end
