require 'spec_helper'
require 'mongoid_helper'

require 'discover/audience'
require 'discover/topic'
require 'discover/place'
require 'discover/changes'
require 'discover/reactor'

require 'discover/persisted/audience'

module Discover
  describe AudienceRepository do
    let(:audience) { Discover::Audience.new("description") }
    let(:topic) { Discover::Topic.new("name") }
    let(:place) { Discover::Place.new("name", "information", 50, -1) }

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

    it "edits audiences" do
      create_audience!
      create_topic!
      new_audience = Audience.new("new_description", nil, [topic])
      subject.apply([Changes::AudienceEdited.new(audience.slug, new_audience)])
      saved_audience = subject.audience_from_slug(audience.slug)
      expect(saved_audience.description).to eq "new_description"
      expect(saved_audience.topics).to eq [topic]
    end

    it "adds places to topics" do
      create_topic!
      subject.place_added_to_topic(Changes::PlaceAddedToTopic.new(topic, place))

      expect(subject.topic_from_slug(topic.slug).places).to eq [place]
    end
  end
end
