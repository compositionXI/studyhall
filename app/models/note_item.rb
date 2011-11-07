class NoteItem
  
  attr_accessor :content

  def initialize(notable)
    self.content = notable
  end

  def self.init_set(set)
    if set.is_a? Array
      set.map { |notable| new(notable) }
    elsif set.is_a? ActiveRecord::Relation
      set.all.map { |notable| new(notable) }
    else
      raise ArgumentError.new("NoteItem#init_set received #{set.class.to_s}, but expects an Array or ActiveRecord::Relation")
    end
  end

  def name
    content.name
  end

  def created_at
    content.created_at
  end

  def course_name
    content.course_name
  end

  def notebook?
    content.is_a? Notebook
  end

  def note?
    content.is_a? Note
  end

  def notes
    content.notes if notebook?
  end

  def id
    content.id
  end

  def class_name
    content.class.to_s.downcase
  end

  def html_class
    @html_class ||= "note_item #{content.class.to_s.downcase}"
    @html_class += " draggable" if note?
    @html_class += " droppable" if notebook?
    @html_class
  end

  def html_id
    @html_id ||= "#{class_name}_#{content.id}"
  end

  def url_params
    if note?
      content
    else
      [content, :notes]
    end
  end

end
