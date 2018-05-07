require "rails_helper"

feature "Super admin edits a subscription" do
  scenario "gets a form populated with with the subscription data" do
    super_admin = create(:account, email: "root@localhost")
    subscription = create(:subscription, admin: true)
    _list = create(:list, email: "list1@example.org", subscriptions: [subscription])
    sign_in(super_admin)

    visit(edit_subscription_path(subscription.id))

    expect(page).to have_field('Email', with: subscription.email, disabled: true)
  end

  def sign_in(user)
    visit new_login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
  end
end

