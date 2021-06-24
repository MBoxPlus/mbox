require 'scripts/common/extension'
require 'scripts/common/log'

# API: https://docs.github.com/en/rest/reference/repos#releases

class GitHubAPI
  def initialize(token, owner, repo)
    @host = "https://api.github.com/repos"
    @token = token
    @owner = owner
    @repo = repo
  end

  def api_url
    "#{@host}/#{@owner}/#{@repo}"
  end

  def create_release(tag_name)
    api = "#{api_url}/releases"
    curl = "curl"\
       " -u username:#{@token}"\
       " -X POST"\
       " -H \"Accept: application/vnd.github.v3+json\""\
       " -s"\
       " #{api}"\
       " -d '{\"tag_name\":\"#{tag_name}\"}'"
    curl.exec
  end

  def upload_release_asset(url, file)
    curl = "curl"\
       " -u username:#{@token}"\
       " -X POST"\
       " -H \"Accept: application/vnd.github.v3+json\""\
       " -H \"Content-Type: application/zip\""\
       " --data-binary @#{file}"\
       " #{url}?name=#{File.basename(file)}"
    curl.exec
  end

  def get_release(tag)
    curl = "curl" \
         "-H \"Accept: application/vnd.github.v3+json" \
         "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{tag}"
    curl.exec(Dir.pwd)
  end
end