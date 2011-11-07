class GroupDelete
  
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :class_name, :object_ids, :for_realz

  def initialize(options={})
    options ||= {}
    options.each_pair do |key,value|
      key = "#{key}="
      self.send(key,value) if self.respond_to? key
    end
  end

  def object_title
    if class_name == "study_session"
      "StudyHall"
    else
      class_name
    end
  end

  def object_class
    return nil if class_name.blank?
    class_name.camelize.constantize
  end

  def object_ids_array
    @object_ids_array ||= object_ids.split(",").map do |identifier|
      match = identifier.match(/([a-z_]+)_(\d+)/)
      if match[1] && Object.const_defined?(match[1].camelize)
        [match[1].camelize.constantize, match[2]]
      else
        raise ArgumentError.new("Invalid object identifier for group delete: #{identifier}")
      end
    end
    @object_ids_array
  end

  def process
    if (object_ids_array.empty? || for_realz == "0")
      return false
    else
      object_ids_array.each do |object_id|
        object_id[0].delete(object_id[1])
      end
      true
    end
  end

  def persisted?
    false
  end

  def title
    'Delete selected items'
  end

end
