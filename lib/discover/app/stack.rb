require 'rack-flash'

def new_app
  Rack::Builder.new {
    use Rack::Session::Cookie, :secret => (ENV['SESSION_SECRET'] || 'dev')
    use Rack::Flash

    map "/admin" do
      use Rack::Auth::Basic, "Protected Area" do |username, password|
        username == 'discover' && password == ENV["ADMIN_PASSWORD"] || ''
      end

      map "/audiences" do
        use Discover::App::Admin::Audiences
      end

      map "/topics" do
        use Discover::App::Admin::Topics
      end

      map "/places" do
        use Discover::App::Admin::Places
      end

      map "/help" do
        use Rack::Usermanual, :sections => { "Administrator manual" => "features/administrator-manual", "User manual" => "features/user-manual" }, :index => "features/administrator-manual/README.md", :layout => 'views/layout_help.haml'
      end

      use Discover::App::Admin::Base
    end

    map "/help" do
      use Rack::Usermanual, :sections => { "User manual" => "features/user-manual" }, :index => "features/README.md", :layout => 'views/layout_help.haml'
    end

    run Discover::App::Frontend
  }
end
