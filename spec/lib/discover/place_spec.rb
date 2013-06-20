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
  end
end
