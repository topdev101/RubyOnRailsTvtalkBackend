class ImportPrimeOriginalsJob < ApplicationJob
  URL = 'https://en.wikipedia.org/wiki/List_of_Amazon_Prime_Video_original_programming'
  ALLOWED_CATEGORIES = Set.new([
    # "Original programming",
    "Drama",
    "Comedy",
    "Animation",
    "Adult animation",
    "Anime",
    "Kids & family",
    # "Non-English language scripted",
    # "German",
    # "Hindi",
    # "Japanese",
    # "Portuguese",
    # "Spanish",
    "Other",
    # "Unscripted",
    # "Docuseries",
    "Reality",
    "Variety",
    "Co-productions",
    "Continuations",
    # "Regional original programming",
    # "Drama",
    # "Original films",
    # "Feature films",
    # "Documentaries",
    # "Specials",
    # "Stand-up comedy specials",
    # "Upcoming original programming",
    # "Ordered",
    # "Continuations",
    # "In development",
    # "Upcoming original films",
    # "Feature films",
    # "Exclusive international distribution",
    # "TV shows",
    # "Drama",
    # "Comedy",
    # "Animation",
    # "Adult animation",
    # "Anime",
    # "Kids and family",
    # "Non-English language scripted",
    # "Continuations",
    # "Films",
    # "Upcoming",
    # "Pilots not picked up to series",
    # "Notes",
    # "References",
  ])
  queue_as :default

  def perform(*args)
    response = HTTParty.get(URL)
    doc = Nokogiri::HTML(response)

    ALLOWED_CATEGORIES.each do |category|
      originals_header = doc.at(".mw-headline:contains('#{category}')")
      originals_section = originals_header.parent

      originals = originals_section.css('~ .wikitable:first tr td:first')  
      originals.each do |node|
        # Removes citations from text. EX: [23]
        title = (node.text[/^.*?(?=\[)/] || node.text).chomp
        next if title.blank?

        import_show({
          id: title.parameterize,
          title: title
        })
      end
    end
  end

  def import_show(program)
    show = Show.prime.find_or_initialize_by(original_streaming_network_id: program[:id])
    show.title = program[:title]
    show.save if show.tmsId.blank? # if it's already been matched, don't update
  end
end
