# frozen_string_literal: true

require "anyway_config"
require "vcr"
require "webmock"
require "roseflow/stabilityai"
require "ulid"

Anyway::Settings.use_local_files = true

VCR.configure do |config|
  config.filter_sensitive_data("<STABILITYAI_API_KEY>") { Roseflow::StabilityAI::Config.new.api_key }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
