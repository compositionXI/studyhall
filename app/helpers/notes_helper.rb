module NotesHelper
  def edit_note_back_path
    (@notebook ? notebook_path(@notebook) : notes_path)
  end

  def day_suffix(date)
    day = date.strftime("%-d")
    return "st" if day.end_with? "1"
    return "nd" if day.end_with? "2"
    return "rd" if day.end_with? "3"
    "th"
  end

  def formatted_date(date)
    date.strftime("%B %-d<sup>#{day_suffix(date)}</sup>, %Y").html_safe
  end
end
