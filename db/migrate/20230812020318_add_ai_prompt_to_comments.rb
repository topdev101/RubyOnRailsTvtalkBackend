class AddAiPromptToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :ai_prompt, :text
  end
end
