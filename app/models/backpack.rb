Notable = Struct.new(:id, :created_at, :class_name)
class Backpack
  
  def initialize(user)
    @user = user
  end

  def contents(options={})
    @options = options
    @notes = @user.notes.unsorted.select([:id, :created_at]).all.map{|n| Notable.new(n.id, n.created_at, n.class.to_s) }
    @notebooks = @user.notebooks.select([:id, :created_at]).all.map{|n| Notable.new(n.id, n.created_at, n.class.to_s) }
    @notables = (@notes + @notebooks).sort_by(&:created_at).reverse
    @start_index, @end_index = nil, nil
    fetch_contents(@notables[start_index..end_index])
  end

  private

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
