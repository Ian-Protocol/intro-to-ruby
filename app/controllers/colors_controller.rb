class ColorsController < ApplicationController
  def index
    @colors = Color.order(:color)
  end
end
