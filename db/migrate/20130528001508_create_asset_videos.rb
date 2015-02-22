class CreateAssetVideos < ActiveRecord::Migration
  def change
    create_table :asset_videos do |t|
	  t.references :video, :null => false
	  t.string :source
	  t.string :source_embed_url
	  t.string :type
	  t.string :content_type
	  t.integer :file_size
      t.timestamps
    end
  end
end
