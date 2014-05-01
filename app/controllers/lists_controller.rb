class ListsController < ApplicationController
  def index
    @lists = Subscription.where(
               subscriber_id: current_user.id,
               admin: true
             ).map(&:list)
  end

  def show
    @list = List.find(params[:id])
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
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
