FactoryGirl.define do
  factory :notification do
    created_at { Faker::Time.between(14.days.ago, 10.days.ago, :all) }
    # Guarentee the updated_at after created_at
    updated_at { Faker::Time.between(9.days.ago, Date.today, :all) }
  end
end
# t.integer  "recipient_id"
# t.integer  "actor_id"
# t.datetime "read_at"
# t.string   "action"
# t.integer  "notifiable_id"
# t.string   "notifiable_type"
# t.datetime "created_at",      null: false
# t.datetime "updated_at",      null: false
# t.datetime "clicked_at"
# t.datetime "acted_upon_at"
# t.integer  "dismiss_type"
