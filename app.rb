require 'sinatra'
require 'sinatra/activerecord'
require 'geocoder'
require "geocoder/railtie"
require "haml"
Geocoder::Railtie.insert

SITE_TITLE = "SaveMyFavs"
SITE_DESCRIPTION = "Save Your Favorite Locations"

configure :development do
  set :database, 'sqlite:///app.db'
end

class Location < ActiveRecord::Base
  attr_accessible :address, :name, :latitude, :longitude
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
end

get '/' do
  @locations = Location.all
  @title = 'All locations'
  haml :index
end

post '/' do
  n = Location.new
  n.name = params[:name]
  n.address = params[:address]
  n.save
  redirect '/'
end

get '/:id' do
  @location = Location.find(params[:id])
  @title = "Edit location ##{params[:id]}"
  haml :edit
end

put '/:id' do
  n = Location.find(params[:id])
  if params[:name] != "" || params[:name] != nil
    n.name = params[:name]
  end

  if params[:address] != "" || params[:address] != nil
    n.address = params[:address]
  end
  n.save
  redirect '/'
end

get '/:id/delete' do
  @location = Location.find(params[:id])
  @title = "Confirm deletion of location ##{params[:id]}"
  haml :delete
end

delete '/:id' do
  n = Location.find(params[:id])
  n.destroy
  redirect '/'
end