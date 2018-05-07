require "rails_helper"

feature "User views a subscription" do
  scenario "gets a 403 error for an other subscription" do
    account = create(:account, email: "subscription1@example.org")
    subscription1 = create(:subscription, email: account.email)
    subscription2 = create(:subscription, email: 'subscription2@example.org')
    admin = create(:subscription, admin: true, email: 'admin@example.org')
    _list = create(:list, email: "list1@example.org", subscriptions: [admin, subscription1])
    stub_request(:get, "https://localhost:4443/subscriptions.json?admin=true&email=subscription1@example.org").
        to_return(status: 200, body: "[]")
    stub_request(:get, "https://localhost:4443/subscriptions.json?email=subscription1@example.org&list_id=1").
        to_return(status: 200, body: json_object_as_array('subscription1.json'))
    stub_request(:get, "https://localhost:4443/subscriptions.json?email=subscription1@example.org").
        to_return(body: json_object_as_array('subscription1.json'))

    sign_in(account)
    visit(subscription_path(subscription2.id))

    expect(page).not_to have_content(subscription2.email)
    expect(page).to have_content('Forbidden')

    WebMock.reset!
  end
end
