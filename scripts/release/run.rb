require 'scripts/common/extension'
require 'scripts/common/log'
require 'scripts/network/github_api'
require 'json'

def release(github_token, package_path)
  raise "Current git is not clean.".red if !git_is_clean
  raise "GitHub PAT(Personal Access Token) was not found.".red if github_token.nil?

  release_yml_path = File.join(File.dirname(package_path), 'release.yml')
  raise "File: '#{release_yml_path}' is required." unless File.exists?(release_yml_path)

  package_info = YAML.load_file(release_yml_path)
  owner = package_info["owner"]
  repo = package_info["repo"]
  version = package_info["version"]
  api = GitHubAPI.new(github_token, owner, repo)

  (code, out) = api.get_release("v"+version)
  result = JSON.parse(out)
  raise "v#{version} has already exists." unless result['id'].nil?

  (code, out) = api.create_release("v"+version)
  release_json = JSON.parse(out)
  if release_json['upload_url'] =~ /^(.*)\{\?name,label\}/
    upload_url = $1
    LOG.info("Upload URL: #{upload_url}")
    release_file_path = File.join(File.dirname(package_path), "mbox-#{version}.tar.gz")
    FileUtils.cp(package_path, release_file_path)
    api.upload_release_asset(upload_url, release_file_path)
  end
end

def get_hash_by_tag(remote_url, tag_name)
  (code, out, err) = "git ls-remote --tags -q #{remote_url} | grep -P '^(.*)\srefs/tags/#{tag_name}$' -o | awk '{print $1}'".exec('/', {quiet: true})
  if out.strip.empty?
    nil
  else
    out.strip
  end
end

def git_is_clean
  (code, out) = "git status".exec(__dir__, {:display_stdout => false})
  out.include?("nothing to commit, working tree clean")
end