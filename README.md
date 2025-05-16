# Real Estate Marketplace

A web application for buying, selling, and renting properties built with Ruby on Rails.

## What This App Does

- **Browse Properties**: View houses, apartments, condos, and other real estate listings
- **User Accounts**: Create an account, log in with email or through Google/GitHub
- **Property Management**: Add, edit, and remove property listings with photos
- **Search Features**: Find properties by location, price, bedrooms, and other filters
- **Favorites**: Save properties you like to view later
- **Messaging**: Contact property owners with questions

## Setup Guide

### What You Need First

- Ruby 3.3.0 or newer
- PostgreSQL database
- Node.js and Yarn

### Setting Up

1. Clone this repository
2. Install Ruby gems:
   ```
   bundle install
   ```
3. Set up the database:
   ```
   rails db:create
   rails db:migrate
   ```
4. Start the server:
   ```
   rails server
   ```
5. Open your browser and go to `http://localhost:3000`

## User Types

- **Regular Users**: Can browse properties, create favorites, and send messages
- **Property Owners**: Can list properties for sale or rent
- **Admins**: Can manage all properties and users

## Features

- **Property Listings**: Detailed property information with multiple photos
- **User Authentication**: Secure login with email or social media accounts
- **Search & Filters**: Find properties that match your exact needs
- **Responsive Design**: Works on computers, tablets, and phones
- **Messaging System**: Connect buyers and sellers directly


