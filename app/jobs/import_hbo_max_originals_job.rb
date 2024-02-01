class ImportHboMaxOriginalsJob < ApplicationJob
  URL = 'https://www.hbomax.com/sitemap'
  queue_as :default

  def perform(*args)
    response = HTTParty.get(URL)
    doc = Nokogiri::HTML(response)
    originals_header = doc.at('h3:contains("HBO Max Originals")')
    originals_section = originals_header.parent
    originals = originals_section.css('a')
    originals.each do |node|
      title = node.attributes['title']&.text
      url = node.attributes['href'].text
      id = extract_id(url)

      next if title.blank? || id.blank?
      import_show({
        id: id,
        title: title
      })
    end
  end

  def import_show(program)
    show = Show.find_or_initialize_by({
      original_streaming_network: :hbo_max,
      original_streaming_network_id: program[:id]
    })

    show.title = program[:title]
    show.save if show.tmsId.blank? # if it's already been matched, don't update
  end

  def extract_id(url)
    url.match(/https:\/\/www.hbomax.com\/.*\/urn:hbo:.*:(.*)/)&.captures&.last
  end
end
