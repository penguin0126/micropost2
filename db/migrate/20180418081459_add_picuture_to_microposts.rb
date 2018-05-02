class AddPicutureToMicroposts < ActiveRecord::Migration[5.0]
  def change
    add_column :microposts, :picture, :string, after: :content
  end
end
