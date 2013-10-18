class AccessSerializer < ActiveModel::Serializer
  # Don't expose secrets via .json
  attributes :id
end
