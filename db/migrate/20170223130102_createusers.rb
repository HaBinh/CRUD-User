class Createusers < ActiveRecord::Migration[5.0]
  def change
  	create_table :users do |t|	
  		t.string :first_name
  		t.string :last_name
  		t.string :email
  		t.string :password
  		t.string :about_me
  		t.string :avatar_path
      t.integer :status
      t.boolean :activated 
      t.string :activation_token
  	end
  end
end
