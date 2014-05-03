class LoginsController < ApplicationController
  skip_before_filter :authenticate
  skip_before_filter :load_resource

  def cookiesrequired
    if session[:cookietest] == true
      redirect_to new_login_url
    end
  end

  def new
    # No session-cookie means first request or cookies disabled. If it's the
    # first request the cookierequired-test will redirect back here and then
    # we've got a session.
    if cookies[sessionkey].blank?
      session[:cookietest] = true
      redirect_to cookiesrequired_login_url
      return
    end
  end

  def create
    account = Account.find_by(email: params[:email])
    if account.try(:authenticate, params[:password])
      session[:current_account_id] = account.id
      update_session_expiry
      if session[:return_to].present?
        redirect_to session[:return_to]
        session[:return_to] = nil
      else
        redirect_to account
      end
    else
      flash[:error] = 'Wrong email-address or password, please try again.'
      render :new, :status => 401
    end
  end

  def destroy
    log_out "Logout successful. Have a nice day!"
  end

  private

  def sessionkey
    Rails.application.config.session_options[:key]
  end
end
