# Create or find the sample user
user = User.find_or_create_by!(email: 'sample@example.com') do |u|
  u.password = 'password123'
  u.password_confirmation = 'password123'
  u.name = 'Sample User'
  u.phone = '+92 300 1234567'
  u.skip_confirmation! if u.respond_to?(:skip_confirmation!)
end

# Make sure the user is a seller
user.add_role(:seller) unless user.seller?

properties = [
  {
    title: "Luxury Apartment in DHA Karachi",
    description: "Modern 3-bedroom apartment with sea view in DHA Phase 8. Features include marble flooring, modern kitchen, and 24/7 security.",
    price: 45000000,
    address: "DHA Phase 8, Block 4",
    city: "Karachi",
    state: "Sindh",
    zip_code: "75500",
    bedrooms: 3,
    bathrooms: 3,
    area: 2000,
    property_type: "apartment",
    status: "available"
  },
  {
    title: "Spacious Villa in Bahria Town Lahore",
    description: "Elegant 5-bedroom villa with swimming pool and garden. Located in a gated community with modern amenities.",
    price: 85000000,
    address: "Bahria Town, Block 12",
    city: "Lahore",
    state: "Punjab",
    zip_code: "54000",
    bedrooms: 5,
    bathrooms: 6,
    area: 5000,
    property_type: "house",
    status: "available"
  },
  {
    title: "Commercial Plaza in Blue Area",
    description: "Prime commercial property in Islamabad's business district. Perfect for offices and retail spaces.",
    price: 120000000,
    address: "Blue Area, Sector F-7",
    city: "Islamabad",
    state: "Federal Capital",
    zip_code: "44000",
    bedrooms: 0,
    bathrooms: 8,
    area: 8000,
    property_type: "commercial",
    status: "available"
  },
  {
    title: "Family Home in Hayatabad",
    description: "Comfortable 4-bedroom family home with garden in Peshawar's upscale neighborhood.",
    price: 35000000,
    address: "Phase 3, Hayatabad",
    city: "Peshawar",
    state: "Khyber Pakhtunkhwa",
    zip_code: "25000",
    bedrooms: 4,
    bathrooms: 4,
    area: 3000,
    property_type: "house",
    status: "available"
  },
  {
    title: "Modern Apartment in Gulberg",
    description: "Contemporary 2-bedroom apartment in Lahore's prestigious Gulberg area.",
    price: 28000000,
    address: "Gulberg III, Block 5",
    city: "Lahore",
    state: "Punjab",
    zip_code: "54660",
    bedrooms: 2,
    bathrooms: 2,
    area: 1500,
    property_type: "apartment",
    status: "available"
  },
  {
    title: "Luxury Penthouse in Clifton",
    description: "Exclusive penthouse with panoramic sea views in Karachi's most prestigious area.",
    price: 95000000,
    address: "Block 2, Clifton",
    city: "Karachi",
    state: "Sindh",
    zip_code: "75600",
    bedrooms: 4,
    bathrooms: 5,
    area: 4000,
    property_type: "apartment",
    status: "available"
  },
  {
    title: "Commercial Building in Saddar",
    description: "Historic commercial building in Karachi's business district. Ideal for retail or office space.",
    price: 65000000,
    address: "Saddar, Main Road",
    city: "Karachi",
    state: "Sindh",
    zip_code: "74400",
    bedrooms: 0,
    bathrooms: 6,
    area: 4500,
    property_type: "commercial",
    status: "available"
  },
  {
    title: "Family Villa in F-8",
    description: "Spacious 6-bedroom villa with garden in Islamabad's diplomatic enclave.",
    price: 150000000,
    address: "F-8, Street 15",
    city: "Islamabad",
    state: "Federal Capital",
    zip_code: "44000",
    bedrooms: 6,
    bathrooms: 7,
    area: 6000,
    property_type: "house",
    status: "available"
  },
  {
    title: "Modern Office Space in Gulshan",
    description: "Contemporary office space in Karachi's business district. Fully furnished and ready to move in.",
    price: 45000000,
    address: "Gulshan-e-Iqbal, Block 6",
    city: "Karachi",
    state: "Sindh",
    zip_code: "75300",
    bedrooms: 0,
    bathrooms: 4,
    area: 3000,
    property_type: "commercial",
    status: "available"
  },
  {
    title: "Luxury Apartment in DHA Islamabad",
    description: "Premium 3-bedroom apartment in DHA Islamabad. Features include smart home technology and modern amenities.",
    price: 55000000,
    address: "DHA Phase 2, Sector A",
    city: "Islamabad",
    state: "Federal Capital",
    zip_code: "44000",
    bedrooms: 3,
    bathrooms: 3,
    area: 2200,
    property_type: "apartment",
    status: "available"
  }
]

# Clear existing properties
user.properties.destroy_all

# Create new properties
properties.each do |attrs|
  property = user.properties.create!(attrs)
  puts "Created property: #{property.title}"
end 