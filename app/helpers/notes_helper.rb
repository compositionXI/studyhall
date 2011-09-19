module NotesHelper
  def edit_note_back_path
    return notebook_path(@notebook) if @notebook

    if @note.new_record?
      notebooks_path
    else
      notebook_note_path(@notebook)
    end
  end
end
