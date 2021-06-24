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

  def create_release(tag_name, target_commitish='main')
    api = "#{api_url}/releases"
    curl = "curl -s"\
       " -u username:#{@token}"\
       " -X POST"\
       " -H \"Accept: application/vnd.github.v3+json\""\
       " -s"\
       " #{api}"\
       " -d '{\"tag_name\":\"#{tag_name}\",\"target_commitish\":\"#{target_commitish}\"}'"
    curl.exec
  end

  def upload_release_asset(url, file)
    curl = "curl -s"\
       " -u username:#{@token}"\
       " -X POST"\
       " -H \"Accept: application/vnd.github.v3+json\""\
       " -H \"Content-Type: application/zip\""\
       " --data-binary @#{file}"\
       " #{url}?name=#{File.basename(file)}"
    curl.exec
  end

  def get_release(tag)
    api = "#{api_url}/releases/tags/#{tag}"
    curl = "curl -s"\
         " -u username:#{@token}"\
         " -H \"Accept: application/vnd.github.v3+json\""\
         " #{api}"
    curl.exec
  end

  def download_asset(asset_id, dest)
    api = "#{api_url}/releases/assets/#{asset_id}"
    curl = "curl -LOJ"\
         " -u username:#{@token}"\
         " -H \"Accept: application/octet-stream\""\
         " #{api}"
    curl.exec(dest)
  end
end