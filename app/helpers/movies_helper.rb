module MoviesHelper
  def total_gross(movie)
    if movie.flop?
      "Flop!"
    else
      number_to_currency(movie.total_gross, precision: 0, unit: "£")
    end
  end

  def year_of(movie)
    movie.released_on.year
  end

  def nav_link_to(text, url)
    if current_page?(url)
      link_to(text, url, class: "active")
    else
      link_to(text, url)
    end
  end

  ### No longer in use
  # def average_stars(movie)
  #   if movie.average_stars.zero?
  #     content_tag(:strong, "No reviews")
  #   else
  #     "*" * movie.average_stars.round
  #   end
  # end
end
