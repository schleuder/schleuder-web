class SubscriptionsController < ApplicationController
  include KeyUpload
  skip_load_and_authorize_resource only: [:create]

  def index
    redirect_to root_path
  end

  def show
    @list = @subscription.list
    @key = @subscription.key
  end

  def edit
    # Necessary for the shared form.
    @list = @subscription.list
  end

  def update
    args = subscription_params
    args[:key_material] = select_key_material
    if @subscription.update_attributes(args)
      put_api_messages_as_flash_error
      msg = "✓ Subscription of #{@subscription} updated."
      if can?(:manage, @subscription.list)
        redirect_to subscription_path(@subscription), notice: msg
      else
        redirect_to edit_subscription_path(@subscription), notice: msg
      end
    else
      @list = @subscription.list
      render 'edit'
    end
  end

  def create
    args = subscription_params
    args[:key_material] = select_key_material
    # Load resource manually as cancan doesn't use strong-parameters (yet).
    @subscription = Subscription.new(args)
    authorize! :create, @subscription
    logger.debug "Subscriptions to be saved: #{@subscription.inspect}"
    if @subscription.save
      put_api_messages_as_flash_error
      logger.debug "Saving successful"
      redirect_to subscription_path(@subscription.id),
          notice: "✓ #{@subscription} subscribed."
    else
      logger.debug "Saving failed. Errors: #{@subscription.errors.inspect}"
      @list = @subscription.list
      render 'edit',
          error: "Failed to save!"
    end
  end

  def delete
    # Assign list-variable to make the list-menu appear.
    @list = @subscription.list
  end

  def destroy
    if @subscription.is_last_admin?
      flash_error t(".cant_unsubscribe_last_admin")
      redirect_to subscription_path(@subscription)
      return
    end

    sub = @subscription
    if @subscription.destroy
      msg = "✓ #{sub} unsubscribed from #{sub.list.email}."
      if can?(:update, sub.list)
        redirect_to list_subscriptions_path(sub.list), notice: msg
      else
        redirect_to account_path(current_account), notice: msg
      end
    else
      redirect_to @subscription.list,
          error: "Unsubscribing #{subscription} failed: #{@subscription.errors}."
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(
        :email,
        :fingerprint,
        :admin,
        :delivery_enabled,
        :list_id
    )
  end
end
