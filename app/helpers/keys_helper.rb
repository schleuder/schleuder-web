module KeysHelper
  def key_css_classes(key)
    classes = ["mono"]
    if key.fingerprint == @list.fingerprint
      classes << "listkey"
    end
    if key.trust_issues.present?
      classes << "text-danger"
    end
    classes.join(' ')
  end
end
