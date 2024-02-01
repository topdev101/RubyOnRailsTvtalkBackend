require 'openai'

class ChatGpt
  def initialize
    @client = OpenAI::Client.new
  end

  def chat(message)
    response = @client.chat(
      parameters: {
        model: model,
        messages: [{ role: 'user', content: message }],
        temperature: 0.7
      }
    )

    raise response.dig('error', 'message') if response.dig('error', 'message')

    response.dig('choices', 0, 'message', 'content')
  end

  def model
    ENV.fetch('OPEN_AI_CHAT_GPT_VERSION', 'gpt-3.5-turbo') # gtp-4 or gpt-3.5-turbo
  end
end
