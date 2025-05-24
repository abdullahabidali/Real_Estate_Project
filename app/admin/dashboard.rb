# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  controller do
    skip_authorization_check
  end

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Property Statistics" do
          div class: "blank_slate_container" do
            div class: "blank_slate" do
              h3 "Total Properties: #{Property.count}"
              h4 "Available: #{Property.available.count}"
              h4 "Sold: #{Property.sold.count}"
              h4 "Pending: #{Property.pending.count}"
              h4 "Average Price: $#{Property.average(:price).to_i}"
              h4 "Total Value: $#{Property.sum(:price)}"
            end
          end
        end
      end

      column do
        panel "User Statistics" do
          div class: "blank_slate_container" do
            div class: "blank_slate" do
              h3 "Total Users: #{User.count}"
              h4 "Buyers: #{User.buyers.count}"
              h4 "Sellers: #{User.sellers.count}"
              h4 "Active Users (Last 30 days): #{User.where('last_sign_in_at > ?', 30.days.ago).count}"
              h4 "New Users (Last 30 days): #{User.where('created_at > ?', 30.days.ago).count}"
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Monthly Property Trends" do
          div class: "blank_slate_container" do
            div class: "blank_slate" do
              (0..5).reverse_each do |i|
                month = i.months.ago
                count = Property.where('created_at >= ? AND created_at < ?', month.beginning_of_month, month.end_of_month).count
                h4 "#{month.strftime('%B %Y')}: #{count} properties"
              end
            end
          end
        end
      end

      column do
        panel "Monthly User Growth" do
          div class: "blank_slate_container" do
            div class: "blank_slate" do
              (0..5).reverse_each do |i|
                month = i.months.ago
                count = User.where('created_at >= ? AND created_at < ?', month.beginning_of_month, month.end_of_month).count
                h4 "#{month.strftime('%B %Y')}: #{count} new users"
              end
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Top Performing Properties" do
          table_for Property.joins(:favorites).group('properties.id').order('COUNT(favorites.id) DESC').limit(5) do
            column :title
            column :price
            column "Favorites" do |property|
              property.favorites.count
            end
            column :status
          end
        end
      end

      column do
        panel "Most Active Users" do
          table_for User.joins(:properties).group('users.id').order('COUNT(properties.id) DESC').limit(5) do
            column :name
            column :email
            column "Properties Listed" do |user|
              user.properties.count
            end
            column :role
          end
        end
      end
    end

    columns do
      column do
        panel "Property Types Distribution" do
          div class: "blank_slate_container" do
            div class: "blank_slate" do
              Property.group(:property_type).count.each do |type, count|
                percentage = (count.to_f / Property.count * 100).round(1)
                h4 "#{type.titleize}: #{count} (#{percentage}%)"
              end
            end
          end
        end
      end

      column do
        panel "Price Range Distribution" do
          div class: "blank_slate_container" do
            div class: "blank_slate" do
              ranges = {
                "Under $100k" => 0..100000,
                "$100k - $300k" => 100001..300000,
                "$300k - $500k" => 300001..500000,
                "$500k - $1M" => 500001..1000000,
                "Over $1M" => 1000001..Float::INFINITY
              }
              
              ranges.each do |range_name, range|
                count = Property.where(price: range).count
                percentage = (count.to_f / Property.count * 100).round(1)
                h4 "#{range_name}: #{count} (#{percentage}%)"
              end
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Recent Activity" do
          table_for Message.order(created_at: :desc).limit(5) do
            column :content
            column :property
            column :user
            column :created_at
          end
        end
      end

      column do
        panel "Property Status Changes" do
          table_for Property.where('updated_at > ?', 7.days.ago).order(updated_at: :desc).limit(5) do
            column :title
            column :status
            column :updated_at
          end
        end
      end
    end
  end # content
end
