require 'rails_helper'

describe KeysController do
  describe "DELETE key" do
    before(:each) do
      WebMock.reset!

      email = "subscription1@example.org"
      account = create(:account, email: email)

      stub_request(:post, api_uri_with_path("/subscriptions.json")).
        with(body: "{\"email\":\"subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1}").
        to_return(body: read_fixture('subscription1.json'))
      subscription = create(:subscription, email: email)

      stub_request(:post, api_uri_with_path("/lists.json")).
        with(body: "{\"email\":\"list1@example.org\",\"subscriptions\":[{\"email\":\"subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F129A74AD5317457F\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1,\"id\":1,\"created_at\":\"2018-01-13T16:31:19.406Z\",\"updated_at\":\"2018-01-13T16:31:19.427Z\"}]}").
        to_return(status: 200, body: read_fixture("list1.json"))
      @list = create(:list, email: 'list1@example.org', subscriptions: [subscription])

      stub_request(:get, api_uri_with_path("/lists/1.json")).
        to_return(body: read_fixture('list1.json'))
      stub_request(:get, "https://localhost:4443/subscriptions.json?admin=true&email=subscription1@example.org").
        to_return(body: "[]")

      request.session[:current_account_id] = account.id
      request.session[:login_expires_at] = 30.minutes.from_now.to_s
    end

    it "allows deleting a subscriber's key" do
      stub_request(:get, api_uri_with_path("/keys/129A74AD5317457F9E502844A39C61B32003A8D8.json?list_id=1")).
        to_return(body: read_fixture('key2.json'))

      delete :destroy, params: {list_id: @list.id, fingerprint: '129A74AD5317457F9E502844A39C61B32003A8D8'}

      expect(response).to redirect_to(list_keys_url(@list))
      expect(session[:flash]['flashes']['notice']).to eql("Only allowed for list admins")
    end

    it "rejects deleting the list's key" do
      stub_request(:get, api_uri_with_path("/keys/59C71FB38AEE22E091C78259D06350440F759BD3.json?list_id=1")).
        to_return(body: read_fixture('key.json'))

      delete :destroy, params: {list_id: @list.id, fingerprint: @list.fingerprint}

      expect(response).to redirect_to(list_keys_url(@list))
      expect(session[:flash]['flashes']['notice']).to eql("Deleting the list's key is not allowed")
    end
  end
end

