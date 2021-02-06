require 'rails_helper'

describe List do
  it { is_expected.to respond_to :subscriptions }

  context '#may_delete_keys?' do
    before(:each) do
      # Don't use FakeApiSchleuderDaemon
      WebMock.reset!
    end

    after(:each) do
      # Clean up
      WebMock.reset!
    end

    it 'returns true if current_account is superadmin' do
      ENV['SCHLEUDER_LIST_DELETE_KEYS'] = 'X'
      Conf.squire.reload!

      stub_request(:post, "https://localhost:4443/lists.json").
        with(body: "{\"email\":\"list1@example.org\"}").
        to_return(body: read_fixture("list1.json"))
      list = create(:list, email: 'list1@example.org')

      account = Account.new(email: 'admin@localhost')
      res = list.may_delete_keys?(account)

      expect(res).to be(true)
    end

    it 'returns true if current_account is list-admin' do
      ENV['SCHLEUDER_LIST_DELETE_KEYS'] = 'X'
      Conf.squire.reload!

      account = create(:account, email: 'admin_subscription1@example.org')

      stub_request(:post, "https://localhost:4443/subscriptions.json").
        with(body: "{\"email\":\"admin_subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":true,\"delivery_enabled\":true,\"list_id\":1}").
        to_return(status: 200, body: read_fixture("admin_subscription.json"))
      admin = create(:subscription, admin: true, email: account.email)

      stub_request(:post, "https://localhost:4443/lists.json").
        with(body: "{\"email\":\"list1@example.org\",\"subscriptions\":[{\"email\":\"admin_subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F129A74AD5317457F\",\"admin\":true,\"delivery_enabled\":true,\"list_id\":1,\"id\":8,\"created_at\":\"2018-01-13T16:31:19.406Z\",\"updated_at\":\"2018-01-13T16:31:19.427Z\"}]}").
        to_return(status: 200, body: read_fixture("list1.json"))
      list = create(:list, email: 'list1@example.org', subscriptions: [admin])

      stub_request(:get, "https://localhost:4443/lists/1.json").
        to_return(status: 200, body: read_fixture("list1.json"))
      stub_request(:get, api_uri_with_path("/subscriptions.json?admin=true&email=admin_subscription1@example.org")).
        to_return(status: 200, body: json_object_as_array('admin_subscription.json'))
      res = list.may_delete_keys?(account)

      expect(res).to be(true)
    end

    it 'returns false if current_account is neither superadmin nor list-admin' do
      ENV['SCHLEUDER_LIST_DELETE_KEYS'] = 'X'
      Conf.squire.reload!

      account = create(:account, email: 'subscription1@example.org')

      stub_request(:post, api_uri_with_path("/subscriptions.json")).
        with(body: "{\"email\":\"subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1}").
        to_return(body: read_fixture('subscription1.json'))
      subscription = create(:subscription, email: account.email, admin: false)

      stub_request(:post, api_uri_with_path("/lists.json")).
        with(body: "{\"email\":\"list1@example.org\",\"subscriptions\":[{\"email\":\"subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F129A74AD5317457F\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1,\"id\":1,\"created_at\":\"2018-01-13T16:31:19.406Z\",\"updated_at\":\"2018-01-13T16:31:19.427Z\"}]}").
        to_return(status: 200, body: read_fixture("list1.json"))
      list = create(:list, email: 'list1@example.org', subscriptions: [subscription])

      stub_request(:get, api_uri_with_path("/subscriptions.json?admin=true&email=subscription1@example.org")).
        to_return(body: "[]")

      res = list.may_delete_keys?(account)

      expect(res).to be(false)
    end

    it 'returns true if current_account is neither superadmin nor list-admin, but list is allowed in config' do
      ENV['SCHLEUDER_LIST_DELETE_KEYS'] = 'list1@example.org'
      Conf.squire.reload!

      account = create(:account, email: 'subscription1@example.org')

      stub_request(:post, api_uri_with_path("/subscriptions.json")).
        with(body: "{\"email\":\"subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1}").
        to_return(body: read_fixture('subscription1.json'))
      subscription = create(:subscription, email: account.email, admin: false)

      stub_request(:post, api_uri_with_path("/lists.json")).
        with(body: "{\"email\":\"list1@example.org\",\"subscriptions\":[{\"email\":\"subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F129A74AD5317457F\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1,\"id\":1,\"created_at\":\"2018-01-13T16:31:19.406Z\",\"updated_at\":\"2018-01-13T16:31:19.427Z\"}]}").
        to_return(status: 200, body: read_fixture("list1.json"))
      list = create(:list, email: 'list1@example.org', subscriptions: [subscription])

      stub_request(:get, api_uri_with_path("/subscriptions.json?admin=true&email=subscription1@example.org")).
        to_return(body: "[]")

      res = list.may_delete_keys?(account)

      expect(res).to be(true)
    end

    it 'returns true if current_account is neither superadmin nor list-admin, but all lists are allowed in config' do
      ENV['SCHLEUDER_LIST_DELETE_KEYS'] = '"*"'
      Conf.squire.reload!

      account = create(:account, email: 'subscription1@example.org')

      stub_request(:post, api_uri_with_path("/subscriptions.json")).
        with(body: "{\"email\":\"subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1}").
        to_return(body: read_fixture('subscription1.json'))
      subscription = create(:subscription, email: account.email, admin: false)

      stub_request(:post, api_uri_with_path("/lists.json")).
        with(body: "{\"email\":\"list1@example.org\",\"subscriptions\":[{\"email\":\"subscription1@example.org\",\"fingerprint\":\"129A74AD5317457F129A74AD5317457F\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1,\"id\":1,\"created_at\":\"2018-01-13T16:31:19.406Z\",\"updated_at\":\"2018-01-13T16:31:19.427Z\"}]}").
        to_return(status: 200, body: read_fixture("list1.json"))
      list = create(:list, email: 'list1@example.org', subscriptions: [subscription])

      stub_request(:get, api_uri_with_path("/subscriptions.json?admin=true&email=subscription1@example.org")).
        to_return(body: "[]")

      res = list.may_delete_keys?(account)

      expect(res).to be(true)
    end
  end
end
