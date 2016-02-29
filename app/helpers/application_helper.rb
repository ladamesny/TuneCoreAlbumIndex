module ApplicationHelper

  def convert_to_duration milliseconds
    if Song.data_cached?
      seconds = milliseconds/1000
      minutes = seconds/60
      seconds = seconds - (minutes * 60)
      seconds = "0#{seconds}" unless seconds > 9
      "#{minutes}:#{seconds} "
    end
  end
end
