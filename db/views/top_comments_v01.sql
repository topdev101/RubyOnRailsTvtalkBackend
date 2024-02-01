SELECT id, sum(COALESCE(likes_count,0) + COALESCE(sub_comments_count,0) + COALESCE(shares_count,0)  ) as score FROM "comments" WHERE likes_count > 0 OR sub_comments_count > 0 OR shares_count > 0 AND status = 0 GROUP BY "id" ORDER BY score desc