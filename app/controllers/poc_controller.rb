class PocController < ApplicationController
  def index
    @whiteboards = Poc::Whiteboard.all
    @rooms = Poc::Room.all
    @study_sessions = Poc::StudySession.all
  end

end
