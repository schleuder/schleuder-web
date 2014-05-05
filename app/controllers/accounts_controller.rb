class AccountsController < ApplicationController
  skip_before_filter :authenticate, only: [:new, :verify, :setup, :create]
  skip_load_resource only: [:verify, :setup, :create]

  def verify
    # TODO: check that input actually is a valid email address.
    @email = params[:account][:email]
    if Account.where(email: @email).present?
      redirect_to new_account_path, alert: "Adress already registered for account."
      return
    end
    # TODO: Deny registration if address isn't subscribed?

    # TODO: rate-limit sending these
    ac_req = AccountRequest.create(email: @email)
    mail = AccountMailer.send_verification_link(@email, ac_req.token)
    if ! res = mail.deliver
      redirect_to new_account_path, error: res
    end
  end

  def setup
    if ! ac_req = AccountRequest.where(token: params[:token]).first
      render text: 'kaput'
      return
    end

    if ! ac_req.still_valid?
      render text: 'too late'
      return
    end

    @account = Account.new
    @account.email = ac_req.email
    @token = ac_req.token
  end

  def create
    @account = Account.new(account_params)
    ac_req = AccountRequest.where(token: params[:token]).first
    if ! ac_req
      render text: 'kaput'
      return
    end

    @account.email = ac_req.email
    if @account.save
      ac_req.destroy
      redirect_to new_login_path, notice: 'Welcome! Please log in to your new account!'
    else
      render 'setup'
    end
  end

  def update
    if @account.update(account_params)
      redirect_to @account, notice: '✓ Password changed.'
    else
      render :edit
    end
  end

  def show
    @subscribed_lists = @account.lists
    @admin_lists = if @account.superadmin?
                     List.all
                   else
                     @account.admin_lists
                   end
  end

  def destroy
    if account = @account.destroy
      log_out "You account was deleted. Have a nice day!"
    else
      redirect_to account, error: "Deleting account failed!"
    end
  end

  private

  def account_params
    params.require(:account).permit(:password, :password_confirmation)
  end
end
