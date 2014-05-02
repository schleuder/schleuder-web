module Mail
  # TODO: maybe subclass? But maybe that breaks integration of mail-gpg?
  class Message
    def keywords
      @keywords ||= begin
        # Parse only plain text for keywords.
        return [] if mime_type != 'text/plain'

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
    end

    def clean_copy(list)
      new = Mail.new
      new.from = list.email
      new.subject = self.subject
      new['in-reply-to'] = self.header['in-reply-to']
      new.references =  self.references
      # TODO: attachments
      
      # Insert Meta-Headers
      # TODO: why is :date blank?
      meta = [
        "From: #{self.header[:from].to_s}",
        "To: #{self.header[:to].to_s}",
        "Date: #{self.header[:date].to_s}",
        "Cc: #{self.header[:cc].to_s}"
      ]

      # Careful to add information about the incoming signature. GPGME throws
      # exceptions if it doesn't know the key.
      if result = self.verify_result
        sig = self.verify_result.signatures.first
        msg = begin
                sig.to_s
              rescue EOFError
                "Unknown signature by #{sig.fpr}"
              end
      else
        msg = "Unsigned"
      end
      meta << "Sig: #{msg}"
      # TODO: Enc:

      new.add_part Mail::Part.new() { body meta.join("\n") }
      new.add_part Mail::Part.new(self.raw_source)
      new
    end
  end
end
