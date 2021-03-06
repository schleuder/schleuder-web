module ApplicationHelper
  def make_breadcrumb
    url_for.split('/').map do |part|
      # Skip IDs, we use the instance variable to go easier on the database.
      next if part.to_i > 0 || part.blank?

      obj = instance_variable_get("@#{part.singularize}")
      # Don't link action's names ("edit").
      next if obj.blank? && !current_page?(action: :index)

      index_url = url_for(controller: part, action: :index)
      index_name = part.humanize.pluralize.titleize
      out = bc_part(index_name, index_url)

      if obj
        if obj.id
          obj_url = url_for(controller: part, action: :show, id: obj.id)
          out << bc_part(obj.email, obj_url)
        else
          out << bc_part(obj.email.presence || 'New', nil)
        end
      end
      out
    end.compact.join.html_safe
  end

  def bc_part(name, url)
    " » #{link_to_unless(current_page?(url), name, url)}"
  end

  def key_as_ascii(key)
    GPGME::Key.export key.fingerprint, armor: true
  end

  def checkbox(form, field, hint, label=nil)
    label ||= "#{field.to_s.humanize}?"
    form.input field, hint: hint, label: label, as: :boolean, wrapper: :horizontal_boolean
  end

  def generate_h1
    t = "Schleuder"
    if @title.present?
      t << " ★ #{@title}"
    end
    if @list.present?
      t << " ★ #{@list.email}"
    end
    t
  end

  def key_trust_title(key)
    t('keys.show.key_is_', status: t("keys.statuses.#{key.trust_issues}"))
  end

  def popup(icon, &block)
    render('popup', icon: icon, text: capture { block.call })
  end

  def class_for_icon(name)
    "icon_#{File.basename(name, ".*")}"
  end
end
