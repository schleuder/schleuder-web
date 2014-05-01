# TODO: maybe subclass? But maybe that breaks integration of mail-gpg?
module Mail
  class Message
    def keywords
      return @keywords if @keywords

      @keywords = []

      # Parse only plain text for keywords.
      return @keywords if mime_type != 'text/plain'

      # TODO: collect keywords while creating new mail as base for outgoing mails: that way we wouldn't need to change the body/part but rather filter the old body before assigning it to the new one. (And it helps also with having a distinct msg-id for all subscribers)

      # Look only in first part of message.
      part = multipart? ?  parts.first : body
      part = part.lines.map do |line|
        # TODO: find multiline arguments (add-key)
        # TODO: break after some data to not parse huge amounts
        if line.match(/^x-([^: ]*)[: ]*(.*)/i)
          @keywords << {$1.strip.downcase => $2.strip.downcase}
          nil
        else
          line
        end
      end.compact.join("\n")
    end

    class clean_copy(list)
      new = Mail.new
      new.from = list.email
      new.subject = self.subject
      new['in-reply-to'] = mail.header['in-reply-to']
      new.references =  mail.references
      new.body = self.body.to_s
    end
  end
end
