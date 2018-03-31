require "rails_helper"

feature "User edits a subscription" do
  scenario "gets a form populated with with the subscription data" do
    account = create(:account, email: "subscription9@example.org")

    stub_request(:post, "https://localhost:4443/subscriptions.json").
        with(body: "{\"email\":\"admin@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":true,\"delivery_enabled\":true,\"list_id\":1}").
        to_return(status: 200, body: File.read(fixture_path + "/admin_subscription.json"))
    admin = create(:subscription, admin: true, email: 'admin@example.org')


    stub_request(:post, "https://localhost:4443/subscriptions.json").
        with(body: "{\"email\":\"subscription9@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1}").
        to_return(status: 200, body: File.read(fixture_path + "/user_subscription.json"))
    subscription = create(:subscription, email: account.email)


    stub_request(:post, "https://localhost:4443/lists.json").
        with(body: "{\"email\":\"list1@example.org\",\"subscriptions\":[{\"email\":\"subscription5@example.org\",\"fingerprint\":\"129A74AD5317457F129A74AD5317457F\",\"admin\":true,\"delivery_enabled\":true,\"list_id\":11,\"id\":8,\"created_at\":\"2018-01-13T16:31:19.406Z\",\"updated_at\":\"2018-01-13T16:31:19.427Z\"},{\"email\":\"subscription9@example.org\",\"fingerprint\":\"129A74AD5317457F129A74AD5317457F\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1,\"id\":9,\"created_at\":\"2018-01-13T16:31:19.406Z\",\"updated_at\":\"2018-01-13T16:31:19.427Z\"}]}").
        to_return(status: 200, body: File.read(fixture_path + "/list1.json"))
    _list = create(:list, email: "list1@example.org", subscriptions: [admin, subscription])


    stub_request(:get, "https://localhost:4443/subscriptions.json?admin=true&email=subscription9@example.org").
        to_return(status: 200, body: "[]")
    stub_request(:get, "https://localhost:4443/subscriptions.json?email=subscription9@example.org&list_id=1").
        to_return(status: 200, body: File.read(fixture_path + "/user_list1_subscriptions.json"))
    stub_request(:get, "https://localhost:4443/subscriptions.json?list_id=1").
        to_return(status: 200, body: File.read(fixture_path + "/subscriptions.json"))
    stub_request(:get, "https://localhost:4443/subscriptions.json?email=subscription9@example.org").
        to_return(body: File.read(fixture_path + "/user_list1_subscriptions.json"))
    stub_request(:get, "https://localhost:4443/lists/1.json").
        to_return(status: 200, body: File.read(fixture_path + "/list1.json"))


    sign_in(account)


    stub_request(:get, "https://localhost:4443/subscriptions/9.json").
        to_return(status: 200, body: File.read(fixture_path + "/user_subscription.json"))
    stub_request(:get, "https://localhost:4443/keys/59C71FB38AEE22E091C78259D06350440F759BD3.json?list_id=1").
        to_return(status: 200, body: File.read(fixture_path + "/key.json"))
    stub_request(:get, "https://localhost:4443/keys.json?list_id=1").
        to_return(status: 200, body: File.read(fixture_path + "/keys.json"))


    visit(edit_subscription_path(subscription.id))
    expect(page).to have_field('Email', with: subscription.email, disabled: true)

    WebMock.reset!
  end

  def sign_in(user)
    visit new_login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
  end
end

feature "User views a subscription" do
  scenario "gets a 403 error for an other subscription" do
    account = create(:account, email: "subscription9@example.org")

    stub_request(:post, "https://localhost:4443/subscriptions.json").
        with(body: "{\"email\":\"subscription9@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1}").
        to_return(status: 200, body: File.read(fixture_path + "/user_subscription.json"))
    subscription1 = create(:subscription, email: account.email)


    stub_request(:post, "https://localhost:4443/subscriptions.json").
        with(body: "{\"email\":\"subscription5@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1}").
        to_return(status: 200, body: File.read(fixture_path + "/subscription.json"))
    subscription2 = create(:subscription, email: 'subscription5@example.org')


    stub_request(:post, "https://localhost:4443/subscriptions.json").
        with(body: "{\"email\":\"admin@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":true,\"delivery_enabled\":true,\"list_id\":1}").
        to_return(status: 200, body: File.read(fixture_path + "/admin_subscription.json"))
    admin = create(:subscription, admin: true, email: 'admin@example.org')


    stub_request(:post, "https://localhost:4443/lists.json").
        with(body: "{\"email\":\"list1@example.org\",\"subscriptions\":[{\"email\":\"subscription5@example.org\",\"fingerprint\":\"129A74AD5317457F129A74AD5317457F\",\"admin\":true,\"delivery_enabled\":true,\"list_id\":11,\"id\":8,\"created_at\":\"2018-01-13T16:31:19.406Z\",\"updated_at\":\"2018-01-13T16:31:19.427Z\"},{\"email\":\"subscription9@example.org\",\"fingerprint\":\"129A74AD5317457F129A74AD5317457F\",\"admin\":false,\"delivery_enabled\":true,\"list_id\":1,\"id\":9,\"created_at\":\"2018-01-13T16:31:19.406Z\",\"updated_at\":\"2018-01-13T16:31:19.427Z\"}]}").
        to_return(status: 200, body: File.read(fixture_path + "/list1.json"))
    _list = create(:list, email: "list1@example.org", subscriptions: [admin, subscription1])


    stub_request(:get, "https://localhost:4443/subscriptions.json?admin=true&email=subscription9@example.org").
        to_return(status: 200, body: "[]")
    stub_request(:get, "https://localhost:4443/subscriptions.json?email=subscription9@example.org&list_id=1").
        to_return(status: 200, body: File.read(fixture_path + "/user_list1_subscriptions.json"))
    stub_request(:get, "https://localhost:4443/subscriptions.json?list_id=1").
        to_return(status: 200, body: File.read(fixture_path + "/subscriptions.json"))
    stub_request(:get, "https://localhost:4443/subscriptions.json?email=subscription9@example.org").
        to_return(body: File.read(fixture_path + "/user_list1_subscriptions.json"))
    stub_request(:get, "https://localhost:4443/lists/1.json").
        to_return(status: 200, body: File.read(fixture_path + "/list1.json"))


    sign_in(account)


    stub_request(:get, "https://localhost:4443/subscriptions/#{subscription1.id}.json").
        to_return(status: 200, body: File.read(fixture_path + "/user_subscription.json"))
    stub_request(:get, "https://localhost:4443/keys/59C71FB38AEE22E091C78259D06350440F759BD3.json?list_id=1").
        to_return(status: 200, body: File.read(fixture_path + "/key.json"))
    stub_request(:get, "https://localhost:4443/subscriptions/#{subscription2.id}.json").
        to_return(status: 403, body: "")
    stub_request(:get, "https://localhost:4443/keys/129A74AD5317457F129A74AD5317457F.json?list_id=1").
        to_return(status: 200, body: File.read(fixture_path + "/key.json"))
    stub_request(:get, "https://localhost:4443/keys.json?list_id=1").
        to_return(status: 200, body: File.read(fixture_path + "/keys.json"))


    visit(subscription_path(subscription2.id))
    expect(page).not_to have_content(subscription2.email)
    expect(page).to have_content('Forbidden')

    WebMock.reset!
  end

  def sign_in(user)
    visit new_login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
  end
end

