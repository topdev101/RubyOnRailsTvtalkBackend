SELECT "title", "id", "tmsId", "preferred_image_uri", "releaseYear", "genres", "subType", "cast", "popularity_score",
  LOWER(title) as "lower_title",
  "popularity_score" - (date_part('year', now()) - "releaseYear") as "sort_score"
FROM "shows"
  WHERE "shows"."subType" IN ('Feature Film', 'Series', 'TV Movie')
    AND "shows"."tmsId" IS NOT NULL
    AND "shows"."releaseYear" IS NOT NULL
    AND NOT ("tmsId" like 'EP%')
    AND "shows"."titleLang" = 'en'
