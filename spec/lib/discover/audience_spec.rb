require 'spec_helper'

require 'discover/audience'

module Discover
  describe Audience do
    it 'generates slugs if one is not specified' do
      expect(Audience.new('description', 'specified-slug').slug).to eq('specified-slug')
      expect(Audience.new('I am looking for work').slug).to eq('i-am-looking-for-work')
    end

    it 'initialises topics to an empty array if nil' do
      expect(Audience.new('description').topics).to eq([])
    end

    it 'initialises description to empty' do
      expect(Audience.new.description).to eq('')
    end
  end
end
