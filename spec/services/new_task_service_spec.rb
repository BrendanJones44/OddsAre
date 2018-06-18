require 'rails_helper'
require './spec/support/odds_are_helpers'
require './app/services/tasks/new_task_service'

RSpec.configure do |c|
  c.include OddsAreHelpers
end

describe NewTaskService do
  describe '#call' do
    context 'with no winner from the odds are' do
      let(:odds_without_winner) { odds_are_with_no_winner }
      it 'does not create a task' do
        expect { NewTaskService.new(odds_without_winner).call }
          .to_not change { Task.count }
      end
    end

    context 'where the recipient won' do
      let(:odds_where_recipient_won) { odds_are_where_recipient_won }
      it 'creates a task where the recipient is the winner' do
        expect { NewTaskService.new(odds_where_recipient_won).call }
          .to change { Task.count }
        expect(Task.last.winner).to eql odds_where_recipient_won.recipient
        expect(Task.last.loser).to eql odds_where_recipient_won.initiator
      end
    end

    context 'where the initiator won' do
      let(:odds_where_initiator_won) { odds_are_where_initiator_won }
      it 'creates a task where the recipient is the winner' do
        expect { NewTaskService.new(odds_where_initiator_won).call }
          .to change { Task.count }
        expect(Task.last.winner).to eql odds_where_initiator_won.initiator
        expect(Task.last.loser).to eql odds_where_initiator_won.recipient
      end
    end

    context 'where the odds are is still on-going' do
      let(:odds_are_still_ongoing) { odds_are_with_no_response }
      it 'does not create a task' do
        expect { NewTaskService.new(odds_are_still_ongoing).call }
          .to_not change { Task.count }
      end
    end
  end
end
