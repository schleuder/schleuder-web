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

  def checkbox(form, field, hint)
    label = "#{field.to_s.humanize}?"
    form.input field, label: label, hint: hint, as: :boolean, boolean_style: :inline
  end
end
