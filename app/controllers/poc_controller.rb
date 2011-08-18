class PocController < ApplicationController
  def index
    @whiteboards = Poc::Whiteboard.all
    @rooms = Poc::Room.all
  end

end
