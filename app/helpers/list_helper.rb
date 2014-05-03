module ListHelper
  def table_row_title(subscription)
    title = []
    if subscription.admin?
      title << 'Admin'
    end
    if subscription.delivery_disabled?
      title << 'Delivery disabled'
    end
    title.join(', ')
  end
end
