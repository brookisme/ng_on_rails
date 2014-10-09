namespace :karma  do
  task :start => :environment do
    with_tmp_config :start
  end

  task :run => :environment do
    exit with_tmp_config :start, "--single-run"
  end

private

  def with_tmp_config(command, args = nil)
    # Change to [.., '.coffee'] for any CS config files
    Tempfile.open(['karma_unit', '.js'], Rails.root.join('tmp')) do |f|
      f.write unit_js(application_spec_files)
      f.flush

      system "./node_modules/karma/bin/karma #{command} #{f.path} #{args}"
    end
  end

  def application_spec_files
    [
      'angular',
      'angular-resource',
      'angular-animate',
      'angular-sanitize',
      'angular-mocks',
      'app'
    ].map do |required_asset|
      Rails.application.assets.find_asset(required_asset).pathname
    end
  end

  def unit_js(files)
    puts "application_spec_files #{application_spec_files}"
    unit_js = File.open('spec/karma/config/unit.js', 'r').read
    unit_js.gsub "APPLICATION_SPEC", "\"#{files.join("\",\n\"")}\""
  end
end