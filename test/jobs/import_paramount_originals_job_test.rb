require 'test_helper'

class ImportParamountOriginalsJobTest < ActiveJob::TestCase
  test 'imports show data' do
    VCR.use_cassette("paramount") do
      assert_difference('Show.count', 32) do
        ImportParamountOriginalsJob.perform_now
      end
    end

    show = Show.paramount.find_by(original_streaming_network_id: '/shows/why-women-kill/')
    assert_equal 'Why Women Kill', show.title
    assert_nil show.tmsId
  end
end