class Ability
  include CanCan::Ability
  def initialize(account)
    account ||= Account.new
    if account.email == 'root@localhost'
      can :manage, :all
    else
      # Own account
      can [:read, :update, :destroy], Account, id: account.id
      # Own subscriptions
      can [:read, :update, :destroy], Subscription, email: account.email
      # All subscriptions of lists it admins
      can :manage, Subscription, account.lists.map(&:id).include?(:list_id)
      # All lists it admins
      can [:read, :update], List, account.admin_lists.map(&:id).include?(:id)
    end
  end
end

