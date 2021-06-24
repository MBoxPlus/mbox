require 'yaml'
require 'json'
require 'scripts/common/log'
require 'scripts/common/install_mbox'

def package(working_dir, package_file_path)
  LOG.info "MBox CLI installed.".green if install_mbox

  package_info = YAML.load_file(package_file_path)

  plugins_source_dir = File.join(working_dir, 'temp')
  FileUtils.rm_rf(plugins_source_dir)
  FileUtils.mkdir(plugins_source_dir) unless File.exists?(plugins_source_dir)
  build(plugins_source_dir, package_info['plugins'])
end

def build(root, plugins)
  (code, out, err) = "mbox init plugin -v".exec(root)
  raise err if code != 0

  feature_hash = {"branch_prefix" => "feature", "current_containers"=> [], "name" => "", "repos" => []}
  plugins.each do |plugin|
    if plugin['tag'].nil? || plugin['tag'].empty?
      raise "Tag of plugin [#{plugin['name']}] is invalid.".yellow
    end
    if plugin['git'].nil? || plugin['git'].empty?
      raise "Git URL of plugin [#{plugin['name']}] is invalid.".yellow
    end
    repo_hash = { "components" => [], "last_type" => "tag", "last_branch" => plugin['tag'], "url" => plugin['git'] }
    feature_hash['repos'] << repo_hash
  end
  "mbox feature import '#{JSON.dump(feature_hash)}' -v".exec(root)

  "mbox pod install -v".exec(root)

  "mbox plugin build --force --no-test -v".exec(root)
end
