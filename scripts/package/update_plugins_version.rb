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
    LOG.info "Bump plugin[#{plugin['name']}] tag: #{tag}. Old is #{plugin['tag'].to_s}"
    plugin['tag'] = tag if code == 0
  end

  File.write(package_file_path, YAML.dump(package_info))
end