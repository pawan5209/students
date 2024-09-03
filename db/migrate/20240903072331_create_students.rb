class CreateStudents < ActiveRecord::Migration[7.2]
  def change
    create_table :students do |t|
      t.string :name
      t.string :grade
      t.integer :age
      t.string :gender
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
