require 'active_support/inflector'

class Filter

  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :model_name, :user_ids

  def initialize(options={})
    options ||= {}
    options.each_pair do |key,value|
      key = "#{key}="
      self.send(key,value) if self.respond_to? key
    end
  end

  def persisted?
    false
  end

  def title
    "Filter Your StudyHalls"
  end

  def query_params
    {:user_ids => user_ids}.to_query
  end

  def to_query
    "/#{model_name.pluralize}?#{query_params}"
  end

end
