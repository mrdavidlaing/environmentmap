require 'appengine-rack'
AppEngine::Rack.configure_app(
    :application => 'environmentmap',
    :precompilation_enabled => true,
    :sessions_enabled => true,
    :version => "5")

AppEngine::Rack.app.resource_files.exclude :rails_excludes
ENV['RAILS_ENV'] = AppEngine::Rack.environment

deferred_dispatcher = AppEngine::Rack::DeferredDispatcher.new(
    :require => File.expand_path('../config/environment', __FILE__),
    :dispatch => 'ActionController::Dispatcher')

map '/maps' do
  use AppEngine::Rack::LoginRequired
  run deferred_dispatcher
end

map '/' do
  run deferred_dispatcher
end
