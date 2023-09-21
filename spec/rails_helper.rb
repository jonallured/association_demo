require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before :each do
    Mongoid.purge!
  end

  config.after :each do
    mongo_models = Mongoid::Config.models - [Mongoid::GlobalDiscriminatorKeyAssignment::InvalidFieldHost]
    mongo_models.each do |klass|
      Mongoid.deregister_model(klass)
      Object.send(:remove_const, klass.to_s.to_sym) if Object.const_defined?(klass.to_s)
    end

    ApplicationRecord.descendants.each do |klass|
      Object.send(:remove_const, klass.to_s.to_sym) if Object.const_defined?(klass.to_s)
    end

    ApplicationRecord.reset_column_information
  end

  config.after :suite do
    Mongoid::Clients.default.database.drop
  end
end
