class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate
  load_and_authorize_resource
  # ensure authorization is checked.
  check_authorization

  helper_method :current_account
  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound, ActiveResource::ResourceNotFound do |exception|
    render_404
  end

  rescue_from CanCan::AccessDenied do |exception|
    render 'errors/403', :status => :forbidden
  end

  rescue_from ActiveResource::BadRequest do |exc|
    logger.error "API response: #{exc.response}"
    logger.error "API response headers: #{exc.response.to_hash.inspect}"
    logger.error "API response body: #{exc.response.body}"
    raise exc
  end

  rescue_from Errno::ECONNREFUSED do |exc|
    logger.error exc.inspect
    logger.error exc.backtrace.join("\n")
    render 'errors/missing_schleuderd', status: 500
  end

  private

  def render_404
    render 'errors/404', :status => :not_found
  end

  def current_account
    @current_account ||= session[:current_account_id] &&
        Account.find(session[:current_account_id])
  end
  # Many expect current_user()
  alias_method :current_user, :current_account

  def current_account=(account)
    @current_account = account
  end

  def update_session_expiry
    if current_account
      session[:login_expires_at] = 30.minutes.from_now
    end
  end

  def authenticate
    expiry = Time.parse(session[:login_expires_at])
    if current_account && expiry > Time.now
      update_session_expiry
    else
      session[:return_to] = request.fullpath
      log_out "Please log in!"
    end
  rescue => e
    logger.error "Error: #{e}"
    log_out "Error.", :error
  end

  def log_out(msg, msg_type=:notice)
    current_account = session[:current_account_id] = nil
    redirect_to new_login_url, msg_type => msg
  end

  def load_resource
    var_name = controller_name.singularize
    var = controller_name.classify.constantize.find(params[:id])
    instance_variable_set("@#{var_name}", var)
  end
end
