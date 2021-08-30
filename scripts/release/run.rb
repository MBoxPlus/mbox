require 'scripts/common/extension'
require 'scripts/common/log'
require 'scripts/network/github_api'
require 'json'
require 'yaml'
require 'git'

def release(github_token, package_path)
  raise "Current git is not clean.".red if !git_is_clean
  raise "GitHub PAT(Personal Access Token) was not found.".red if github_token.nil?

  release_yml_path = File.join(package_path,'release.yml')
  raise "File: '#{release_yml_path}' is required.".red unless File.exists?(release_yml_path)

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
    FileUtils.cp(File.join(package_path, "release.tar.gz"), release_file_path)
    api.upload_release_asset(upload_url, release_file_path)
  end
end

def release_homebrew(github_token, tag, root, package_file_path)
  LOG.info "Begin Release Homebrew".green do
    LOG.info "Make sure dir #{root} is existing"
    FileUtils.rm_rf(root)
    FileUtils .mkdir(root) unless File.exists?(root)

    package_info = YAML.load_file(package_file_path)
    formula_name = "mbox"
    tap = package_info['brew_tap']
    if tag =~ /[0-9\.]-alpha/
      LOG.info "Release to the tap for alpha test"
      tap = package_info['brew_tap_alpha']
      formula_name = "mboxt"
    end
    owner = package_info['owner']
    repo = package_info['repo']

    "git clone #{tap}".exec(root)
    raise "Homebrew tap url is invalid.".red unless tap =~ /https:\/\/github.com\/(.*)\/(.*).git/
    brew_owner = $1
    brew_repo = $2
    brew_git = Git.open(File.join(root, brew_repo), :log => LOG)
    if brew_git.current_branch != "master"
      brew_git.checkout('master')
    end
    formula_path = File.join(root, brew_repo, 'Formula', "#{formula_name}.rb")
    formula = File.read(formula_path)

    api = GitHubAPI.new(github_token, owner, repo)
    (code, out) = api.get_release(tag)
    result = JSON.parse(out)
    version = result["name"].sub(/^v/, '')
    raise "Number of assets is 0 or more than 1.".red if result["assets"].length > 1 || result["assets"].empty?
    asset = result["assets"][0]
    name = asset["name"]
    api.download_asset(asset["id"], root)
    (code, out) = "sha256sum #{name}".exec(root)
    raise "Failed on generating sha256 hash." unless out=~/^(\w+)\s+#{name}$/
    sha256 = $1
    formula = formula.sub(/VERSION\s*=\s*.*\.freeze/, "VERSION = \"#{version}\".freeze")
    formula = formula.sub(/sha256\s*".*"/, "sha256 \"#{sha256}\"")
    File.write(formula_path, formula)
    raise "There is no need to update brew.".yellow if brew_git.status.changed.count == 0
    brew_git.add(:all => true)
    brew_git.commit("#{repo} #{version}")
    brew_git.push("origin")
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