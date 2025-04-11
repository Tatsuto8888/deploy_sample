class CreateBoards < ActiveRecord::Migration[7.2]
  def change
    create_table :boards do |t|
      t.string :amount
      t.text :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
