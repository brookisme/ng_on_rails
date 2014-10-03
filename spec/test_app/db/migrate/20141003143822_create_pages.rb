class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :doc, index: true
      t.string :subject
      t.text :body
      t.integer :order_index

      t.timestamps
    end
  end
end
