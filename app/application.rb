require 'pry'
class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = ["Apples", "Oranges"]

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end

    elsif req.path.match(/cart/)
      @@cart.each { |cart_item| resp.write "#{cart_item}\n"}

      search_term = req.params["item"]

      if @@cart.include?(search_term)
        resp.write "#{search_term} has been added to cart"
      else
        resp.write "Your cart is empty"
      end 

    elsif req.path.match(/add/)
      # @@item.each { |cart_item| resp.write "#{cart_item}\n"}

      search_term = req.params["item"]

      if @@items.include?(search_term)
        @@cart << search_term
        resp.write "added #{search_term}"
      else
        resp.write "We don't have that item"
      end 

    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)

    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
