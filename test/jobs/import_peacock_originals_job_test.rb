require 'test_helper'

class ImportPeacockOriginalsJobTest < ActiveJob::TestCase
  test 'imports show data' do
    VCR.use_cassette("peacock") do
      assert_difference('Show.count', 46) do
        ImportPeacockOriginalsJob.perform_now
      end
    end

    show = Show.peacock.find_by(original_streaming_network_id: 'https://www.peacocktv.com/channels/the-choice')
    assert_equal 'Zerlina', show.title
    assert_nil show.tmsId
  end
end