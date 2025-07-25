class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.order(:keyword)
  end
end
