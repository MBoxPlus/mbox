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
      package_dir = File.join(build_dir, "release", plugin["name"])
      release_plugin(github_token, owner, repo, package_dir)
    end
  end
end

def release_plugin(github_token, owner, repo, package_dir)
  plugin_info = YAML.load_file(File.join(package_dir, "manifest.yml"))
  LOG.info "Release Plugin [#{plugin_info["NAME"]}] to GitHub.".green
  version = plugin_info["VERSION"]
  api = GitHubAPI.new(github_token, owner, repo)

  LOG.info "Archiving Plugin [#{plugin_info["NAME"]}]".green
  "tar -czf #{File.basename(package_dir)}.tar.gz #{File.basename(package_dir)}".exec(File.dirname(package_dir))

  (code, out) = api.get_release("v"+version)
  result = JSON.parse(out)

  unless result['id'].nil? || result['assets'].empty? || ENV["FORCE_RELEASE"]
    LOG.info "[#{plugin_info["name"]}]: v#{version} has already exists.".yellow
    return
  end

  release_json = {}
  if result['id'].nil?
    (code, out) = api.create_release("v"+version)
    release_json = JSON.parse(out)
  end

  if ENV["FORCE_RELEASE"] && result['id']
    (code, out) = api.update_release(result['id'], "v"+version)
    release_json = JSON.parse(out)
  end

  if ENV["FORCE_RELEASE"] && !result['assets'].empty?
    result['assets'].each do |asset|
      LOG.info "Delete Release Asset [id=#{asset['id']}, name=#{asset['name']}]".yellow
      api.delete_release_asset(asset['id'])
    end
  end

  if release_json['upload_url'] =~ /^(.*)\{\?name,label\}/
    upload_url = $1
    LOG.info "Uploading Plugin [#{plugin_info["NAME"]}] to URL [#{upload_url}]".green
    release_file_path = File.join(File.dirname(package_dir), "#{File.basename(package_dir)}.tar.gz")
    (code, out) = api.upload_release_asset(upload_url, release_file_path)
    raise "Upload Plugin [#{upload_url}] Failed. code".red unless code == 0
    upload_result = JSON.parse(out)
    raise "Upload Plugin [#{upload_url}] Failed. #{upload_result}".red if upload_result['id'].nil?
  end
end