ActiveRecord::Schema.define(:version => 1) do

  create_table "products", :force => true do |t|
    t.string   "product_type_cd"
    t.integer  "price"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
end
