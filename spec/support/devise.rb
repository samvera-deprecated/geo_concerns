require 'devise'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.include Warden::Test::Helpers, type: :feature
  config.include Controllers::EngineHelpers, type: :controller
  config.include Rails.application.routes.url_helpers, type: :routing
end
