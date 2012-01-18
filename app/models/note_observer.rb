class NoteObserver < ActiveRecord::Observer
  observe :note, :notebook

  def after_create(note)
    return true unless note.shareable?
    note.owner.followers.each do |user|
      message_body = ActivityRenderer.new.generate_message(user, 'note_share', :note => note, :user => note.user)
      ActivityMessage.create(:user => user, :body => message_body, :activist => note.user)
    end
  end
end
