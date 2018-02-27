Hanami::Model.migration do
  change do
    create_table :admins do
      primary_key :id

      column :email,              String
      column :encrypted_password, String, null: false
      column :activation_token,   String

      column :created_at,         DateTime, null: false
      column :updated_at,         DateTime, null: false
      column :activated_at,       DateTime
    end
  end
end
