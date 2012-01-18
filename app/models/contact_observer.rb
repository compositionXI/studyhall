class ContactObserver < ActiveRecord::Observer
  observe :contact

  def after_create(contact)
    Notifier.contact_form(contact).deliver
  end
end

