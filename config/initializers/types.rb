class MongoidIdType < ActiveRecord::Type::String
  def serialize(value)
    if value.is_a?(BSON::ObjectId)
      super(value.to_s)
    else
      super
    end
  end
end

ActiveRecord::Type.register(:mongoid_id, MongoidIdType)
