require 'spec_helper'
require 'mongoid_helper'

require 'discover/audience'
require 'discover/changes'

require 'discover/persisted/audience'

module Discover
  describe AudienceRepository do
    it "creates new audiences when receiving the correct change command" do
      audience = Discover::Audience.new("description")
      subject.audience_created(Changes::AudienceCreated.new(audience))
      subject.active.should == [audience]
    end
  end
end
