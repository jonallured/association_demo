module HasMongoidAssociation
  extend ActiveSupport::Concern

  class_methods do
    def belongs_to_mongoid(name)
      foreign_key_attribute_name = "#{name}_id"
      getter_method_name = name.to_s
      getter_klass_name = name.to_s.camelcase.singularize.constantize
      setter_method_name = "#{name}="

      attribute foreign_key_attribute_name, :mongoid_id
      alias_attribute name, foreign_key_attribute_name.to_sym

      define_method setter_method_name do |mongoid_model|
        foreign_key_value = mongoid_model.id.to_s
        assign_attributes({foreign_key_attribute_name => foreign_key_value})
        foreign_key_value
      end

      define_method getter_method_name do
        foreign_key = attributes[foreign_key_attribute_name]
        getter_klass_name.find_by(id: foreign_key)
      end
    end

    def has_many_mongoid(name)
      foreign_key_attribute_name = "#{to_s.underscore}_id"
      getter_method_name = name.to_s
      getter_klass_name = name.to_s.camelcase.singularize.constantize

      define_method getter_method_name do
        getter_klass_name.where(foreign_key_attribute_name => id)
      end
    end
  end
end
