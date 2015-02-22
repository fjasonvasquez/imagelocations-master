object @promo_code
attributes :id, :name, :discounted_price
node(:discounted_price, unless: lambda { |promo_code| promo_code.nil? } ) { |promo_code| promo_code.discounted_price }