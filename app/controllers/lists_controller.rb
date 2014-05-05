class ListsController < ApplicationController
  def edit_subscriptions
    # Neccessary for the shared form.
    @subscription = Subscription.new
  end

  def update
    if @list.update(list_params)
      redirect_to edit_list_path(@list), notice: "✓ Options saved."
    else
      render 'edit'
    end
  end

  private 

  def list_params
    # TODO: refine
    params.require(:list).permit!
  end
end
