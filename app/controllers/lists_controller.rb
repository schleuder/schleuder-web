class ListsController < ApplicationController
  skip_load_and_authorize_resource only: :create

  def edit_subscriptions
    # Neccessary for the shared form.
    @subscription = Subscription.new
  end

  def create
    @list = List.new(list_params)
    authorize! :create, @list
    if @list.save
      redirect_to @list, notice: "✓ List created."
    else
      render 'new'
    end
  end

  def update
    if @list.update(list_params)
      redirect_to edit_list_path(@list), notice: "✓ Options saved."
    else
      render 'edit'
    end
  end

  def destroy
    if list = @list.destroy
      redirect_to current_account, notice: "✓ List #{list} deleted."
    else
      redirect_to list, error: "Deleting list failed!"
    end
  end

  private 

  def list_params
    # TODO: refine
    params.require(:list).permit!
  end
end
