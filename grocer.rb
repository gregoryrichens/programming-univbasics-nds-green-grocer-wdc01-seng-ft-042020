
def find_item_by_name_in_collection(name, collection = ["0"])
  index = 0
  while index < collection.length do
    if name == collection[index][:item]
      item_hash = collection[index]
    end
  index += 1
  end
  item_hash
end

def consolidate_cart(cart)
  consolidated_cart = []
  cart_index = 0
  while cart_index < cart.length do
    new_hash = cart[cart_index]
    new_hash[:count] = 1   
    puts "consolidated cart pre push #{consolidated_cart}"
    consolidated_cart << new_hash.dup
    consolidated_index = 0
    while consolidated_index < (consolidated_cart.length - 1) do
      if (consolidated_cart.length > 1 && consolidated_cart[consolidated_index][:item] == consolidated_cart.last[:item])
        puts "consolidated index #{consolidated_index}"
        puts "consolidated_cart #{consolidated_cart}"
        puts "cart_index #{cart_index}"
        consolidated_cart[consolidated_index][:count] += 1 
        
        consolidated_cart.pop
        puts "consolidated_cart #{consolidated_cart}"
      end
      consolidated_index += 1
    end 
    puts "consolidated cart end loop #{consolidated_cart}"
    cart_index += 1 
  end
  consolidated_cart
end 

def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  puts "cart #{cart}"
  
  #new array for items after coupon application
  coupon_cart = []
  #new array contains all items in old array
  coupon_cart.concat(cart)
  cart_index = 0 
  #iterate through new array, but keep length of original to disregard any newitems #added (W/coupon items)
  while cart_index < cart.length do
    #item we're looking for e.g. "AVOCADO" 
    item_name = coupon_cart[cart_index][:item]
    coupon_index = 0 
    #iterate through all items in the array of coupons
    while coupon_index < coupons.length do
      #this will be the hash for the coupon discounted items
      new_hash = {}
      #items only qualify for coupon if their name matches the name of a coupon and they have the number of items required by the coupon or greater. This should grab all items in the cart and compare them against all items in coupon array
      if coupons[coupon_index][:item] == item_name && coupon_cart[cart_index][:count] >= coupons[coupon_index][:num] then
        # this is the new name the test requires
        new_hash[:item] = "#{item_name} W/COUPON"
        # coupon hash 'cost' is the total cost of all the items covered by coupon, so divide by number attached to the coupon to get the price per item
        new_hash[:price] = coupons[coupon_index][:cost] / coupons[coupon_index][:num]
        #preserving clearance status from original cart - to be used later
        new_hash[:clearance] = coupon_cart[cart_index][:clearance]
        #number of items in the coupon hash is obviously the number required by coupon
        new_hash[:count] = coupons[coupon_index][:num]
        #subtract the number of items added to the coupon from the number of items in cart
        coupon_cart[cart_index][:count] -= coupons[coupon_index][:num]
        #add the new hash (coupon discounted items) to the shopping cart
        coupon_cart << new_hash
      end
      coupon_index += 1 
    end 
    cart_index += 1
  end
  coupon_cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  cart_index = 0 
  discounted_cart = []
  while cart_index < cart.length do
    if cart[cart_index][:clearance] === true
      discounted_price = cart[cart_index][:price] * 0.8
      cart[cart_index][:price] = discounted_price.round(2)
    end
    discounted_cart << cart[cart_index]
    cart_index += 1 
  end
  discounted_cart
end

def cart_total (cart)
  index = 0
  total = 0
  while index < cart.length do
    item_total = cart[index][:price] * cart[index][:count]
    total += item_total
    index += 1 
  end
  total
end 

def discount_100(total)
    grand_total = total * 0.9
    grand_total.round(2)
end
  
def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  discounted_cart = apply_clearance(coupon_cart)
  pre_total = cart_total(discounted_cart)
  if pre_total > 100.00 
    grand_total = discount_100(pre_total)
  else
    grand_total = pre_total
  end
  grand_total
end
