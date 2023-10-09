module HasArAssociation
  extend ActiveSupport::Concern

  class_methods do
    def has_many_ar(name)
      foreign_key_attribute_name = "#{to_s.underscore}_id"
      getter_method_name = name.to_s
      getter_klass_name = name.to_s.camelcase.singularize.constantize

      define_method getter_method_name do
        getter_klass_name.where(foreign_key_attribute_name => id)
      end
    end
  end
end
