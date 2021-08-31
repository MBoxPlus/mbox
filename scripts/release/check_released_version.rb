require 'yaml'
require 'json'
require 'scripts/common/log'
require 'scripts/common/github_action'
require 'scripts/network/github_api'

def check_released_version(github_token, package_path)
  package_info = YAML.load_file(package_path)

  owner = package_info["owner"]
  repo = package_info["repo"]
  version = package_info["version"]
  api = GitHubAPI.new(github_token, owner, repo)

  (code, out) = api.get_release("v"+version)
  result = JSON.parse(out)
  if result['id'].nil?
    LOG.info "Released version is #{version}"
    Actions.set_output("RELEASED_VERSION", version)
  else
    LOG.info "Skip release."
  end
end