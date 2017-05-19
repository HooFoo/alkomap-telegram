ActiveAdmin.register Point do
  permit_params :lng, :lat, :name, :description, :user_id, :rating, :point_type, :isFulltime, :cardAccepted,
                :beer, :hard, :elite

  form do |f|
    f.actions
    f.inputs do
      f.input :lng
      f.input :lat
      f.input :name
      f.input :description
      f.input :user
      f.input :rating
      f.input :point_type, as: :select, collection: Point::Types, include_blank: false
      f.input :isFulltime
      f.input :cardAccepted
      f.input :beer
      f.input :hard
      f.input :elite
    end
    f.actions
  end
end
