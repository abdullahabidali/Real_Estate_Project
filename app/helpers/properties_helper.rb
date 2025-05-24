module PropertiesHelper
  def format_price_in_pkr(usd_price)
    # Current exchange rate (1 USD = 278.50 PKR as of May 2024)
    # You might want to fetch this from an API in a production environment
    exchange_rate = 278.50
    pkr_price = usd_price * exchange_rate
    number_to_currency(pkr_price, unit: "Rs. ", precision: 0, delimiter: ",")
  end
end
