class CreateWeasyprintDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :weasyprint_documents do |t|
      t.string :title
      t.text :template
      t.text :variables

      t.timestamps
    end
  end
end
