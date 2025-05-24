ActiveAdmin.register PropertyComment do
  menu priority: 5

  controller do
    skip_authorization_check
    defaults resource_class: PropertyComment
  end

  actions :all

  permit_params :content, :property_id, :user_id

  index do
    selectable_column
    id_column
    column :content
    column :property
    column :user
    column :created_at
    actions
  end

  filter :content
  filter :property
  filter :user
  filter :created_at

  show do
    attributes_table do
      row :id
      row :content
      row :property
      row :user
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :content
      f.input :property
      f.input :user
    end
    f.actions
  end
end 