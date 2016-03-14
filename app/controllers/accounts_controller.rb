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
      redirect_to new_account_path, alert: res
    end
  end

  def not_found(msg)
    redirect_to root_url, alert: msg
  end

  def setup
    ac_req = AccountRequest.find_by_token!(params[:token])

    if ! ac_req.still_valid?
      render text: 'This request-token is too old, please create a new account request'
      ac_req.destroy
      return
    end

    @account = Account.new
    @account.email = ac_req.email
    @token = ac_req.token
  end

  def create
    ac_req = AccountRequest.find_by_token!(params[:token])
    if ! res = ac_req.destroy
      logger.error "Deleting AccountRequest failed: #{res.inspect} —— AccountRequest: #{ac_req.inspect}"
      redirect_to setup_account_path, alert: "Something went wrong, please try again"
      return
    end

    @account = Account.new(account_params)
    @account.email = ac_req.email
    if @account.save
      redirect_to new_login_path, notice: 'Account creation successful! Please log in to your new account.'
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
      redirect_to account, alert: "Deleting account failed!"
    end
  end

  private

  def render_404
    render '404', :status => :not_found
  end

  def account_params
    params.require(:account).permit(:password, :password_confirmation)
  end
end
