module PR::Common::Redactable
  extend ActiveSupport::Concern

  REDACTED_STRING = 'REDACTED'.freeze

  class_methods do
    attr_reader :redactables

    def redactable(attribute, redactor, options = {})
      @redactables ||= []

      @redactables << OpenStruct.new(attribute: attribute, redactor: :"redact_#{redactor}", options: options)
    end

    def redact_email(options ={})
      Settings.support_email.match(/(?<domain>@.*\z)/) do |matches|
        to = REDACTED_STRING.dup
        to << "-#{SecureRandom.uuid}" if options[:unique]

        return "#{to}#{matches[:domain]}"
      end
    end

    def redact_string(options = {})
      return REDACTED_STRING unless options[:unique]

      "#{REDACTED_STRING}-#{SecureRandom.uuid}"
    end
  end

  # Redacts all redactable fields and updates them in the database.
  def redact!
    return if self.class.redactables.blank?

    new_attributes = Hash[
      self.class.redactables.map do |redactable|
        new_value = self.class.send(redactable.redactor, redactable.options)

        [redactable.attribute, new_value]
      end
    ]

    update!(new_attributes)
  end
end
