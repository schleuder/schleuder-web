class Ability
  include CanCan::Ability
  def initialize(account)
    account ||= Account.new
    if account.superadmin?
      can :manage, :all
    else
      # Everybody: Setup+Create accounts
      can [:create, :verify, :setup], Account
      # Mere subscriber
      can [:read, :update, :destroy], Account, id: account.id
      can [:read, :update, :destroy], Subscription, email: account.email
      can [:read], List, id: account.subscriptions.map(&:list).map(&:id)
      # List-admins
      can :manage, Subscription, list_id: account.admin_lists.map(&:id)
      can [:read, :update, :edit_subscriptions], List, id: account.admin_lists.map(&:id)
    end
  end
end

