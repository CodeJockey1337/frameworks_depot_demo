module CurrentCart
    extend ActiveRecord::Concern
    
    private
    
    def set_cart
        #Grab the current cart for the session, and set it to the Object instance cart
        @cart = Cart.find(session[:cart_id])
    # If a cart is not found, create one and set it to the session cart
    rescue ActiveRecord::RecordNotFound
        @cart = Cart.create
        #This line returns the current cart - session[:cart_id] is a call to a hash
        session[:cart_id] = @cart.id
    end
end