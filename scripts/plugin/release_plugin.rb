require 'scripts/common/log'
require 'yaml'
require 'json'

def release_all_plugin(github_token, package_file_path, build_dir)
  package_info = YAML.load_file(package_file_path)
  plugins = package_info["plugins"]
  plugins.each do |plugin|
    if plugin["git"] =~ /^git@github.com:(.*)\/(.*).git/
      owner = $1
      repo = $2
      package_dir = File.join(build_dir, plugin["name"])
      release_plugin(github_token, owner, repo, package_dir)
    end
  end
end

def release_plugin(github_token, owner, repo, package_dir)
  plugin_info = YAML.load_file(File.join(package_dir, "manifest.yml"))
  version = plugin_info["version"]
  api = GitHubAPI.new(github_token, owner, repo)

  "tar -czf #{File.basename(package_dir)}.tar.gz #{File.basename(package_dir)}".exec(File.dirname(package_dir))

  (code, out) = api.get_release("v"+version)
  result = JSON.parse(out)

  unless result['id'].nil?
    LOG.info "[#{plugin_info["name"]}]: v#{version} has already exists.".yellow
    return
  end

  (code, out) = api.create_release("v"+version)
  release_json = JSON.parse(out)
  if release_json['upload_url'] =~ /^(.*)\{\?name,label\}/
    upload_url = $1
    LOG.info("Upload URL: #{upload_url}")
    release_file_path = File.join(File.dirname(package_dir), "#{File.basename(package_dir)}-v#{version}.tar.gz")
    api.upload_release_asset(upload_url, release_file_path)
  end
end