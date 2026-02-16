module TextCleaner
   # removes special characters and optionally uppercases
   
  def clean_information(word, up = false)
    return nil if word.nil?

    cleaned = word.gsub(/[^A-Za-z0-9\s]/, '')
    up ? cleaned.upcase : cleaned
  end

end