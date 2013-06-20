require 'spec_helper'

require 'discover/place_validator'
require 'discover/place'
require 'discover/changes'

module Discover
  describe PlaceValidator do
    it 'returns a valid place if there is a name' do
      topic = Place.new('foo')
      expect(subject.validate(topic).first).
        to be_a(Changes::ValidPlace)
    end

    it 'returns a invalid place if there is no name' do
      topic = Place.new('')
      expect(subject.validate(topic).first).
        to be_a(Changes::InvalidPlace)
    end
  end
end
