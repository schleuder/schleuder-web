class KeysController < ApplicationController
  skip_load_and_authorize_resource
  skip_authorization_check
  before_filter :load_list_resource
  before_filter :load_key, only: [:show, :destroy]

  def index
    @keys = @list.keys
  end

  def create
    # TODO: file upload for binary encoded keys.
    # ActiveResource doesn't want to use query-params with create(), so here
    # list_id is included in the request-body.
    import_result = Key.create(ascii: params[:ascii], list_id: @list.id)
    if import_result.considered == 0
      flash[:error] = 'No keys found in input'
    else
      msg = import_result.imports.map do |import_status|
        [import_status.fpr, import_status.action].join(': ')
      end.join(', ')
      flash[:notice] = msg
    end
    redirect_to list_keys_path(@list), notice: msg
  end

  def destroy
    # destroy() doesn't read any params, but we need to give the list_id.
    if Key.delete(@key.fingerprint, {list_id: @list.id})
      redirect_to list_keys_path(@list), notice: "Key deleted: #{@key.fingerprint}"
    else
      redirect_to list_key_path(@list, @key), alert: "Deleting key failed: #{@key.errors.full_messages}"
    end
  end

  private

  def load_key
    @key = @list.keys(params[:fingerprint])
  end

  def load_list_resource
    @list = List.find(params[:list_id])
  end
end
