require "rails_helper"

feature "User edits a subscription" do
  scenario "gets a form populated with with the subscription data" do
    account = create(:account, email: "subscription1@example.org")
    admin = create(:subscription, admin: true, email: 'admin@example.org')
    subscription = create(:subscription, email: account.email)
    _list = create(:list, email: "list1@example.org", subscriptions: [admin, subscription])
    stub_request(:get, api_uri_with_path("/subscriptions.json?admin=true&email=subscription1@example.org")).
        to_return(status: 200, body: "[]")
    stub_request(:get, api_uri_with_path("/subscriptions.json?email=subscription1@example.org&list_id=1")).
        to_return(status: 200, body: json_object_as_array('subscription1.json'))
    stub_request(:get, api_uri_with_path("/subscriptions.json?email=subscription1@example.org")).
        to_return(body: json_object_as_array('subscription1.json'))

    sign_in(account)
    visit(edit_subscription_path(subscription.id))

    expect(page).to have_field('Email', with: subscription.email, disabled: true)

    WebMock.reset!
  end
end

