require './app/services/odds_ares/new_odds_are_service'
require './app/services/notifications/' \
  'new_challenge_request_notification_service'
# Perform tasks required after saving a Challenge Request
class ChallengeRequestAfterSaveService < ApplicationController
  include ApplicationHelper
  def initialize(initiator, recipient, challenge_request)
    @challenge_request = challenge_request
    @initiator = initiator
    @recipient = recipient
  end

  def call
    NewOddsAreService.new(@challenge_request, @initiator, @recipient).call
    NewChallengeRequestNotificationService.new(@challenge_request).call
  end
end
