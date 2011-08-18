class PocController < ApplicationController
  def index
    @whiteboards = Poc::Whiteboard.all
    @rooms = Tokbox::Room.all
  end

end
