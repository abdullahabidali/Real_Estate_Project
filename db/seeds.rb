# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Create a test user for properties
test_user = User.find_or_create_by!(email: 'test@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.name = 'Test User'
  user.phone = '+92 300 1234567'
  user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
end

# Find or create a default user for the properties
user = User.find_or_create_by!(email: 'sample@example.com') do |u|
  u.password = 'password123'
  u.password_confirmation = 'password123'
  u.name = 'Sample User'
  u.skip_confirmation! if u.respond_to?(:skip_confirmation!)
end

# Clear existing properties
Property.destroy_all

# Properties from different cities in Pakistan
properties = [
  {
    title: "Sea View Apartment in Clifton",
    description: "Modern 3-bedroom apartment with a stunning sea view, located in the heart of Clifton. Includes 24/7 security and parking.",
    price: 35000000,
    address: "Block 5, Clifton",
    city: "Karachi",
    state: "Sindh",
    zip_code: "75600",
    bedrooms: 3,
    bathrooms: 3,
    area: 1800,
    property_type: "apartment",
    status: "available",
    user: user
  },
  {
    title: "Luxury House in DHA Lahore",
    description: "Spacious 5-bedroom house with a lush garden and modern amenities. Located in DHA Phase 6, Lahore.",
    price: 65000000,
    address: "DHA Phase 6, Main Boulevard",
    city: "Lahore",
    state: "Punjab",
    zip_code: "54000",
    bedrooms: 5,
    bathrooms: 5,
    area: 4000,
    property_type: "house",
    status: "available",
    user: user
  },
  {
    title: "Elegant Villa in F-7 Islamabad",
    description: "Elegant villa with 6 bedrooms, a swimming pool, and a large lawn. Prime location in F-7, Islamabad.",
    price: 120000000,
    address: "F-7, Street 22",
    city: "Islamabad",
    state: "Federal Capital",
    zip_code: "44000",
    bedrooms: 6,
    bathrooms: 7,
    area: 7000,
    property_type: "villa",
    status: "available",
    user: user
  },
  {
    title: "Family Home in Hayatabad",
    description: "Comfortable 4-bedroom family home with a garden and car porch. Located in Phase 3, Hayatabad, Peshawar.",
    price: 30000000,
    address: "Phase 3, Hayatabad",
    city: "Peshawar",
    state: "Khyber Pakhtunkhwa",
    zip_code: "25000",
    bedrooms: 4,
    bathrooms: 4,
    area: 2500,
    property_type: "house",
    status: "available",
    user: user
  },
  {
    title: "Commercial Plaza on Jinnah Road",
    description: "Multi-storey commercial plaza ideal for offices and retail, located on Jinnah Road, Quetta.",
    price: 80000000,
    address: "Jinnah Road",
    city: "Quetta",
    state: "Balochistan",
    zip_code: "87300",
    bedrooms: 0,
    bathrooms: 6,
    area: 6000,
    property_type: "commercial",
    status: "available",
    user: user
  }
]

# Create properties
properties.each do |property_attrs|
  property = Property.create!(property_attrs)
  puts "Created property: #{property.title}"
end

puts "Seed data created successfully!"