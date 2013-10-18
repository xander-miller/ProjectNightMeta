class UserSerializer < ActiveModel::Serializer
  attributes :id, :provider, :uid, :mu_name, :mu_link, :mu_photo_link,
    :mu_thumb_link, :city, :country, :created_at, :updated_at
end