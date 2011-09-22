module NotesHelper
  def edit_note_back_path
    (@notebook ? notebook_path(@notebook) : notebooks_path)
  end
end
