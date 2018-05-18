require './app/services/odds_ares/new_odds_are_service'
require './app/services/notifications/' \
  'new_challenge_request_notification_service'
# Controller for handling the initiator's request for an Odds Are
class ChallengeRequestsController < ApplicationController
  before_action :authenticate_user!

  def new
    @friends = current_user.friends
    if @friends.empty?
      @action = 'send an odds are'
      render 'pages/need_friends'
    else
      @challenge_request = ChallengeRequest.new
    end
  end

  def create
    @challenge_request = ChallengeRequest.new(challenge_params)
    recipient = User.find(odds_are_params)

    if !current_user.friends.include? recipient
      raise Exception, 'You must be friends with the recpient to odds are them'
    elsif @challenge_request.save
      NewOddsAreService.new(@challenge_request, current_user, recipient).call
      NewChallengeRequestNotificationService.new(@challenge_request).call
      flash[:notice] = 'Odds are sent to ' + recipient.full_name
      redirect_to odds_ares_show_current_path(show_friends: 'active')
    else
      @friends = current_user.friends
      render 'new'
    end
  end

  def show
    @challenge_request = ChallengeRequest.find(params[:id])
    if @challenge_request.odds_are.should_create_response(current_user)
      @challenge_response = ChallengeResponse.new
    elsif @challenge_request.odds_are.initiator == current_user
      render 'show_as_actor'
    else
      render 'pages/expired'
    end
  end

  private

  def challenge_params
    params.require(:challenge_request).permit(:action)
  end

  def odds_are_params
    params.require(:recipient_id)
  end
end
