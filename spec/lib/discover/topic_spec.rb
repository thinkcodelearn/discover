require 'spec_helper'

require 'discover/topic'

module Discover
  describe Topic do
    it 'generates slugs if one is not specified' do
      expect(Topic.new('name', 'specified-slug').slug).to eq('specified-slug')
      expect(Topic.new('job centRes').slug).to eq('job-centres')
    end
  end
end
