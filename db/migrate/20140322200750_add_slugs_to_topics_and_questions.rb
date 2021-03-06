class AddSlugsToTopicsAndQuestions < ActiveRecord::Migration
  def change
    add_column :topics, :slug, :string
    add_index  :topics, :slug, :unique => true
    add_column :questions, :slug, :string
    add_index  :questions, :slug, :unique => true
  end
end
