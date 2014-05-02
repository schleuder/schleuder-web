class ListsController < ApplicationController
  def index
    @lists = current_user.subscriptions.where(admin: true).map(&:list)
  end

  def update
    if @list.update(list_params)
      redirect_to @list
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
