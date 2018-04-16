require 'sinatra/base'

class FakeSchleuder < Sinatra::Base

  # subscriptions
  post "/subscriptions.json" do
    request_body = JSON.parse(request.body.read)
    if request_body["admin"] == true
      json_response 200, "admin_subscription.json"
    else
      json_response 200, "subscription.json"
    end
  end

  get "/subscriptions.json" do
    json_response 200, "subscriptions.json"
  end

  get "/subscriptions/8.json" do
    json_response 200, "subscription.json"
  end

  # lists
  post "/lists.json" do
    json_response 200, "list1.json"
  end

  get "/lists.json" do
    json_response 200, "lists.json"
  end

  get "/lists/1.json" do
    json_response 200, "list1.json"
  end

  get "/lists/2.json" do
    json_response 200, "list2.json"
  end

  # keys
  get "/keys/59C71FB38AEE22E091C78259D06350440F759BD3.json" do
    json_response 200, "key.json"
  end

  get "/keys/129A74AD5317457F9E502844A39C61B32003A8D8.json" do
    json_response 200, "key.json"
  end

  get "/keys.json" do
    json_response 200, "keys.json"
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.read(File.dirname(__FILE__) + '/../fixtures/' + file_name)
  end
end
