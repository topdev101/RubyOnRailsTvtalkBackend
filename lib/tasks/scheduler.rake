desc 'Generate comments'
task generate_comments: :environment do
  puts 'Generating comments...'

  Category.active.each do |category|
    category.shows.each do |show|
      if show.is_movie?
        ChatGpt::CommentOnShowJob.perform_now(show, comment_count: 4, sub_comment_count: 1)
        next
      end

      show.episodes.order(releaseDate: :desc).first(100).each do |ep|
        ChatGpt::CommentOnShowJob.perform_now(ep, comment_count: 4, sub_comment_count: 1) if ep.comments.count < 4
      end
    end
  end
end

desc 'Refresh genre cache'
task refresh_genre_cache: :environment do
  puts 'Refreshing genre cache...'
  GenreCache.cache_all(clear_cache: true)
  puts 'Finished refreshing genre cache.'
end

desc 'Refresh guide cache'
task guide_cache: :environment do
  puts 'Refreshing genre cache...'

  # Update the default guide
  LineupCache.new.cache(clear_cache: true)

  LineupCache::SUPPORTED_TIME_ZONES.each do |tz|
    # Update timezone-specific guides
    LineupCache.new(timezone: tz).cache(clear_cache: true)
  end
  puts 'Finished refreshing guide cache.'
end

desc 'Import new shows via Gracenote live guide'
task import_shows_via_live_guide: :environment do
  puts 'Importing shows via live guide...'
  ImportLiveGuideJob.perform_later if Time.now.hour.even?
  puts 'Finished importing shows.'
end

desc 'Import original shows'
task import_original_shows: :environment do
  puts 'Importing Netflix Originals...'
  ImportNetflixOriginalsJob.perform_later

  puts 'Importing Hulu Originals...'
  ImportHuluOriginalsJob.perform_later

  puts 'Importing HBO Max Originals...'
  ImportHboMaxOriginalsJob.perform_later

  puts 'Importing Apple TV Originals...'
  ImportAppleTvOriginalsJob.perform_later

  puts 'Importing Paramount Originals...'
  ImportParamountOriginalsJob.perform_later

  puts 'Importing Peacock Originals...'
  ImportPeacockOriginalsJob.perform_later

  puts 'Importing Prime Originals...'
  ImportPrimeOriginalsJob.perform_later

  puts 'Finished importing originals.'
end

desc 'Updating original shows'
task update_original_shows: :environment do
  # Original/Streaming shows do not appear on lineups
  # so we must manually refresh them and look for new episodes/data
  puts 'Updating original shows...'

  Show.originals.parent_shows.where(updated_at: ..7.days.ago).find_each do |show|
    ImportShowJob.perform_later(tmsId: show.tmsId)
  end

  puts 'Finished updating original shows.'
end

desc 'Update existing shows'
task update_shows: :environment do
  puts 'Updating existing shows...'

  Show.with_tms_id.non_episode.order(updated_at: :asc).limit(2_500).each do |show|
    ImportShowJob.perform_later(tmsId: show.tmsId)
  end

  puts 'Finished updating existing shows.'
end

desc 'Import missing episodes'
task import_missing_shows: :environment do
  puts 'Importing missing episodes...'

  Show.with_missing_episodes.find_each do |show|
    ImportShowJob.perform_later(tmsId: show.tmsId)
  end

  puts 'Finished importing missing episodes.'
end

desc 'Import news for recently aired shows'
task update_recent_show_news: :environment do
  puts 'Importing news recently aired shows...'
  (
    Show.airing_soon.news_imported_older_than(2.days).with_episode_title |
    Show.recently_aired.news_imported_older_than(2.days).with_episode_title
  ).each do |show|
    ImportShowNewsViaGoogleJob.perform_later(show)
  end
  puts 'Finished importing news recently aired shows.'
end

desc 'Import news'
task import_news: :environment do
  puts 'Importing news...'
  ImportNewsJob.perform_later
  puts 'Finished importing news.'
end

desc 'Update story source iframe permissions'
task update_story_sources: :environment do
  puts 'Updating story sources...'
  StorySource.find_each(&:verify_iframe_permission)
  puts 'Finished updating story sources.'
end

desc 'Import Network Shows'
task import_network_shows: :environment do
  puts 'Importing network shows...'
  Network.active.find_each { |network| ImportNetworkShowsJob.perform_later(network) } if Time.now.day.even?
  puts 'Finished importing network shows.'
end

desc 'Update Popularity Scores'
task update_popularity_scores: :environment do
  puts 'Updating popularity scores...'
  Show.with_tms_id.find_in_batches do |group|
    BulkUpdateShowPopularityJob.perform_later(group.first.id, group.last.id) if Time.now.day.even?
  end
  puts 'Finished updating popularity scores.'
end

desc 'Update Search index'
task update_search: :environment do
  puts 'Updating search index...'
  ShowSearch.refresh
  puts 'Finished updating search index.'
end

desc 'Update Top Commenters index'
task update_top_commenters: :environment do
  puts 'Updating top commenters index...'
  TopCommenter.refresh
  puts 'Finished updating top commenters index.'
end

desc 'Update Top Comments index'
task update_top_commenter: :environment do
  puts 'Updating top comments index...'
  TopComment.refresh
  puts 'Finished updating top comments index.'
end

desc 'Update image uri format'
task update_image_format: :environment do
  Show.where("preferred_image_uri NOT LIKE 'wewe.tmsimg%'").find_each do |show|
    current_url = show.preferred_image_uri
    next if current_url.blank?

    if current_url.start_with?('wewe')
      # do nothing, it is current
    elsif current_url.start_with?('assets')
      new_url = "https://wewe.tmsimg.com/#{current_url}"
    elsif current_url.start_with?('https://wewe')
      new_url = current_url.gsub('https://', '')
    elsif current_url.start_with?('https://demo')
      new_url = current_url.gsub('demo', 'wewe')
    elsif current_url.start_with?('http://wewe')
      new_url = current_url.gsub('http://', 'https://')

    elsif current_url.start_with?('http://demo')
      new_url = current_url.gsub('http://demo', 'https://wewe')
    end

    if new_url.blank?
      puts "NOT RECOGNIZED: #{current_url} (#{show.id})"
    else
      show.preferred_image_uri = new_url
      show.save
    end
  end
end
