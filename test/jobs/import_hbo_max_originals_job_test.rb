require 'test_helper'

class ImportHBOMaxOriginalsJobTest < ActiveJob::TestCase
  test 'imports show data' do
    VCR.use_cassette("hbo_max") do
      assert_difference('Show.count', 38) do
        ImportHboMaxOriginalsJob.perform_now
      end
    end

    show = Show.find_by(original_streaming_network: :hbo_max, original_streaming_network_id: 'GX6W67gfRQIGWrQEAAABJ')
    assert_equal 'Colin Quinn & Friends: A Parking Lot Comedy Show', show.title
    assert_nil show.tmsId
  end
end
