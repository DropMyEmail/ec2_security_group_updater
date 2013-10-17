require 'vcr'

RSpec.configure do |config|
  config.around(:each) do |example|
    VCR.use_cassette(example.metadata[:full_description], record: :new_episodes, allow_playback_repeats: true) do
      example.run
    end
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassette_library'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.default_cassette_options = { record: :none }
end