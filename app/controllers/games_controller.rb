require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split(" ")
    @grid = params[:letters].split(" ")

    if word_validation(@word, @letters)
      @message = "<strong>Congratulations!</strong> #{@word} is a valid english word!".html_safe
    elsif english_word?(@word) == false
      @message = "Sorry but <strong>#{@word}</strong> does not seem to be a valid english word".html_safe
    else included_in_grid?(@word, @letters)
      @message = "Sorry but <strong>#{@word}</strong> cannot be built out of #{@grid.join(', ')}".html_safe
    end
  end

  def word_validation(attempt, grid)
    english_word?(attempt) && included_in_grid?(attempt, grid)
  end

  def english_word?(attempt)
    parsed = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    answer = parsed["found"]
  end

  def included_in_grid?(attempt, grid)
    attempt.upcase.split(//).all? do |letter|
      grid.count(letter) >= attempt.upcase.split(//).count(letter)
    end
  end
end
