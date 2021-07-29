require 'yaml'
require 'json'
require 'scripts/common/log'
require 'scripts/common/install_mbox'
require 'scripts/common/log'

def package(github_token, root, package_file_path)
  FileUtils.rm_rf(root)
  FileUtils.mkdir(root) unless File.exists?(root)

  download(github_token, root, package_file_path)

  archive(root, package_file_path)
end

def download(github_token, root, package_file_path)
  LOG.info "Begin to Download Plugins".green
  package_info = YAML.load_file(package_file_path)
  plugins = package_info['plugins']
  plugins.each do |plugin|
    if plugin["git"] =~ /^git@github.com:(.*)\/(.*).git/
      name = plugin['name']
      raise "Tag of plugin [#{name}] is invalid. Value: #{plugin['tag'].to_s}" if plugin['tag'].empty?
      owner = $1
      repo = $2
      api = GitHubAPI.new(github_token, owner, repo)
      (code, out) = api.get_release(plugin['tag'])
      release_json = JSON.parse(out)
      asset = release_json["assets"][0]
      asset_id = asset["id"]
      file_name = asset["name"]
      api.download_asset(asset_id, root)
      "tar -zxf #{file_name}".exec(root)
      FileUtils.rm(File.join(root, file_name))
    end
  end
end

def archive(root, package_file_path)
  LOG.info "Begin to Archive".green
  FileUtils.cp(package_file_path, File.join(root, "release.yml"))
  package_info = YAML.load_file(package_file_path)
  version = package_info['version']
  tar_output_path = File.join(root, "mbox-#{version}.tar.gz")
  FileUtils.rm_rf(tar_output_path)
  "tar -czf release.tar.gz *".exec(root)
end