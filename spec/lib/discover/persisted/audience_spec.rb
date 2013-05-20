require 'spec_helper'
require 'mongoid_helper'

require 'discover/audience'
require 'discover/topic'
require 'discover/changes'

require 'discover/persisted/audience'

module Discover
  describe AudienceRepository do
    let(:audience) { Discover::Audience.new("description") }
    let(:topic) { Discover::Topic.new("name") }

    def create_audience!
      subject.audience_created(Changes::AudienceCreated.new(audience))
    end

    def create_topic!
      subject.topic_created(Changes::TopicCreated.new(topic))
    end

    it "creates new audiences when receiving the correct change command" do
      create_audience!
      expect(subject.active_audiences).to eq [audience]
    end

    it "finds audiences by slug" do
      expect { subject.audience_from_slug(audience.slug) }.to raise_error(NoAudienceFoundError)

      create_audience!

      expect(subject.audience_from_slug(audience.slug)).to eq audience
    end

    it "finds topics by slug" do
      expect { subject.topic_from_slug(topic.slug) }.to raise_error(NoTopicFoundError)

      create_topic!

      expect(subject.topic_from_slug(topic.slug)).to eq topic
    end

    it "creates topics" do
      create_topic!
      expect(subject.topics).to eq [topic]
    end

    it "attaches audiences to topics" do
      create_audience!
      create_topic!
      subject.topic_attached_to_audience(Changes::TopicAttachedToAudience.new(audience, topic))
      expect(subject.audience_from_slug(audience.slug).topics).to eq [topic]
    end
  end
end
