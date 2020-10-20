# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause this
# file to always be loaded, without a need to explicitly require it in any files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, make a
# separate helper file that requires this one and then use it only in the specs
# that actually need it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|

  Capybara.server = :webrick

  # The settings below are suggested to provide a good initial experience
  # with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
    expectations.syntax = :expect
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true
  end
=end

  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # TaxonWorks tests suites
  #
  # Tests that check/test the testing framework itself
  # are to be disabled by default.

  test_excludes = {}

  # Tests that check validitify of factories
  unless ENV['TAXONWORKS_TEST_LINTING']
    test_excludes.merge!(lint: true)
  end

  # Tests that require a specific screen resolution to work no .travis
  # unless ENV['TAXONWORKS_TEST_RESOLUTION']
  #   test_excludes.merge!(resolution: true)
  # end

  config.filter_run_excluding test_excludes

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  #  config.profile_examples = 10

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: %w(spatial_ref_sys))

    FileUtils.mkdir_p(Rails.configuration.x.test_tmp_file_dir) unless File.directory?(Rails.configuration.x.test_tmp_file_dir)

    ApplicationRecord.connection.select_all('SELECT PostGIS_version() v').first['v'] =~ /(\d+.\d+)/
    PSQL_VERSION = $1.to_f

    Faker::Config.random = Random.new(ENV['FAKER_SEED'].to_i) if ENV['FAKER_SEED']
    # Monitor Faker seed
    puts "Faker random seed: #{Faker::Config.random.seed}"
  end

  config.after(:suite) do
    FileUtils.rm_rf( Rails.configuration.x.test_tmp_file_dir )
    Features::Downloads.clear_downloads # TODO if global than doesn't belong in Features 
    FileUtils.rm_rf(Download.storage_path)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:all) do
    Faker::UniqueGenerator.clear # Clears used values for all generators
  end

  # Capybara requires truncation strategy!!
  config.before(:each, js: true) do
    Capybara.current_driver  = Capybara.javascript_driver
    DatabaseCleaner.strategy = :truncation, {except: %w(spatial_ref_sys)}
    Features::Downloads.clear_downloads # TODO, this should be downloads: true strategy to eliminate need to call everytime
    FileUtils.rm_rf(Download.storage_path)
  end

  config.after(:each, js: true) do
    Capybara.use_default_driver
    set_selenium_window_size(1600, 1200) if Capybara.current_driver == :selenium
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Enable CSRF protection for feature tests by default
  config.before(:each, type: :feature) do
    ActionController::Base.allow_forgery_protection = true
  end
  config.after(:each, type: :feature) do
    ActionController::Base.allow_forgery_protection = false
  end

  # Verify DB is actually cleared. Retry if it isn't.
  config.after(:each, type: :feature) do
    DatabaseCleaner.clean
    i = 0
    while User.count > 0 && i <= 3
      puts "DATABASE NOT YET CLEARED, RETRYING..."
      sleep 2**i
      DatabaseCleaner.clean
      i += 1
    end
  end

end
