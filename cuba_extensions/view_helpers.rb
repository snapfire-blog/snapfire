module ViewHelpers
  def link(text=target, target)
    "<a href=\"#{target}\">#{text}</a>"
  end
end

Cuba.plugin ViewHelpers
