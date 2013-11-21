module Discover
  class Image < Struct.new(:path, :bucket)
    DEFAULT_BUCKET = 'discover-thamesmead-website-images'
    DEFAULT_PATH = 'placeholder.jpg'

    def initialize(*)
      super
      self.path = DEFAULT_PATH if self.path.nil? || self.path == ''
      self.bucket ||= DEFAULT_BUCKET
    end

    def filename
      File.basename(path)
    end

    def url
      "https://s3.amazonaws.com/#{bucket}/#{path}"
    end
  end
end
