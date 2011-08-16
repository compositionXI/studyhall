class PocController < ApplicationController
  def index
    @whiteboards = Poc::Whiteboard.all
  end

end
