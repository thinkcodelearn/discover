
def new_app
  Rack::Builder.new {
    map "/admin" do
      use Rack::Auth::Basic, "Protected Area" do |username, password|
        username == 'discover' && password == ENV["ADMIN_PASSWORD"] || ''
      end

      map "/help" do
        use Rack::Usermanual, :sections => { "Administrator manual" => "features/administrator-manual" }, :index => "features/administrator-manual/README.md"
      end

      use Discover::App::Admin
    end

    map "/help" do
      use Rack::Usermanual, :sections => { "User manual" => "features/user-manual" }, :index => "features/README.md"
    end

    run Discover::App::Frontend
  }
end
