require 'rails_helper'

describe PR::Common::Redactable do
  class RedactableDummy
    include PR::Common::Redactable

    CALL_PROC_AFTER_REDACTION =  -> {}

    attr_accessor :email, :unique_email, :name, :unique_name

    after_redaction CALL_PROC_AFTER_REDACTION
    after_redaction :call_method_after_redaction

    redactable :email, :email
    redactable :unique_email, :email, unique: true
    redactable :name, :string
    redactable :unique_name, :string, unique: true

    def initialize(attributes = {})
      attributes.each { |attr, value| instance_variable_set(:"@#{attr}", value) }
    end

    def update!(attributes = {})
      attributes.each { |attr, value| send(:"#{attr}=", value) }
    end

    def call_method_after_redaction; end
  end

  let(:dummy) do
    RedactableDummy.new(
      email: 'help@schembri.me',
      unique_email: 'jamie@pluginuseful.com',
      name: 'Plug in Useful',
      unique_name: 'Jamie Schembri'
    )
  end

  describe '#redact!' do
    it 'changes email to a non-unique redacted email based on support email' do
      dummy.redact!

      expect(dummy.email).to eq 'REDACTED@pluginuseful.com'
    end

    it 'changes unique_email to a unique redacted email with a UUID based on support email' do
      dummy.redact!

      expect(dummy.unique_email).to match(
        /\AREDACTED-\w{8}-\w{4}-\w{4}-\w{4}-\w{12}@pluginuseful\.com\z/
      )
    end

    it 'changes name to a redacted string' do
      dummy.redact!

      expect(dummy.name).to eq 'REDACTED'
    end

    it 'changes unique_name to a unique redacted string with a UUID' do
      dummy.redact!

      expect(dummy.unique_name).to match(/\AREDACTED-\w{8}-\w{4}-\w{4}-\w{4}-\w{12}\z/)
    end

    it 'calls a method defined after redaction' do
      expect(dummy).to receive(:call_method_after_redaction).once

      dummy.redact!
    end

    it 'calls a proc defined for after redaction' do
      expect(RedactableDummy::CALL_PROC_AFTER_REDACTION).to receive(:call).once

      dummy.redact!
    end
  end
end
