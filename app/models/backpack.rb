Notable = Struct.new(:id, :created_at, :class_name)
class Backpack
  
  def initialize(user)
    @user = user
  end

  def contents(options={})
    @options = options
    # Need a completely different method for finding filtered notes because you want to find notes that are in notebooks.
    # What about when note or notebooks is not checked in the filter form
    @notes = find_notes
    @notebooks = find_notebooks
    @notables = (@notes.sort_by(&:created_at).reverse + @notebooks)
    @start_index, @end_index = nil, nil
    fetch_contents(@notables[start_index..end_index])
  end

  private
    
    def create_notables(records)
      records.map{|n| Notable.new(n.id, n.created_at, n.class.to_s) }
    end
    
    def find_notes
      if @options[:filter].nil?
        create_notables @user.notes.unsorted.select([:id, :created_at]).all
      elsif @options[:filter][:notes] == "1"
        create_notables filtered_notes
      else
        []
      end
    end
    
    def filtered_notes
      notes = @user.notes
      if @options[:filter][:note]
        notes = @user.notes.where(["name like ?", "%#{@options[:filter][:note][:name]}%"])
      end
      notes.unsorted.in_range(@options[:filter][:start_date], @options[:filter][:end_date]).all.flatten.uniq
    end
    
    def find_notebooks
      if @options[:filter].nil?
        create_notables @user.alpha_ordered_notebooks
      elsif @options[:filter][:notebooks] == "1"
        create_notables filtered_notebooks
      else
        []
      end
    end
    
    def filtered_notebooks
      notebooks = @user.notebooks
      if @options[:filter][:notebook]
        name = @options[:filter][:notebook][:name]
        course_id = @options[:filter][:notebook][:course_id]
        notebooks = notebooks.where(["name like ?", "%#{name}%"]) if name
        notebooks = notebooks.where(["name like ?", course_id]) if course_id
      end
      Notebook.alpha_ordered(notebooks.in_range(@options[:filter][:start_date], @options[:filter][:end_date]))
    end

    def page
      return 1 if @options[:page].nil?
      page = @options[:page].to_i
      return page if page > 0
      raise ArgumentError.new("Backpack#contents expects :page option to be string or integer representing non-zero, non-negative number")
    end

    def per_page
      return 21 if @options[:per_page].nil?
      per_page = @options[:per_page].to_i
      return per_page if per_page > 0
      raise ArgumentError.new("Backpack#contents expects :per_page option to be string or integer representing non-zero, non-negative number")
    end

    def start_index
      @start_index ||= page.to_i < 2 ? 0 : ((page-1) * per_page)
    end

    def end_index
      @end_index ||= @notables.size >= (start_index + per_page - 1) ? (start_index + per_page - 1) : (@notables.size - 1)
    end
  
    def fetch_contents(notables)
      notables ||= []
      notables.map do |notable|
        notable.class_name.constantize.send(:find, notable.id)
      end
    end

end
