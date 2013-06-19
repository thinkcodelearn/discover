require 'spec_helper'

require 'discover/audience_validator'
require 'discover/audience'
require 'discover/changes'

module Discover
  describe AudienceValidator do
    subject { AudienceValidator.new(['foo', 'bar', 'baz']) }
    it "accepts a list of existing descriptions" do
      subject
    end

    it "returns audience creation changes if the audience has a description" do
      audience = Audience.new("new description")
      expect(subject.validate(audience)).
        to eq([Changes::AudienceCreated.new(audience)])
    end

    it 'returns a creation error if there is no description' do
      audience = Audience.new
      expect(subject.validate(audience).first).
        to be_a(Changes::CreationError)
    end

    it 'returns a creation error if the description is not unique' do
      audience = Audience.new('foo')
      expect(subject.validate(audience).first).
        to be_a(Changes::CreationError)
    end
  end
end
