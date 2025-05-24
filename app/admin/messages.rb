ActiveAdmin.register Message do
  controller do
    skip_authorization_check
  end

  permit_params :content, :property_id, :sender_id, :receiver_id

  index do
    selectable_column
    id_column
    column :content
    column :property
    column :sender
    column :receiver
    column :created_at
    actions
  end

  filter :content
  filter :property
  filter :sender
  filter :receiver
  filter :created_at

  show do
    attributes_table do
      row :id
      row :content
      row :property
      row :sender
      row :receiver
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :content
      f.input :property
      f.input :sender
      f.input :receiver
    end
    f.actions
  end
end 