class KeysController < ApplicationController
  skip_load_and_authorize_resource
  skip_authorization_check
  before_filter :load_list_resource

  def index
    @keys = @list.keys
  end

  def show
    @key = @list.keys(params[:fingerprint]).first
  end

  def destroy
  end

  def create
    # TODO: file upload for binary encoded keys.
    import_result = GPGME::Key.import(params[:ascii])
    # TODO: improve feedback
    redirect_to @list, notice: import_result
  end

  private

  def load_list_resource
    @list = List.find(params[:list_id])
  end
end
