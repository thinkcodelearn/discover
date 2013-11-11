require 'spec_helper'

require 'discover/topic'

module Discover
  describe Topic do
    it 'generates slugs if one is not specified' do
      expect(Topic.new('name', 'desc', 'specified-slug').slug).to eq('specified-slug')
      expect(Topic.new('job centRes!!').slug).to eq('job-centres--')
    end

    it 'initialises places to an empty array if nil' do
      expect(Topic.new('name').places).to eq([])
    end

    it 'initialises name to empty' do
      expect(Topic.new.name).to eq('')
    end

    it 'initialises description to empty' do
      expect(Topic.new.description).to eq('')
    end
  end
end
