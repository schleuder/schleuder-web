require "rails_helper"

describe Account do
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :password_digest }

  it "is invalid when email does not contain an @" do
    account = build(:account, email: "foobar")

    expect(account).not_to be_valid
    expect(account.errors.messages[:email]).to include("is not a valid email address")
  end

  it "is not valid without an email address" do
    account = build(:account, email: "")

    expect(account).not_to be_valid
    expect(account.errors.messages[:email]).to include("can't be blank")
  end

  describe "#to_s" do
    it "returns the email"  do
      account = create(:account)

      expect(account.to_s).to eq account.email
    end
  end

  describe "#superadmin?" do
    it "returns true if email address is root@localhost" do
      admin_account = create(:account, email: "root@localhost")

      expect(admin_account.superadmin?).to eq true
    end

    it "returns false for another email address" do
      user_account = create(:account, email: "user@localhost")

      expect(user_account.superadmin?).to eq false
    end
  end
end
