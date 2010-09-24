require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations' 
require 'dm-timestamps'
require 'haml'
require 'sass'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/knowsy-admin.sqlite3")

class Sponsor
  include DataMapper::Resource

  property :id,             Serial   
  property :company_name,   Text,    :required => true
  property :first_name,     Text,    :required => true
  property :last_name,      Text,    :required => true
  property :email,          Text,    :required => true
  property :phone,          Text
  property :created_at,     DateTime
  property :created_at,     DateTime
  property :updated_at,     DateTime

end

DataMapper.auto_upgrade!

get '/' do
  @title = "Dashboard"
  haml :index
end

#LIST

get '/sponsors' do
  @sponsors = Sponsor.all
  @title = "Sponsors"
  @subtitle = "List all"
  haml :list
end

#NEW

get '/sponsor/new' do
  @title = "Sponsors"
  @subtitle = "Create new sponsor"
  haml :new
end

post '/sponsor/new' do
  @sponsor = Sponsor.new( :company_name => params[:company_name],
                          :first_name => params[:first_name],
                          :last_name => params[:last_name],
                          :email => params[:email],
                          :phone => params[:phone]
                        ) 
  if @sponsor.save
    @message = "Succesfully saved new sponsor"
    redirect "/sponsor/show/#{@sponsor.id}"
  else
    redirect "/sponsor/new"
  end
end

#SHOW

get '/sponsor/show/:id' do
  @sponsor = Sponsor.get(params[:id])
  @title = "Sponsors"
  @subtitle = "#{@sponsor.company_name}"
  haml :show
end

#EDIT

get '/sponsor/edit/:id' do  
  @sponsor = Sponsor.get(params[:id])
  @title = "Sponsors"
  @subtitle = "#{@sponsor.company_name}"
  haml :edit
end

post '/sponsor/edit/:id' do 
  @sponsor = Sponsor.get(params[:id])
  @sponsor.company_name = params[:company_name]
  @sponsor.first_name = params[:first_name]
  @sponsor.last_name = params[:last_name]
  @sponsor.email = params[:email]
  @sponsor.phone = params[:phone]
  if @sponsor.save
      @message = "Succesfully saved new sponsor"
      redirect "/sponsor/show/#{@sponsor.id}"
  else
    redirect "/sponsor/edit/#{@sponsor.id}"
  end
end

#DELETE

get '/sponsor/delete/:id' do
  @sponsor = Sponsor.get(params[:id])
  if @sponsor.destroy!
    redirect "/sponsors"
  else
    redirect "/sponsor/show/{#{@sponsor.id}}"
  end
end

#STYLES

get '/global.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :global
end