 require 'rails_helper'

 describe Subscription do
   it { is_expected.to respond_to :list}

   describe "#key" do
     it "returns the the key with the subscriptions fingerprint" do
       stub_request(:post, api_uri_with_path("/subscriptions.json")).
         with(body: "{\"email\":\"user1@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1}").
         to_return(status: 200, body: read_fixture("subscription1.json"))
       stub_request(:get, api_uri_with_path("/keys/129A74AD5317457F129A74AD5317457F.json?list_id=1")).
         to_return(status: 200, body: read_fixture("key.json"))

       subscription = create(:subscription, email: "user1@example.org")

       expect(subscription.key.fingerprint).to eq("59C71FB38AEE22E091C78259D06350440F759BD3")

       WebMock.reset!
     end
   end

   describe "#account" do
     it " returns the account with the subscriptions email" do
       account = create(:account, email: "subscription1@example.org")

       stub_request(:post, api_uri_with_path("/subscriptions.json")).
         with(body: "{\"email\":\"subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1}").
         to_return(status: 200, body: read_fixture("subscription1.json"))
       stub_request(:get, api_uri_with_path("/keys/129A74AD5317457F129A74AD5317457F.json?list_id=1")).
         to_return(status: 200, body: read_fixture("key.json"))

       subscription = create(:subscription, email: "subscription1@example.org")

       expect(subscription.account).to eq(account)

       WebMock.reset!
     end
   end
 end
