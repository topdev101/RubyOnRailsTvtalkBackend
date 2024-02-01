# == Schema Information
#
# Table name: story_sources
#
#  id              :bigint           not null, primary key
#  domain          :string           not null
#  enabled         :boolean          default(TRUE)
#  iframe_enabled  :boolean          default(FALSE)
#  image_url       :string
#  last_scraped_at :time
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_story_sources_on_domain   (domain) UNIQUE
#  index_story_sources_on_enabled  (enabled)
#
class StorySource < ApplicationRecord
  after_create :verify_iframe_permission
  validates_presence_of :domain
  has_many :stories

  # checks if the domain allows iframe embedding
  def verify_iframe_permission
    story = stories.first
    return true if story&.url&.nil?

    resp = HTTParty.get(story.url)
    if resp.headers['x-frame-options']
      self.iframe_enabled = false
    else
      self.iframe_enabled = true
    end
    self.save!

  rescue
    # Save the source even if there was an http error.
    puts "Error verifying iframe permissons for: #{domain} (#{stories.first.url})"
    true
  end
end
