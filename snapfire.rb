require "cuba"
require "cuba/render"
require "cuba/contrib"

require "rack/protection"

require_relative "snapfire/admin"

require_relative "snapfire/models/post"
require_relative "cuba_extensions/view_helpers"


Cuba.plugin Cuba::Render
Cuba.settings[:render][:template_engine] = "haml"

Cuba.use Rack::Session::Cookie, secret: "__a_very_long_string__"
Cuba.use Rack::Protection


Cuba.define do
  def assets_dir
    "#{File.dirname(__FILE__)}/assets/"
  end
  on get, extension("css") do |file|
    res["Content-Type"] = "text/css"
    res.write File.read("#{assets_dir}/styles/#{file}.css")
  end
  on get, extension("js") do |file|
    res["Content-Type"] = "text/javascript"
    res.write File.read("#{assets_dir}/javascripts/#{file}.js")
  end

  on "admin" do
    run Admin
  end

  on get do

    on root do
      posts = [
        Post.new(title: "First post", content: "Blah blah"),
        Post.new(title: "Second post", content: "Blah blah"),
      ]

      res.write view("posts", posts: posts)
    end

    on "post/:slug" do |slug|
      post = Post.new(title: "First post", content: "Blah blah")

      res.write view("post", post: post)
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
  end
end
