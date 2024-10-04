class AddApoioToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :apoio_estudo, :boolean, default: false
    add_column :users, :ajuda_social, :boolean, default: false
    add_column :users, :apoio_bolsas, :boolean, default: false
  end
end
