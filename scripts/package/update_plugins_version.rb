require 'scripts/common/log'
require 'scripts/network/github_api'

def update_plugins_version(github_token, package_file_path)
  package_info = YAML.load_file(package_file_path)
  plugins = package_info['plugins']

  plugins.each do |plugin|
    if plugin["git"] =~ /git@github\.com:(.*)\/(.*)\.git/
      api = GitHubAPI.new(github_token, $1, $2)
      code, out = api.get_latest_release
      release_result = JSON.parse(out)
      tag = release_result["tag_name"]
      LOG.info "[#{plugin["name"]}] Latest Tag #{tag}".green
      if tag.empty? || tag == plugin["tag"]
        LOG.info "Plugin [#{plugin["name"]}] has no new tag.".yellow
        next
      end
      LOG.info "Plugin[#{plugin['name']}]: " + (plugin['tag'] || "None") + " -> " + tag.green
      plugin['tag'] = tag
    end
  end

  File.write(package_file_path, YAML.dump(package_info))
end