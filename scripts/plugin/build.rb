require 'yaml'
require 'json'
require 'scripts/common/log'
require 'scripts/common/install_mbox'

DEACTIVATED_TOOL = "Gem"

def build(root, package_file_path)
  LOG.info "MBox CLI installed.".green if install_mbox

  (code, out, err) = "mbox init plugin -v".exec(root)
  raise err if code != 0

  package_info = YAML.load_file(package_file_path)
  plugins = package_info['plugins']
  feature_hash = {"branch_prefix" => "feature", "current_containers"=> [], "name" => "", "repos" => []}
  plugins.each do |plugin|
    if plugin['git'].nil? || plugin['git'].empty?
      raise "Git URL of plugin [#{plugin['name']}] is invalid.".yellow
    end
    repo_hash = { "components" => [{"active" => [], "tool" => DEACTIVATED_TOOL}], "last_type" => "branch", "last_branch" => "main", "url" => plugin['git'] }
    feature_hash['repos'] << repo_hash
  end
  code, _, _ = "mbox config container.allow_multiple_containers Gem Bundler CocoaPods".exec(root)
  raise "Failed on Setting Configuration.".red unless code == 0

  code, _, _ = "mbox feature import '#{JSON.dump(feature_hash)}' -v".exec(root)
  raise "Failed on Importing Feature.".red unless code == 0

  code, _, _ = "mbox pod install -v".exec(root)
  raise "Failed on Pod Installation.".red unless code == 0

  code, _, _ = "mbox plugin build --force --no-test -v".exec(root)
  raise "Failed on Building.".red unless code == 0
end