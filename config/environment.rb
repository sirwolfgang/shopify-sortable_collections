# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Workspace::Application.initialize!

ActiveResource::Base.logger = ActiveRecord::Base.logger
