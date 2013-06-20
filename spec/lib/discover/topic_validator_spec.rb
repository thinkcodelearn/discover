require 'spec_helper'

require 'discover/topic_validator'
require 'discover/topic'
require 'discover/changes'

module Discover
  describe TopicValidator do
    subject { TopicValidator.new(['foo', 'bar', 'baz']) }
    it "accepts a list of existing names" do
      subject
    end

    it "returns topic creation changes if the topic has a name" do
      topic = Topic.new("new name")
      expect(subject.validate(topic)).
        to eq([Changes::ValidTopic.new(topic)])
    end

    it 'returns a creation error if there is no name' do
      topic = Topic.new
      expect(subject.validate(topic).first).
        to be_a(Changes::InvalidTopic)
    end

    it 'returns a creation error if the name is not unique' do
      topic = Topic.new('Foo')
      expect(subject.validate(topic).first).
        to be_a(Changes::InvalidTopic)
    end
  end
end
