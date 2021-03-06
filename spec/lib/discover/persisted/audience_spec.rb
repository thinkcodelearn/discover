require 'spec_helper'
require 'mongoid_helper'

require 'discover/audience'
require 'discover/topic'
require 'discover/place'
require 'discover/image'
require 'discover/changes'
require 'discover/reactor'

require 'discover/persisted/audience'

module Discover
  describe AudienceRepository do
    let(:audience) { Discover::Audience.new("description") }
    let(:topic) { Discover::Topic.new("name") }
    let(:place) { Discover::Place.new("name", nil, "information", 50, -1) }

    def create_audience!
      subject.audience_created(Changes::AudienceCreated.new(audience))
    end

    def create_topic!
      subject.topic_created(Changes::TopicCreated.new(topic))
    end

    def create_place!
      subject.place_created(Changes::PlaceCreated.new(place))
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

    it "creates and retrieves places" do
      create_place!
      expect(subject.places).to eq [place]
      expect(subject.place_from_slug(place.slug)).to eq place
    end

    it 'deletes places' do
      create_place!
      subject.apply([Changes::PlaceDeleted.new(place.slug)])
      expect { subject.place_from_slug(place.slug) }.to raise_error(NoPlaceFoundError)
    end

    it "edits audiences" do
      create_audience!
      create_topic!
      new_audience = Audience.new("new_description", nil, [topic.slug])
      subject.apply([Changes::AudienceEdited.new(audience.slug, new_audience)])
      saved_audience = subject.audience_from_slug(audience.slug)
      expect(saved_audience.description).to eq "new_description"
      expect(saved_audience.topics).to eq [topic.slug]
    end

    it 'deletes audiences' do
      create_audience!
      subject.apply([Changes::AudienceDeleted.new(audience.slug)])
      expect { subject.audience_from_slug(audience.slug) }.to raise_error(NoAudienceFoundError)
    end

    it "edits topics" do
      create_place!
      create_topic!
      new_topic = Topic.new("new_name", nil, nil, [place.slug], 'image-url')
      subject.apply([Changes::TopicEdited.new(topic.slug, new_topic)])
      saved_topic = subject.topic_from_slug(topic.slug)
      expect(saved_topic.name).to eq "new_name"
      expect(saved_topic.places).to eq [place.slug]
      expect(saved_topic.image).to eq "image-url"
    end

    it 'deletes topics' do
      create_place!
      create_topic!
      subject.apply([Changes::TopicDeleted.new(topic.slug)])
      expect { subject.topic_from_slug(topic.slug) }.to raise_error(NoTopicFoundError)
    end

    it 'adds uploaded images' do
      subject.apply([Changes::ImageUploaded.new("path", "bucket")])
      subject.available_images.size.should == 1
      subject.available_images.first.should == Image.new("path", "bucket")
    end
  end
end
