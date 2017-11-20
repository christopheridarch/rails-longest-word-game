require 'open-uri'
# require 'json'

class WordsController < ApplicationController
  def game
    @word = generate_grid(15)
  end

  def score
    grid = params[:grid].chars
    attempt = params[:word]
    start_time = Time.parse(params[:start_time])
    end_time= Time.now
    @score = run_game(attempt, grid, start_time, end_time)
  end


private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    return Array.new(grid_size).map { ("A".."Z").to_a.sample }
  end

  def not_in_the_grid?(attempt, grid)
    letters = Hash.new { 0 }
    grid.map { |x| letters[x] += 1 }

    attempt.chars.each do |x|
      if !grid.include?(x.upcase) || attempt.upcase.count(x.upcase) > letters[x.upcase]
        return true
      end
    end
    return false
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result

    if not_in_the_grid?(attempt, grid)
      return { time: end_time - start_time, score: 0, message: "Your word is not in the grid!" }
    end

    url = 'https://wagon-dictionary.herokuapp.com/' + attempt
    attempt = JSON.parse(open(url).read)

    if attempt['found']
      score = attempt['length'] / (end_time - start_time)
      return { time: end_time - start_time, score: score, message: "Well Done!" }
    end

    return { time: end_time - start_time, score: 0, message: "Your word is not an english word" }
  end
end
