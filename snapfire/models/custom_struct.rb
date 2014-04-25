class CustomStruct < Struct
  def initialize(args={})
    args.each do |k,v|
      self.send("#{k}=", v)
    end
  end

  def ==(other)
    if other.is_a? self.class
      super
    else
      members.all?{ |attr| other.respond_to?(attr)} &&
        members.all?{ |attr| self.public_send(attr) == other.send(attr)}
    end
  end
end
