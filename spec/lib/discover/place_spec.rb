require 'spec_helper'

require 'discover/place'

module Discover
  describe Place do
    it 'generates slugs if one is not specified' do
      expect(Place.new('name', 'specified-slug').slug).to eq('specified-slug')
      expect(Place.new('job centRes!!').slug).to eq('job-centres--')
    end

    it 'initialises name to empty' do
      expect(Place.new.name).to eq('')
    end

    it 'sets lat/lng to default' do
      expect(Place.new.lat).to eq(Place::DEFAULT[:lat])
      expect(Place.new.lng).to eq(Place::DEFAULT[:lng])
    end

    it 'auto-adds https to links if not there' do
      place = Place.new
      expect(place.url).to eq("")
      place.url = "http://google.com"
      expect(place.url).to eq("http://google.com")
      place.url = "https://google.com"
      expect(place.url).to eq("https://google.com")
      place.url = "google.com"
      expect(place.url).to eq("http://google.com")
    end
  end
end
