# Reloj
A lightweight web frameowrk for Ruby for creating database-backed web applications according to the Model-View-Controller pattern.

## Getting Started

1. Install Reloj at the command prompt if you haven't yet:

        gem install reloj

2. At the command prompt, create a new Reloj application:

        reloj new myapp

   where "myapp" is the application name.

3. Change directory to `myapp` and start the web server:

        cd myapp
        reloj server


4. Using a browser, go to `http://localhost:3000` and you'll see:
"Welcome to Reloj!"

## Models and ORM
Reloj the active record pattern for its object-relational mapping.
To use this functionality in your app, create a class for your model in `app/models` and have the model inherit from ModelBase
```ruby
class Cat < ModelBase
	# custom code goes here
	
	finalize!
end
```
Some commands:

```ruby
Cat.all # returns an array with instances of class Cat, one instance for each row in table cats
```
```ruby
Cat.find(2) # finds the record in table cats with id 2, returns instance of Cat corresponding to that record
```

## Controllers
```ruby
class MyController < ControllerBase
```

## Routes
Write your routes in `config/routes.rb`

```ruby
module App
  ROUTES = Proc.new do
    get '/cats', CatsController, :index
    get '/cats/new', CatsController, :new
    post '/cats', CatsController, :create
  end
end
```

## Running the sample app
Reloj includes a generator for a sample app. To check it out:
1. Generate the sample app
	
	reloj generate:sample
	
2. Move into the sample app directory
	
	cd reloj_sample
	
3. Run the server

	reloj server
	
4. Navigate to localhost:3000