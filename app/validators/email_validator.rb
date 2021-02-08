class EmailValidator <  ActiveModel::EachValidator
  EMAIL_REGEXP = /\A.+@[[:alnum:]_.-]+\z/i
  def validate_each(record, attribute, value)
    unless value =~ EMAIL_REGEXP
      record.errors.add(attribute, options[:message] || I18n.t("errors.invalid_email"))
    end
  end
end
