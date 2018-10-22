module PR::Common::Redactable
  extend ActiveSupport::Concern

  REDACTED_STRING = 'REDACTED'.freeze

  class_methods do
    attr_reader :redactables
    attr_reader :after_redaction_actions

    # Accepts a proc or symbol detailing what to do after redaction
    def after_redaction(method_name_or_proc)
      @after_redaction_actions ||= []

      @after_redaction_actions << method_name_or_proc
    end

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

    self.class.after_redaction_actions.each do |redaction_action|
      redaction_action.respond_to?(:call) ? redaction_action.call : send(redaction_action)
    end
  end
end
