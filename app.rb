require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations' 
require 'dm-timestamps'
require 'haml'
require 'sass'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/customer-admin.sqlite3")

class Customer
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

get '/customers' do
  @customers = Customer.all
  @title = "Customers"
  @subtitle = "List all"
  haml :list
end

#NEW

get '/customer/new' do
  @title = "Customers"
  @subtitle = "Create new customer"
  haml :new
end

post '/customer/new' do
  @customer = Customer.new( :company_name => params[:company_name],
                          :first_name => params[:first_name],
                          :last_name => params[:last_name],
                          :email => params[:email],
                          :phone => params[:phone]
                        ) 
  if @customer.save
    @message = "Succesfully saved new customer"
    redirect "/customer/show/#{@customer.id}"
  else
    redirect "/customer/new"
  end
end

#SHOW

get '/customer/show/:id' do
  @customer = Customer.get(params[:id])
  @title = "Customers"
  @subtitle = "#{@customer.company_name}"
  haml :show
end

#EDIT

get '/customer/edit/:id' do  
  @customer = Customer.get(params[:id])
  @title = "Customers"
  @subtitle = "#{@customer.company_name}"
  haml :edit
end

post '/customer/edit/:id' do 
  @customer = Customer.get(params[:id])
  @customer.company_name = params[:company_name]
  @customer.first_name = params[:first_name]
  @customer.last_name = params[:last_name]
  @customer.email = params[:email]
  @customer.phone = params[:phone]
  if @customer.save
      @message = "Succesfully edited this customer"
      redirect "/customer/show/#{@customer.id}"
  else
    redirect "/customer/edit/#{@customer.id}"
  end
end

#DELETE

get '/customer/delete/:id' do
  @customer = Customer.get(params[:id])
  if @customer.destroy!
    redirect "/customers"
  else
    redirect "/customer/show/{#{@customer.id}}"
  end
end

#STYLES

get '/global.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :global
end