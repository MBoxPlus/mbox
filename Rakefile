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
GITHUB_TOKEN_FILE = File.join(__dir__, 'github.token')
GITHUB_TOKEN = File.read(GITHUB_TOKEN_FILE).strip

task default: %w[package]

task :bump, [:version] do |task, args|
  package_info = YAML.load_file(PACKAGE_FILE)

  if args[:version]
    LOG.info "Bump version #{package_info["version"].yellow} -> #{args[:version].to_s.green}."
    package_info["version"] = args[:version]
  else
    version = Gem::Version.new(package_info["version"])
    version = version.bump.to_s + ".0"
    LOG.info "Bump version #{package_info["version"].yellow} -> #{version.to_s.green}."
    package_info["version"] = version
  end
  File.write(PACKAGE_FILE, YAML.dump(package_info))

  "git add mbox-package.yml".exec(__dir__)
  "git commit -m 'bump v#{package_info["version"]}'".exec(__dir__)
end

task :bump_plugin, [:github_token] do |task, args|
  github_token = get_github_token(args)
  update_plugins_version(github_token, PACKAGE_FILE)
end

task :build_plugin do |task, args|
  FileUtils.rm_rf(BUILD_DIR)
  FileUtils.mkdir(BUILD_DIR) unless File.exists?(BUILD_DIR)

  build(BUILD_DIR, PACKAGE_FILE)
end

task :release_plugin, [:github_token] do |task, args|
  github_token = get_github_token(args)
  release_all_plugin(github_token, PACKAGE_FILE, BUILD_DIR)
end

task :package, [:github_token] do |task, args|
  github_token = get_github_token(args)
  package(github_token, PACKAGE_DIR, PACKAGE_FILE)
end

task :release, [:github_token] do |task, args|
  github_token = get_github_token(args)
  release(github_token, PACKAGE_DIR)
end

def get_github_token(args)
  token = args[:github_token] || GITHUB_TOKEN
  if !token.nil? && !token.empty?
    token
  else
    raise "Github Token is Needed.".red
  end
end