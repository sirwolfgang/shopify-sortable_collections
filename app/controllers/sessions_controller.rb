class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    shop = Shop.find_by_omniauth(auth)
    shop = Shop.create_with_omniauth(auth) if shop.nil?
    session[:shop_id] = shop.id
    redirect_to '/', :notice => "Signed in!"
  end
  
  def destroy
    session[:shop_id] = nil
    redirect_to '/', :notice => "Signed out!"
  end
end