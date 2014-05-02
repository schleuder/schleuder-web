class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :load_resource, except: [:index, :new, :create]

  helper_method :current_user

  def current_user
    Account.find(1)
  end

  private

  def load_resource
    var_name = controller_name.singularize
    var = controller_name.classify.constantize.find(params[:id])
    instance_variable_set("@#{var_name}", var)
  end
end
