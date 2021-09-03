# frozen_string_literal: true

class GistService
  ACCESS_TOKEN = Rails.application.credentials.config[:github_token]

  def initialize(url)
    @url = url
    @client = Octokit::Client.new(access_token: ACCESS_TOKEN)
  end

  def call
    gist_id = @url.split('/').last
    gist = @client.gist(gist_id)
    gist.files.first[1].content
  rescue Octokit::NotFound
    'Gist not found'
  end
end
