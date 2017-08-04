class Ability
  include CanCan::Ability
  def initialize(account)
    account ||= Account.new
    if account.superadmin?
      can :manage, :all
    else
      # Everybody: Setup+Create accounts
      can [:create, :verify, :setup, :delete], Account
      # Mere subscriber
      can [:read, :update, :destroy, :home], Account, id: account.id
      can [:read, :update, :destroy], Subscription, email: account.email
      can [:read], List, id: account.subscriptions.map(&:list).map(&:id)
      # List-admins
      # Use a block, else it doesn't work for :create.
      can :manage, Subscription do |subscription|
        account.admin_lists.map(&:id).include?(subscription.list_id.to_i)
      end
      can [:read, :update, :new_subscription, :subscriptions], List, id: account.admin_lists.map(&:id)
    end
  end
end

