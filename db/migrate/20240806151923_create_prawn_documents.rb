class CreatePrawnDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :prawn_documents do |t|
      t.string :title
      t.string :string
      t.text :content

      t.timestamps
    end
  end
end
