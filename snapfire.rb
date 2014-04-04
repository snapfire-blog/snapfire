require "cuba"
require "rack/protection"
require "cuba/render"

Cuba.plugin Cuba::Render
Cuba.settings[:render][:template_engine] = "haml"

Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"
Cuba.use Rack::Protection

Cuba.define do
  on get do
    on "hello" do
      res.write view("hi", world: "earth")
    end

    on "plugins" do
      plugins = Dir.glob("plugins/*").map do |file|
        constant = begin
                     Module.const_get(File.basename(file, ".rb").capitalize)
                   rescue NameError
                     nil
                   end
        if constant
          Object.send(:remove_const, constant.to_s.to_sym)
        end
        load file
        file
      end

      res.write view("plugin_list", plugins: plugins)
    end

    on root do
      res.redirect "/hello"
    end
  end
end
