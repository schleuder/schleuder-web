class ListsController < ApplicationController
  def update
    if @list.update(list_params)
      redirect_to @list, notice: "✓ Options saved."
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
