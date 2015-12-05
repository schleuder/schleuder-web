class KeysController < ApplicationController
  skip_load_and_authorize_resource
  skip_authorization_check
  before_filter :load_list_resource

  def index
    @keys = @list.keys
  end

  def show
    @key = @list.keys(params[:fingerprint])
  end

  def create
    # TODO: file upload for binary encoded keys.
    # ActiveResource doesn't want to use query-params with create(), so here
    # list_id is included in the request-body.
    import_result = Key.create(ascii: params[:ascii], list_id: @list.id)
    # TODO: improve feedback
    redirect_to @list, notice: "#{import_result.considered} key(s) considered for import. Result: #{import_result.imports.inspect}"
  end

  private

  def load_list_resource
    @list = List.find(params[:list_id])
  end
end
