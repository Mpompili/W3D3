class AddUserIdToShortenedUrls < ActiveRecord::Migration[5.1]
  def change
    add_column :shortened_urls, :user_id, :integer
  end
end
