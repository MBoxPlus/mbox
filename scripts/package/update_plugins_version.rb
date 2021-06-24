require 'scripts/common/log'

def update_plugins_version(package_file_path)
  package_info = YAML.load_file(package_file_path)
  plugins = package_info['plugins']

  plugins.each do |plugin|
    (code, out, err) = "git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags #{plugin['git']} '*.*.*'"\
                        "| tail -n 1"\
                        "| cut -d '/' -f3".exec('/', {quiet: true})
    next unless code == 0
    tag = out.strip
    if tag.empty? || tag == plugin["tag"]
      LOG.info "Plugin[#{plugin["name"]}] has no new tag".yellow
      next
    end
    LOG.info "Plugin[#{plugin['name']}]: " + plugin['tag'] + " -> " + tag.green
    plugin['tag'] = tag
  end

  File.write(package_file_path, YAML.dump(package_info))
end