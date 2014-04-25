class Repository
  include Enumerable

  def initialize( source: {},
                  main_class: nil)
    raise ArgumentError, "You must specify a source and main_class" if main_class.nil?
    @source = source
    @main_class = main_class
  end

  def each
    all.each do |item|
      yield item
    end
  end

  private
  attr_reader :source
  attr_reader :main_class


  def construct_from_object(obj)
    return nil unless obj
    obj = OpenStruct.new(obj) if obj.is_a? Hash
    if obj.is_a? main_class
      obj
    else
      main_class.members.each do |attr|
        attrs[attr] = obj.send(attr)
      end
      main_class.new(attrs)
    end

  end
end
