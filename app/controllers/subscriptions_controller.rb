class SubscriptionsController < ApplicationController
  def create
    # TODO: use strong-parameters
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      redirect_to @subscription.list,
          notice: "#{@subscription} subscribed."
    else
      redirect_to :back,
          error: "Failed to subscribe #{@subscription}."
    end
  end

  def destroy
    if sub = @subscription.destroy
      redirect_to sub.list,
          notice: "#{sub} unsubscribed."
    else
      redirect_to @subscription.list,
          error: "Unsubscribing #{subscription} failed: #{@subscription.errors}."
    end
  end

  private

  def subscription_params
    # TODO: refine
    params.require(:subscription).permit!
  end
end
