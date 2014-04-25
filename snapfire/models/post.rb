require "cuba/contrib"
Post = Struct.new(:title, :content) do
  include Cuba::TextHelpers
  attr_reader :title
  attr_reader :content
  attr_reader :slug

  def initialize(title: nil, content: "", slug: nil)
    raise ArgumentError, "Title argument is required" unless title
    @title   = title
    @content = content
    @slug    = slug || generate_slug
  end

  private

  def generate_slug
    underscore(title)
  end
end
