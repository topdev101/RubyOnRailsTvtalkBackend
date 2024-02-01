json.merge! @show.attributes
json.networks @show.networks_and_streaming_services
json.display_genres GenreMap.find_display_genres(@show.genres)
