class KeysController < ApplicationController
  skip_load_and_authorize_resource
  skip_authorization_check
  before_filter :load_list_resource
  before_filter :load_subscription_resource, only: [:index, :show, :new]
  before_filter :load_key, only: [:show, :destroy]
  # TODO: authorize if current_account.subscribed_to?(@list) || current_account.superadmin?

  def index
    all_keys = @list.keys
    @subscriptions = @list.subscriptions
    sub_fingerprints = @subscriptions.map(&:fingerprint)
    @assigned_keys = all_keys.select do |key|
      sub_fingerprints.include?(key.fingerprint)
    end
    @unassigned_keys = all_keys - @assigned_keys - [@list.key]
  end

  def create
    if params[:ascii].present?
      input = params[:ascii]
    elsif params[:keyfile].present?
      input = params[:keyfile].read
    else
      flash[:alert] = 'No input found'
      return redirect_to action: 'index'
    end

    if ! input.match('BEGIN PGP')
      # Input appears to be binary
      input = Base64.encode64(input)
    end

    logger.info "input: #{input.inspect}"
    # ActiveResource doesn't want to use query-params with create(), so here
    # list_id is included in the request-body.
    import_result = Key.create(keymaterial: input, list_id: @list.id)
    if import_result.considered == 0
      # Can't use :error as argument to redirect_to()
      flash[:error] = 'No keys found in input'
      redirect_to list_key_new_path(@list)
    else
      msg = import_result.imports.map do |import_status|
        [import_status.fpr, import_status.action].join(': ')
      end.join(', ')
      redirect_to list_keys_path(@list), notice: msg
    end
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

  def load_subscription_resource
    @subscription = current_account.subscription(@list)
  end
end
