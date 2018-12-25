require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:loser) { build(:user) }
  let(:winner) { build(:user) }

  it 'has a valid factory' do
    task = build(:task)
    expect(task).to be_valid
  end

  describe '#can_user_update_as_loser?' do
    context 'when loser already marked as completed' do
      let(:task) do
        Task.create(loser: loser,
                    winner: winner,
                    loser_marked_completed_at: Time.zone.now)
      end
      it { expect(task.can_user_update_as_loser?(loser)).to be false }
    end

    context 'when user is not the loser' do
      let(:task) do
        Task.create(loser: loser, winner: winner)
      end
      it { expect(task.can_user_update_as_loser?(winner)).to be false }
    end

    context 'when user is the loser' do
      let(:task) do
        Task.create(loser: loser, winner: winner)
      end
      it { expect(task.can_user_update_as_loser?(loser)).to be true }
    end
  end

  describe '#can_user_update_as_winner?' do
    context 'when winner already marked as completed' do
      let(:task) do
        Task.create(loser: loser,
                    winner: winner,
                    winner_marked_completed_at: Time.zone.now)
      end
      it { expect(task.can_user_update_as_winner?(winner)).to be false }
    end

    context 'when user is not the winner' do
      let(:task) do
        Task.create(loser: loser, winner: winner)
      end
      it { expect(task.can_user_update_as_winner?(loser)).to be false }
    end

    context 'when user is the winner' do
      let(:task) do
        Task.create(loser: loser, winner: winner)
      end
      it { expect(task.can_user_update_as_winner?(winner)).to be true }
    end
  end

  describe '#both_marked_as_complete?' do
    context 'with nobody marked as complete' do
      let(:task) do
        Task.create(loser: loser, winner: winner)
      end
      it { expect(task.both_marked_complete?).to be false }
    end

    context 'with just winner marked as complete' do
      let(:task) do
        Task.create(loser: loser,
                    winner: winner,
                    winner_marked_completed_at: Time.zone.now)
      end
      it { expect(task.both_marked_complete?).to be false }
    end

    context 'with just loser marked as complete' do
      let(:task) do
        Task.create(loser: loser,
                    winner: winner,
                    loser_marked_completed_at: Time.zone.now)
      end
      it { expect(task.both_marked_complete?).to be false }
    end

    context 'with both marked as complete' do
      let(:task) do
        Task.create(loser: loser,
                    winner: winner,
                    loser_marked_completed_at: Time.zone.now,
                    winner_marked_completed_at: Time.zone.now)
      end
      it { expect(task.both_marked_complete?).to be true }
    end
  end
end
