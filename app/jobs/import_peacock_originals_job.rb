class ImportPeacockOriginalsJob < ApplicationJob
  URL = 'https://www.peacocktv.com/collections/originals'
  queue_as :default

  def perform(*args)
    response = HTTParty.get(URL)
    doc = Nokogiri::HTML(response)
    originals = doc.css('section picture')
    originals.each do |node|
      link_tag = node.parent.parent # contains href for id
      container = link_tag.parent.parent.parent.parent.parent.parent.parent.parent # parent container for show
      title = container.at_css('a.sk-text--title-large')&.text
      next if title.blank?
      url = link_tag.attributes['href'].text

      import_show({
        id: url,
        title: title
      })
    end
  end

  def import_show(program)
    show = Show.peacock.find_or_initialize_by({
      original_streaming_network_id: program[:id]
    })

    show.title = program[:title]
    show.save if show.tmsId.blank? # if it's already been matched, don't update
  end
end