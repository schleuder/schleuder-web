class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to @account, notice: '✓ Password changed.'
    else
      render :edit
    end
  end

  def index
  end

  def show
  end

  def destroy
  end

  private

  def account_params
    params.require(:account).permit([:password, :password_confirmation])
  end
end
