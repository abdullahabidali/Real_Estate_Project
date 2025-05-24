ActiveAdmin.register Property do
  controller do
    skip_authorization_check
    defaults resource_class: Property
    
    def create
      @property = Property.new(permitted_params[:property])
      
      if @property.save
        if params[:property][:images].present?
          params[:property][:images].each do |image|
            @property.images.attach(image)
          end
        end
        redirect_to admin_property_path(@property), notice: "Property was successfully created."
      else
        render :new
      end
    end
    
    def update
      @property = Property.find(params[:id])
      
      if @property.update(permitted_params[:property].except(:images))
        if params[:property][:images].present?
          params[:property][:images].each do |image|
            @property.images.attach(image)
          end
        end
        redirect_to admin_property_path(@property), notice: "Property was successfully updated."
      else
        render :edit
      end
    end
  end

  actions :all

  permit_params :title, :description, :price, :address, :city, :state, :zip_code, :property_type, :status, :bedrooms, :bathrooms, :area, :user_id, images: []

  index do
    selectable_column
    id_column
    column :title
    column :price
    column :city
    column :state
    column :property_type
    column :status
    column :user
    column :created_at
    actions
  end

  filter :title
  filter :price
  filter :city
  filter :state
  filter :property_type
  filter :status
  filter :user
  filter :created_at

  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :price
      row :address
      row :city
      row :state
      row :zip_code
      row :property_type
      row :status
      row :bedrooms
      row :bathrooms
      row :area
      row :user
      row :created_at
      row :updated_at
      row :images do |property|
        div do
          property.images.each do |image|
            div do
              image_tag url_for(image), style: "max-width: 200px; margin: 10px;"
            end
          end
        end
      end
    end
  end

  member_action :delete_image, method: :delete do
    @image = ActiveStorage::Attachment.find(params[:image_id])
    @property = Property.find(params[:id])
    
    if @image.record == @property
      @image.purge
      redirect_to edit_admin_property_path(@property), notice: "Image was successfully deleted."
    else
      redirect_to edit_admin_property_path(@property), alert: "You are not authorized to delete this image."
    end
  end

  form html: { multipart: true } do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :price
      f.input :address
      f.input :city
      f.input :state
      f.input :zip_code
      f.input :property_type, as: :select, collection: ['house', 'apartment', 'condo', 'townhouse', 'land', 'commercial']
      f.input :status, as: :select, collection: ['available', 'sold', 'pending']
      f.input :bedrooms
      f.input :bathrooms
      f.input :area, min: 1
      f.input :user
      
      # Enhanced multiple image upload with instructions
      f.input :images, as: :file, input_html: { 
        multiple: true, 
        accept: 'image/*',
        direct_upload: true
      }, hint: 'Select multiple images by holding Ctrl (or Cmd on Mac) while clicking. You can also drag and drop multiple files.'
      
      # Display existing images if editing
      if f.object.persisted? && f.object.images.attached?
        div class: 'existing-images' do
          h4 "Existing Images"
          div class: 'image-grid' do
            f.object.images.each do |image|
              div class: 'image-container' do
                image_tag url_for(image), style: "max-width: 150px; margin: 10px;"
                div class: 'image-actions' do
                  a "Delete", href: delete_image_admin_property_path(f.object, image_id: image.id), 
                    data: { confirm: "Are you sure you want to delete this image?" }, 
                    method: :delete, 
                    class: "button small"
                end
              end
            end
          end
        end
      end
    end
    f.actions
  end

  batch_action :destroy, confirm: "Are you sure you want to delete these properties?" do |ids|
    Property.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} properties"
  end
end 