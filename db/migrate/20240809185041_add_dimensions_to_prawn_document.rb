class AddDimensionsToPrawnDocument < ActiveRecord::Migration[7.1]
  def change
    add_column :prawn_documents, :width, :decimal
    add_column :prawn_documents, :height, :decimal
  end
end
