require 'rails_helper'
require './spec/support/odds_are_helpers'

RSpec.configure do |c|
  c.include OddsAreHelpers
end

describe ApplicationHelper do
  describe '#flash_class_name' do
    context 'notice' do
      it 'returns success' do
        expect(helper.flash_class_name('notice')). to eql 'success'
      end
    end

    context 'alert' do
      it 'returns danger' do
        expect(helper.flash_class_name('alert')). to eql 'danger'
      end
    end

    context 'unrecognized' do
      it 'returns empty string' do
        expect(helper.flash_class_name('not_a_color')). to eql ''
      end
    end
  end

  describe '#odds_are_title' do
    context 'not completed odds are' do
      let(:incomplete_odds_are) { odds_are_with_no_response }
      it 'returns the incomplete odds title' do
        expect(helper.odds_are_title(incomplete_odds_are))
          .to eql 'Odds Are in progress'
      end
    end

    context 'completed odds are' do
      let(:completed_odds_are) { odds_are_where_recipient_won }
      it 'returns the completed odds are title' do
        expect(helper.odds_are_title(completed_odds_are))
          .to eql 'Completed Odds Are'
      end
    end
  end
end
