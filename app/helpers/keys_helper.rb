module KeysHelper
  def key_css_classes(key)
    classes = ["key-oneline mono"]
    if key.fingerprint == @list.fingerprint
      classes << "listkey"
    end
    if key.trust_issues.present?
      classes << "warn"
    end
    classes.join(' ')
  end
end
