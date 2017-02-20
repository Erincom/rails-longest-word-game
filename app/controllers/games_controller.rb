class GamesController < ApplicationController
  def run
    @grid = generate_grid
    @start_time = Time.now
  end

  def score
    @attempt = params[:word]
    @grid = params[:grid]

    @result = { time: 0, translation: nil, score: 0, message: "" }

    @result[:time] = Time.now - params[:start_time].to_datetime

    if @attempt.upcase.chars.map { |letter| @grid.include?(letter) }.all? && !(@attempt.each_char.find { |c| @attempt.count(c) > 1 })
      url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=0aec7ef2-307f-4fa3-97f5-83f3e802939a&input=#{@attempt}"
      serialized_url = open(url).read
      hashed_translation = JSON.parse(serialized_url)
      unless @attempt == hashed_translation["outputs"][0]["output"]
        @result[:translation] = hashed_translation["outputs"][0]["output"]
        @result[:message] = "Well done!"
        if @result[:time] < 5.0
          @result[:score] += 2
        else
          @result[:score] += 1
        end

        if @attempt.length > 4
          @result[:score] += 2
        else
          @result[:score] += 1
        end
        return @result[:score]
      else
        @result[:score] = 0
        @result[:message] = "not an english word"
      end
    else
      @result[:score] = 0
      @result[:message] = "not in the grid"
    end
    return @result
  end

  def generate_grid
    grid = []

    9.times.map do
      random_letter = ("A".."Z").to_a.sample
      grid << random_letter
    end
    return grid
  end
end
