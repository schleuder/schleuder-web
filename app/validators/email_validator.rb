class EmailValidator <  ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ URI::MailTo::EMAIL_REGEXP
      record.errors.add(attribute, options[:message] || I18n.t("errors.invalid_email"))
    end
  end
end
