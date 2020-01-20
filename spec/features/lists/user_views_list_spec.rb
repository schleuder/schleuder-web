require "rails_helper"

feature "User views a list" do
  scenario "when the key is found but no admins present" do
    email = "subscription1@example.org"
    account = create(:account, email: email)
    subscription1 = create(:subscription, email: email)
    list = create(:list, email: email, subscriptions: [subscription1])
    stub_request(
      :get,
      api_uri_with_path("/keys/59C71FB38AEE22E091C78259D06350440F759BD3.json?list_id=#{list.id}")
    ).to_return(status: 200, body: read_fixture('key.json'))

    sign_in(account)
    visit(list_subscriptions_path(list))
    expect(page).to have_content('This list is not functional!')
    expect(page).to have_content("It needs at least one list-admin!")
    WebMock.reset!
  end

  scenario "when the key is not found it show the error message" do
    email = "subscription1@example.org"
    account = create(:account, email: email)
    subscription1 = create(:subscription, email: email, admin: true)
    list = create(:list, email: email, subscriptions: [subscription1])
    stub_request(
      :get,
      api_uri_with_path("/keys/59C71FB38AEE22E091C78259D06350440F759BD3.json?list_id=#{list.id}")
    ).to_return(status: 404, body: "[]")

    sign_in(account)
    visit(list_subscriptions_path(list))
    expect(page).to have_content('This list is not functional!')
    expect(page).to have_content("No list-key present for #{list.email}")
    WebMock.reset!
  end
end
