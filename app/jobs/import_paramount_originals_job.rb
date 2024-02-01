class ImportParamountOriginalsJob < ApplicationJob
  URL = 'https://www.paramountplus.com/shows/originals/'
  queue_as :default

  def perform(*args)
    response = HTTParty.get(URL)
    doc = Nokogiri::HTML(response)
    originals = doc.css('#main-container .show-browse-item .title a')
    originals.each do |node|
      title = node.text.strip
      id = node.attributes['href'].text

      import_show({
        id: id,
        title: title
      })
    end
  end

  def import_show(program)
    show = Show.paramount.find_or_initialize_by({
      original_streaming_network_id: program[:id]
    })

    show.title = program[:title]
    show.save if show.tmsId.blank? # if it's already been matched, don't update
  end
end