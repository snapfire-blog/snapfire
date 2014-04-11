class Admin < Cuba; end

Admin.plugin Cuba::Render
Admin.settings[:render][:views] = File.expand_path("views/admin", Dir.pwd)
Admin.settings[:render][:template_engine] = "haml"
Admin.settings[:render][:layout] = "../layout"

Admin.define do
  on root do
    if req.session[:user]
      res.write "THE ADMIN SITE!"
    else
      res.redirect "/admin/login"
    end
  end

  on "main" do
    if req.session[:user]
      res.write "THE ADMIN SITE!"
    else
      res.redirect "/admin/login"
    end
  end


  on "login" do
    on get do
      res.write view("login")
    end
    on post do
      on param("user"), param("pass") do |user, pass|
        if user == pass
          req.session[:user] = user
          res.redirect "/admin/main"#"#{user}:#{pass}" #=> "foo:baz"
        else
          res.redirect "/admin/login"
        end
      end

      on true do
        res.write "You need to provide user and pass!"
      end
    end
  end
end
