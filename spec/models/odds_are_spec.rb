require 'rails_helper'

RSpec.describe OddsAre, type: :model do
  it 'has a valid factory' do
    odds_are = build(:odds_are)
    expect(odds_are).to be_valid
  end
end
