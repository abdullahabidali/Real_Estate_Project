ActiveAdmin.register User do
  controller do
    skip_authorization_check
    defaults resource_class: User
  end

  actions :all

  permit_params :email, :password, :password_confirmation, :name, :phone, :role_id, :avatar

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :phone
    column :role do |user|
      user.role.capitalize
    end
    column :created_at
    actions
  end

  filter :email
  filter :name
  filter :phone
  filter :role, as: :select, collection: ['buyer', 'seller']
  filter :created_at

  show do
    attributes_table do
      row :id
      row :email
      row :name
      row :phone
      row :role do |user|
        user.role.capitalize
      end
      row :created_at
      row :updated_at
      row :avatar do |user|
        if user.avatar.attached?
          image_tag url_for(user.avatar), style: "max-width: 200px;"
        else
          "No avatar uploaded"
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :name
      f.input :phone
      f.input :role, as: :select, collection: ['buyer', 'seller']
      f.input :avatar, as: :file
    end
    f.actions
  end

  batch_action :destroy, confirm: "Are you sure you want to delete these users?" do |ids|
    User.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} users"
  end

  batch_action :change_role, form: {
    role: ['buyer', 'seller']
  } do |ids, inputs|
    User.where(id: ids).each do |user|
      user.change_role(inputs[:role])
    end
    redirect_to collection_path, notice: "Successfully changed role for #{ids.count} users"
  end
end 