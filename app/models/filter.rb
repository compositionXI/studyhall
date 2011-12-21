require 'active_support/inflector'

class Filter

  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Add an attr accessor for any attribute you want to use in a form
  attr_accessor :model_name, :object, :notebooks, :notes, :created_at, :course_id, :name

  def initialize(options={})
    options ||= {}
    options.each_pair do |key,value|
      key = "#{key}="
      self.send(key,value) if self.respond_to? key
    end
    newObject if model_name
  end
  
  def newObject
    self.send("object=", Kernel.const_get(model_name).new)
  end

  def persisted?
    false
  end

  def title
    "Filter Your #{object_name.pluralize}"
  end
  
  def object_name
    object.class.to_s
  end
  
  def attributes
    attributes = {}
    self.instance_variables.each {|var| attributes[var.to_s.delete("@")] = self.instance_variable_get(var) unless var == :@model_name || var == :@object }
    attributes
  end

  def query_params
    attrs = attributes
    params_for_query = {:filter => {}}
    case object_name
    when "Note" || "Notebook"
      params_for_query[:filter][:note] = {} if attrs["notes"]
      params_for_query[:filter][:notebook] = {} if attrs["notebooks"]
      attrs.each_pair do |k, v|
        params_for_query[:filter][:note][k] = v if Note.column_names.include?(k.to_s) && attrs["notes"] && !v.empty?
        params_for_query[:filter][:notebook][k] = v if Notebook.column_names.include?(k.to_s) && attrs["notebooks"] && !v.empty?
      end
      params_for_query[:filter][:notebooks] = notebooks
      params_for_query[:filter][:notes] = notes
      params_for_query[:filter][:course_id] = attrs["course_id"] if attrs["course_id"] && attrs["notes"]
    when object_name == "StudySession"
    end
    params_for_query.to_query
  end

  def to_query
    "/#{model_name.tableize}?#{query_params}"
  end
end
