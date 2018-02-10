require "rails_helper"

feature "Super admin edits a subscription" do
  scenario "gets a form populated with with the subscription data" do
    super_admin = create(:account, email: "root@localhost")

    stub_request(:post, "https://localhost:4443/subscriptions.json").
      with(body: "{\"email\":\"user1@example.org\",\"fingerprint\":\"129A74AD5317457F9E502844A39C61B32003A8D8\",\"admin\":true,\"delivery_enabled\":true,\"list_id\":1}").
      to_return(status: 200, body: File.read(fixture_path + "/admin_subscription.json"))
    subscription = create(:subscription, admin: true)

    stub_request(:post, "https://localhost:4443/lists.json").
      with(body: "{\"email\":\"list1@example.org\",\"subscriptions\":[{\"email\":\"subscription5@example.org\",\"fingerprint\":\"129A74AD5317457F129A74AD5317457F\",\"admin\":true,\"delivery_enabled\":true,\"list_id\":11,\"id\":8,\"created_at\":\"2018-01-13T16:31:19.406Z\",\"updated_at\":\"2018-01-13T16:31:19.427Z\"}]}").
      to_return(status: 200, body: File.read(fixture_path + "/list1.json"))
    _list = create(:list, email: "list1@example.org", subscriptions: [subscription])

    stub_request(:get, "https://localhost:4443/lists.json").
      to_return(status: 200, body: File.read(fixture_path + "/lists.json"))
    stub_request(:get, "https://localhost:4443/subscriptions.json?email=root@localhost").
      to_return(body: File.read(fixture_path + "/subscriptions.json"))
    stub_request(:get, "https://localhost:4443/lists/1.json").
      to_return(status: 200, body: File.read(fixture_path + "/list1.json"))
    stub_request(:get, "https://localhost:4443/lists/2.json").
      to_return(status: 200, body: File.read(fixture_path + "/list2.json"))
    stub_request(:get, "https://localhost:4443/subscriptions.json?list_id=1").
      to_return(status: 200, body: File.read(fixture_path + "/subscriptions.json"))
    stub_request(:get, "https://localhost:4443/keys/129A74AD5317457F9E502844A39C61B32003A8D8.json?list_id=1").
      to_return(status: 200, body: File.read(fixture_path + "/key.json"))
    stub_request(:get, "https://localhost:4443/keys/129A74AD5317457F9E502844A39C61B32003A8D8.json?list_id=2").
      to_return(status: 200, body: File.read(fixture_path + "/key.json"))

    stub_request(:get, "https://localhost:4443/keys/59C71FB38AEE22E091C78259D06350440F759BD3.json?list_id=1").
      to_return(status: 200, body: File.read(fixture_path + "/key.json"))

    sign_in(super_admin)

    stub_request(:get, "https://localhost:4443/subscriptions/8.json").
      to_return(status: 200, body: File.read(fixture_path + "/subscription.json"))
    stub_request(:get, "https://localhost:4443/lists/1.json").
      with(headers: {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic c2NobGV1ZGVyOmlpMTIzNDU2Nzg5aWk=', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: File.read(fixture_path + "/list1.json"))
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
