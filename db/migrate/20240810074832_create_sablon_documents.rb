class CreateSablonDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :sablon_documents do |t|
      t.string :title
      t.text :variables
      t.timestamps
    end
  end
end
