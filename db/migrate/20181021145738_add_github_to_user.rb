class AddGithubToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github, :boolean
  end
end