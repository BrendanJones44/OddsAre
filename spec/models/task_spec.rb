require 'rails_helper'

RSpec.describe Task, type: :model do
  it "has a valid factory" do
    task = build(:task)
    expect( task ).to be_valid
  end
end
