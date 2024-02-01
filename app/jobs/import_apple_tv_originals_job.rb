class ImportAppleTvOriginalsJob < ApplicationJob
  URL = 'https://www.apple.com/tv-pr/originals.originals.json'
  queue_as :default

  def perform(*args)
    response = HTTParty.get(URL)
    response.dig('results', 'originals', 'shows').each do |original|
      id = original['url'] # not actually an ID, but should work as a unique identifier.
      title = original['headline']
      entity_type = extract_entity_type(original['category'])

      import_show({
        id: id,
        title: title,
        entity_type: entity_type
      })
    end
  end

  def import_show(program)
    show = Show.find_or_initialize_by({
      original_streaming_network: :apple_tv,
      original_streaming_network_id: program[:id]
    })

    show.title = program[:title]
    show.entityType = program[:entity_type]
    show.save if show.tmsId.blank? # if it's already been matched, don't update
  end

  def extract_entity_type(categories)
    if categories.include?('films')
      'movie'
    elsif categories.include?('series')
      'show'
    end
  end
end
