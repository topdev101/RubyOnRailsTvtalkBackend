require 'test_helper'

class ImportAppleTvOriginalsJobTest < ActiveJob::TestCase
  test 'imports show data' do
    VCR.use_cassette("apple_tv") do
      assert_difference('Show.count', 73) do
        ImportAppleTvOriginalsJob.perform_now
      end
    end

    show = Show.apple_tv.find_by(original_streaming_network_id: '/tv-pr/originals/wolfwalkers/')
    assert_equal 'Wolfwalkers', show.title
    assert_nil show.tmsId

    movie = Show.apple_tv.find_by(original_streaming_network_id: '/tv-pr/originals/watch-the-sound-with-mark-ronson/')
    assert_equal 'Watch the Sound with Mark Ronson', movie.title
    assert_nil movie.tmsId
  end
end