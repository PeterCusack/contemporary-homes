class ListingsController < ApplicationController

  include ListingsHelper

  def show
    @listing = Listing.find(params[:id])
  end

  def new
    @listing = Listing.new
    @all_listings = Listing.all

  end

  def create
    p params
    @all_listings = Listing.all
    @listing = Listing.new(listing_params)
    @listing.full_address = get_full_address(@listing)
    if @listing.save
      if params['photos'] != nil
        params['photos'].each do |a|
          @photo = @listing.photos.create!(:photo => a, :listing_id => @listing.id)
        end
      end
      # render js: "window.location.pathname='#{new_listing_path}'"
      redirect_to new_listing_path
    else
       # format.html { render action: 'new' }
       # redirect_to new_listing_path @listing
       # render "json": @listing.errors.full_messages
       render 'new'
     end
   end

   def update
    listing = Listing.find(params[:id])
    listing.update_attributes(listing_params)
    if listing.save
      if params['photos'] != nil
        params['photos'].each do |a|
          @photo = listing.photos.create!(:photo => a, :listing_id => listing.id)
        end
      end
    end
    redirect_to new_listing_path
  end

  def edit
    @listing = Listing.find(params[:id])

  end

  def destroy
    listing = Listing.find(params[:id])
    listing.destroy
    redirect_to new_listing_path
  end

  private

  def listing_params
    params.require(:listing).permit(:address, :city, :state, :zipcode, :active, :price)
  end


end
