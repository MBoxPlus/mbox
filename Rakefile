$LOAD_PATH << '.'

require 'scripts/package/run'
require 'scripts/release/run'
require 'scripts/package/update_plugins_version'
require 'rubygems/version.rb'
require 'yaml'

PACKAGE_FILE = File.join(__dir__, 'mbox-package.yml')

task default: %w[package]

task :bump, [:version] do |task, args|
  package_info = YAML.load_file(PACKAGE_FILE)

  if args[:version]
    package_info["version"] = args[:version]
  else
    version = Gem::Version.new(package_info["version"])
    version = version.bump.to_s + ".0"
    package_info["version"] = version
  end
  File.write(PACKAGE_FILE, YAML.dump(package_info))
end

task :bump_plugin do
  update_plugins_version(PACKAGE_FILE)
end

task :package do
  package_dir = File.expand_path(File.join(__dir__, '..'))
  package(package_dir, File.join(__dir__, 'mbox-package.yml'))
end

task :release, [:github_token, :package_file] do |task, args|
  release(args[:github_token], PACKAGE_FILE, args[:package_file])
end