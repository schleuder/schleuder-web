class SubscriptionsController < ApplicationController
  skip_load_and_authorize_resource only: [:create]

  def edit
    # Neccessary for the shared form.
    @list = @subscription.list
  end

  def update
    # Load resource manually as cancan doesn't use strong-parameters (yet).
    if @subscription.update_attributes(subscription_params)
      redirect_to edit_subscription_path(@subscription),
          notice: "✓ Subscription of #{@subscription} updated."
    else
      render 'edit'
    end
  end

  def create
    # Load resource manually as cancan doesn't use strong-parameters (yet).
    @subscription = Subscription.new(subscription_params)
    authorize! :create, @subscription
    if @subscription.save
      redirect_to edit_list_subscriptions_path(@subscription.list),
          notice: "✓ #{@subscription} subscribed."
    else
      render 'edit',
          error: "Failed to save!"
    end
  end

  def destroy
    sub = @subscription
    if @subscription.destroy
      redirect_to edit_list_subscriptions_path(sub.list),
          notice: "✓ #{sub} unsubscribed."
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
