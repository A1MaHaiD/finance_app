# lib/tasks/destroy_session.rake
namespace :session do
  desc "Відправка DELETE запиту на вихід"
  task destroy: :environment do
    require "net/http"
    require "uri"

    uri = URI("http://127.0.0.1:3000/users/sign_out")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri)
    response = http.request(request)

    puts "Response code: #{response.code}"
  end
end
