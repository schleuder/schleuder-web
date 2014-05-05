class SubscriptionsController < ApplicationController
  skip_load_and_authorize_resource only: [:create]

  def create
    # Load resource manually as cancan doesn't use strong-parameters (yet).
    @subscription = Subscription.new(subscription_params)
    authorize! :create, @subscription

    if @subscription.save
      redirect_to edit_list_path(@subscription.list),
          notice: "✓ #{@subscription} subscribed."
    else
      redirect_to :back,
          error: "Failed to subscribe #{@subscription}."
    end
  end

  def destroy
    if sub = @subscription.destroy
      redirect_to edit_list_path(sub.list),
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
        :delivery_disabled,
        :list_id
    )
  end
end
