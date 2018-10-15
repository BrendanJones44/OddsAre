# Controller for viewing and managing Tasks
class TasksController < ApplicationController
  before_action :authenticate_user!

  def show_lost
    @tasks = Task.where(loser: current_user).order(created_at: :desc)
  end

  def show
    @task = Task.find(params[:task_id])
    if @task.both_marked_complete?
      other_user = @task.winner == current_user ? @task.loser : @task.winner
      n = Notification.where(notifiable: @task,
                             actor: other_user,
                             recipient: current_user).first
      n&.update(acted_upon_at: Time.zone.now)
    end
  end

  def mark_as_done_from_loser
    @task = Task.find(params[:task_id])
    if @task.can_user_update_as_loser?(current_user)
      @task.update(loser_marked_completed_at: Time.zone.now)
      Notification.create(recipient: @task.winner,
                          actor: current_user,
                          action: 'marked a lost odds are as complete',
                          notifiable: @task,
                          dismiss_type: 'on_click')
      other_user = @task.winner == current_user ? @task.loser : @task.winner
      n = Notification.where(notifiable: @task,
                             actor: other_user,
                             recipient: current_user).first
      n&.update(acted_upon_at: Time.zone.now)
    end
    redirect_back(fallback_location: root_path)
  end

  def mark_as_done_from_winner
    @task = Task.find(params[:task_id])
    if @task.can_user_update_as_winner?(current_user)
      @task.update(winner_marked_completed_at: Time.zone.now)
      Notification.create(recipient: @task.loser,
                          actor: current_user,
                          action: 'marked a lost odds are as complete',
                          notifiable: @task,
                          dismiss_type: 'on_click')
      other_user = @task.winner == current_user ? @task.loser : @task.winner
      n = Notification.where(notifiable: @task,
                             actor: other_user,
                             recipient: current_user).first
      n&.update(acted_upon_at: Time.zone.now)
    end
    redirect_back(fallback_location: root_path)
  end
end
