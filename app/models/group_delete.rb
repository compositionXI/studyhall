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

  def object_class
    return nil if class_name.blank?
    class_name.camelize.constantize
  end

  def object_ids_array
    object_ids.split(",").map(&:strip)
  end

  def process
    if (object_class.nil? || for_realz == "0")
      return false
    else
      object_class.delete(object_ids.split(","))
    end
  end

  def persisted?
    false
  end

  def title
    'Delete selected items'
  end

end
