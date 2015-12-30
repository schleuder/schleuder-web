class SubscriptionsController < ApplicationController
  skip_load_and_authorize_resource only: [:create]

  def edit
    # Neccessary for the shared form.
    @list = @subscription.list
  end

  def update
    # Load resource manually as cancan doesn't use strong-parameters (yet).
    if @subscription.update_attributes(subscription_params)
      msg = "✓ Subscription of #{@subscription} updated."
      if can?(:manage, @subscription.list)
        redirect_to edit_list_subscriptions_path(@subscription.list), notice: msg
      else
        redirect_to edit_subscription_path(@subscription), notice: msg
      end
    else
      render 'edit'
    end
  end

  def create
    # Load resource manually as cancan doesn't use strong-parameters (yet).
    @subscription = Subscription.new(subscription_params)
    authorize! :create, @subscription
    logger.debug "Subscriptions to be saved: #{@subscription.inspect}"
    if @subscription.save
      logger.debug "Saving successful"
      redirect_to edit_list_subscriptions_path(@subscription.list),
          notice: "✓ #{@subscription} subscribed."
    else
      logger.debug "Saving failed. Errors: #{@subscription.errors.inspect}"
      render 'edit',
          error: "Failed to save!"
    end
  end

  def destroy
    sub = @subscription
    if @subscription.destroy
      msg = "✓ #{sub} unsubscribed from #{sub.list.email}."
      if can?(:manage, sub.list)
        redirect_to edit_list_subscriptions_path(sub.list), notice: msg
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
    # TODO: allow email only if request method is post (i.e. on creating a new record)
    p = params.require(:subscription).permit(
        :email,
        :fingerprint,
        :admin,
        :delivery_enabled,
        :list_id
    )
    logger.debug "subscription_params: #{p.inspect}"
    p
  end
end
