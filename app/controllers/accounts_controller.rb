class AccountsController < ApplicationController
  skip_before_action :authenticate, only: [:new, :verify, :setup, :create]
  skip_load_resource only: [:verify, :setup, :create]
  before_action :validate_turing_answer, only: :verify

  def index
    redirect_to root_path
  end

  def home
    @account = current_account
    show
    render 'show'
  end

  def new
    if TuringQuestion.available?
      @turing_question = TuringQuestion.random
      session[:turing_question_id] = @turing_question.id
    end
    @account = Account.new(email: session[:account_email])
    session[:account_email] = nil
  end

  def verify
    @email = params[:account][:email]
    if Account.where(email: @email).present?
      return redirect_to_new(t(".address_already_registered"))
    end

    ac_req = AccountRequest.create(email: @email)
    mail = AccountMailer.send_verification_link(@email, ac_req.token)
    if ! res = mail.deliver_now
      redirect_to_new(res)
    end
  rescue Errno::ECONNREFUSED => exc
    logger.error exc.message
    redirect_to_new(t(".smtp_connection_refused", error: exc.message))
  end

  def setup
    ac_req = AccountRequest.find_by_token!(params[:token])

    if ! ac_req.still_valid?
      render plain: t(".token_too_old")
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
      redirect_to setup_account_path, alert: t("something_went_wrong")
      return
    end

    @account = Account.new(account_params)
    @account.email = ac_req.email
    if @account.save
      redirect_to new_login_path, notice: t(".success")
    else
      render 'setup'
    end
  end

  def update
    if @account.update(account_params)
      redirect_to @account, notice: t(".password_changed")
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
    @lists = @subscribed_lists | @admin_lists
  end

  def destroy
    if @account.superadmin?
      redirect_to @account, alert: t(".superadmin_not_deletable")
      return
    end

    if account = @account.destroy
      log_out t(".success")
    else
      logger.error "Deleting account failed: #{account.inspect}"
      redirect_to account, alert: t(".failure")
    end
  end

  private

  def validate_turing_answer
    turing_question = TuringQuestion.find(session[:turing_question_id])
    session[:turing_question_id] = nil
    if turing_question.blank?
      return redirect_to_new(t("something_went_wrong"))
    end

    if turing_question.valid_answer?(params[:turing_answer])
      true
    else
      redirect_to_new(t(".invalid_answer"))
    end
  end

  def redirect_to_new(error_message)
    flash[:error] = error_message
    session[:account_email] = params[:account][:email]
    redirect_to new_account_path
    false
  end

  def render_404
    if params[:token].present?
      render 'error_404', :status => :not_found
    else
      super
    end
  end

  def account_params
    params.require(:account).permit(:password, :password_confirmation)
  end
end
