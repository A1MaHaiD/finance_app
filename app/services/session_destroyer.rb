# app/services/session_destroyer.rb
require 'net/http'
require 'uri'

class SessionDestroyer
  def self.destroy
    # Врахуйте, що destroy_user_session_path потрібно якось передати або отримати.
    # Наприклад, якщо у вас хост і порт фіксовані або доступні через конфігурацію:
    uri = URI("http://127.0.0.1:3000/users/sign_out")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri)
    http.request(request)
  end
end
