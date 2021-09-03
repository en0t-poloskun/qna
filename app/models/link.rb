# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  GIST_REGEXP = %r{^https://gist.github.com/(\w|-)+/\w+}.freeze

  def gist?
    url.match?(GIST_REGEXP)
  end

  def gist_content
    GistService.new(url).call
  end
end
