require 'rails_helper'

describe PR::Common::Redactable do
  class RedactableDummy
    include PR::Common::Redactable

    attr_accessor :email, :unique_email, :name, :unique_name

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
    before { dummy.redact! }

    it 'changes email to a non-unique redacted email based on support email' do
      expect(dummy.email).to eq 'REDACTED@pluginuseful.com'
    end

    it 'changes unique_email to a unique redacted email with a UUID based on support email' do
      expect(dummy.unique_email).to match(
        /\AREDACTED-\w{8}-\w{4}-\w{4}-\w{4}-\w{12}@pluginuseful\.com\z/
      )
    end

    it 'changes name to a redacted string' do
      expect(dummy.name).to eq 'REDACTED'
    end

    it 'changes unique_name to a unique redacted string with a UUID' do
      expect(dummy.unique_name).to match(/\AREDACTED-\w{8}-\w{4}-\w{4}-\w{4}-\w{12}\z/)
    end
  end
end
