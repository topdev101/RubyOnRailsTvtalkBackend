class ChatGpt::CommentOnShowJob < ApplicationJob
  queue_as :default

  def perform(show, comment_count: 4, sub_comment_count: 0)
    @chat_gpt = ChatGpt.new

    @show = show
    bots = User.where(is_robot: true).where.not(bot_profile: nil).sample(20)

    comments = []

    comment_count.to_i.times do
      bot = bots.shift
      comments << create_comment(bot)
    end

    sub_comments = []

    comments.sample(sub_comment_count.to_i).each do |comment|
      bot = bots.shift
      sub_comments << create_sub_comment(comment, bot)
    end
  end

  def create_comment(bot)
    prompt = comment_prompt(bot)
    comment = @show.comments.new
    comment.user_id = bot.id
    comment.text = @chat_gpt.chat(prompt)
    comment.ai_prompt = prompt
    comment.save!
    comment
  end

  def create_sub_comment(comment, bot)
    sub_comment = comment.sub_comments.new
    sub_comment.user_id = bot.id
    sub_comment.text = @chat_gpt.chat sub_comment_prompt(comment, bot)
    sub_comment.save!
    sub_comment
  end

  def create_sub_sub_comment(sub_comment, bot)
    sub_sub_comment = sub_comment.sub_comments.new
    sub_sub_comment.user_id = bot.id
    sub_sub_comment.text = @chat_gpt.chat sub_sub_comment_prompt(sub_comment, bot)
    sub_sub_comment.save!
    sub_sub_comment
  end

  def sub_sub_comment_prompt(sub_comment, bot)
    <<~PROMPT
      Persona:
      #{bot.as_json(only: %i[id username gender bio city birth_date])}

      Do not include hashtags or refer to yourself. Writing from the perspective of the provide persona, write a response to the following sub comment:

      Sub comment data:
      #{sub_comment.as_json(only: %i[body])}

    PROMPT
  end

  def sub_comment_prompt(comment, bot)
    <<~PROMPT
      Persona:
      #{bot.as_json(only: %i[id username gender bio city birth_date])}

      Do not include hashtags or refer to yourself. Don't introduce yourself or say hi to the previous commenter. Just respond to their comment.

      Writing in the social media style of the provided persona, write a short response to the following comment:

      Comment data:
      #{comment.as_json(only: %i[body])}

      For context, the original comment was based on this show:
      Show data:
      #{@show.as_json(only: %i[longDescription origAirDate releaseDate title genres episodeTitle episodeNum seasonNum top_cast])}
      If you have information about the show, you may use it to inform your response. If not, then refer the provided show data.

    PROMPT
  end

  def comment_prompt(bot)
    <<~PROMPT
      Persona:
      #{bot.as_json(only: %i[id username gender bot_profile city birth_date])}

      When creating your comment, consider the demographics of the persona and craft your response based on language that would typically be associated with that demographic. Also keep in mind these comments are for a social media website and don't need to be too formal.#{' '}

      Show data:
      #{@show.as_json(only: %i[longDescription origAirDate releaseDate title genres episodeTitle episodeNum seasonNum top_cast])}.
      If you have information about the show, you may use it to inform your response. If not, then refer the provided show data.

      Do not use hashtags or refer to yourself. From the perspective of the provided persona, write a tweet consisting of reactions or questions about the TV show episode or movie provideed. Write in the style that you think they would post on social media. They should not refer to themselves - for example, don't say \"As a doctor....\". When possible, the reactions should be specific about plot points. The comments should strive to be insightful, witty, or funny. The comment will be posted to the social media site TV Talk. Keep in mind the release or air date of the show in relation to the current time - for example, if it is an old show the comment may trend more nostalgic. If it is a new show, the comment may trend more topical. Also keep in mind the age of the the persona when choosing your writing style. When you respond to one of the prompts below, don't do it so directly. It is meant as a guide and not something you should take verbatim. Also do not say stuff like 'just watched' because it is too common. Multiple bots will be creating comments and we want the responses to be varied and natural. Also do not mention the episode title or number. Also do not use puns based on the show or episode name."

      #{comment_prompt_options.sample}

      Write between #{word_count.sample}.
    PROMPT
  end

  def word_count
    ['25 and 150 words', '15 to 30 words', '120 and 140 characters', '2 to 3 sentences']
  end

  def comment_prompt_options
    options = []
    options << 'discuss the narrative structure and pacing in this show and explore how these elements contribute to the overall storytelling experience. Write is as a tweet'

    options << 'examine the use of symbolism and metaphor in the show. Discuss how these literary devices contribute to the depth of the story'

    options << 'evaluate the performances of the main cast in. Focus on how the actors bring their characters to life.'

    options << 'imagine a hilarious alternative ending. Ceate a humorous twist that would change the outcome. Do not use puns containing the show or episode name.'

    options << 'write a playful comment that involves a humorous comparison or analogy. Connect the events or characters to something amusing.'
    options
  end
end
