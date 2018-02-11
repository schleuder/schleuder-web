require "rails_helper"

feature "User signs in" do
  scenario "with valid email and password" do
    create(:account, email: "a_user@example.com")
    stub_request(:get, 'https://localhost:4443/subscriptions.json?email=a_user@example.com').
      to_return(body: [].to_json)
    stub_request(:get, "https://localhost:4443/subscriptions.json?admin=true&email=a_user@example.com").
      to_return(body: [].to_json)

    sign_in_with("a_user@example.com", "password")

    expect(page).to have_content "Logout"

    WebMock.reset!
  end

  scenario "with invalid email and password" do
    sign_in_with("invalid@example.com", "password")

    expect(page).to have_content "Wrong email-address or password, please try again"
  end

  def sign_in_with(email, password)
    visit new_login_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Login"
  end
end
