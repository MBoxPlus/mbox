require 'scripts/common/extension'
require 'scripts/common/log'
require 'scripts/network/github_api'
require 'json'

def release(github_token, package_file_path, package_path)
  raise "GitHub PAT(Personal Access Token) was not found.".red if github_token.nil?

  package_info = YAML.load_file(package_file_path)
  owner = package_info["owner"]
  repo = package_info["repo"]
  api = GitHubAPI.new(github_token, owner, repo)

  # api.get_release('mbox')
  # return
  (code, out) = api.create_release("v"+package_info['version'])
  release_json = JSON.parse(out)
  if release_json['upload_url'] =~ /^(.*)\{\?name,label\}/
    upload_url = $1
    LOG.info("Upload URL: #{upload_url}")
    api.upload_release_asset(upload_url, package_path)
  end
end