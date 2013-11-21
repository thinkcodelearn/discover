require 'spec_helper'

require 'discover/image'

module Discover
  describe Image do
    subject { Image.new('path/to/image.png', 'bucket') }

    it 'displays basic filename' do
      expect(subject.filename).to eq('image.png')
    end

    it 'displays full url' do
      expect(subject.url).to eq('https://s3.amazonaws.com/bucket/path/to/image.png')
    end
  end
end
