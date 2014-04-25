Post = Struct.new(:title, :content) do
  attr_reader :title
  attr_reader :content

  def initialize(title: "", content: "")
    @title   = title
    @content = content
  end
end
