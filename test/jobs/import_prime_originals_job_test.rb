require 'test_helper'

class ImportPrimeOriginalsJobTest < ActiveJob::TestCase
  test 'imports show data' do
    VCR.use_cassette("prime") do
      assert_difference('Show.count', 116) do
        ImportPrimeOriginalsJob.perform_now
      end
    end

    show = Show.prime.find_by(original_streaming_network_id: 'bosch')
    assert_equal 'Bosch', show.title
    assert_nil show.tmsId
  end
end
