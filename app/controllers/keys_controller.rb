class KeysController < ApplicationController
  include KeyUpload
  skip_load_and_authorize_resource
  skip_authorization_check
  before_action :load_list_resource
  before_action :load_subscription_resource, only: [:index, :show, :new]
  before_action :load_key, only: [:show, :destroy]
  # TODO: authorize if current_account.subscribed_to?(@list) || current_account.superadmin?

  def index
    @assigned_keys = {}
    @unassigned_keys = []
    all_keys = @list.keys - [@list.key]
    # Show key<->subscription associations only if current_user is admin.
    if current_user.superadmin? || current_user.admin_lists.include?(@list)
      subs_by_fingerprint = @list.subscriptions.group_by(&:fingerprint)
      all_keys.each do |key|
        if subs_by_fingerprint[key.fingerprint].present?
          @assigned_keys[key] = subs_by_fingerprint[key.fingerprint]
        else
          @unassigned_keys << key
        end
      end
    else
      @unassigned_keys = all_keys
    end
  end

  def create
    input = select_key_material
    if input.blank?
      flash[:alert] = 'No input found'
      return redirect_to action: 'index'
    end

    logger.info "input: #{input.inspect}"
    # ActiveResource doesn't want to use query-params with create(), so here
    # list_id is included in the request-body.
    import_result = Key.create(keymaterial: input, list_id: @list.id)
    # TODO: Maybe move the interpretation of the import-result into the
    # API-daemon? schleuder-cli is doing the same interpretation, too.
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
    if @list.may_delete_keys?(current_account)
      # destroy() doesn't read any params, but we need to give the list_id.
      if Key.delete(@key.fingerprint, {list_id: @list.id})
        redirect_to list_keys_path(@list), notice: "Key deleted: #{@key.fingerprint}"
      else
        redirect_to list_key_path(@list, @key), alert: "Deleting key failed: #{@key.errors.full_messages}"
      end
    else
      redirect_to list_keys_path(@list), notice: 'Only allowed for list admins'
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
