$LOAD_PATH << '.'

require 'scripts/package/run'
require 'scripts/plugin/build'
require 'scripts/plugin/release_plugin'
require 'scripts/release/run'
require 'scripts/package/update_plugins_version'
require 'rubygems/version.rb'
require 'yaml'

PACKAGE_FILE = File.join(__dir__, 'mbox-package.yml')
BUILD_DIR = File.expand_path(File.join(__dir__, '../build'))
PACKAGE_DIR = File.expand_path(File.join(__dir__, '../package'))

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

  "git add mbox-package.yml".exec(__dir__)
  "git commit -m 'bump v#{package_info["version"]}".exec(__dir__)
end

task :bump_plugin do
  update_plugins_version(PACKAGE_FILE)
end

task :build_plugin do |task, args|
  FileUtils.rm_rf(BUILD_DIR)
  FileUtils.mkdir(BUILD_DIR) unless File.exists?(BUILD_DIR)

  build(BUILD_DIR, PACKAGE_FILE)
end

task :release_plugin, [:github_token] do |task, args|
  release_all_plugin(args[:github_token], PACKAGE_FILE, BUILD_DIR)
end

task :package, [:github_token] do |task, args|
  package(args[:github_token], PACKAGE_DIR, PACKAGE_FILE)
end

task :release, [:github_token] do |task, args|
  release(args[:github_token], PACKAGE_DIR)
end