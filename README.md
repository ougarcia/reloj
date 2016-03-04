# Reloj
A lightweight web framework for creating database-backed web applications with the Model-View-Controller pattern. It features an active record pattern ORM, convenient methods for cookie storage for things like session tokens, convenient command line interface to speed up development (like `reloj new name_of_app`), and is designed to be easy to deploy. Check out a [live app built with reloj and deployed on heroku](https://reloj-todo.herokuapp.com/)

## Getting Started

1. Install Reloj at the command prompt if you haven't yet:

        gem install reloj

2. At the command prompt, create a new Reloj application:

        reloj new myapp

   where "myapp" is the application name.
   
3. Create a controller, a route, and a view (see below)

4. Change directory to `myapp` and start the web server:

        cd myapp
        reloj server


5. Using a browser, navigate to `http://localhost:3000` and to see what you created.

## Setting up the database

Reloj has some built in convenience features to make it easy to set up your database

To name your database, change the dbname value in `config/db.yml`. If you need to setup any other values for your local database (username, password, port), you can put them in the same file.

To create a database for your app to use, just run:  

		bundle exec rake db:create
		
To destroy the database, run:

		bundle exec rake db:delete
		
To reset the database, run:

		bundle exec rake db:reset
		
Finally, to setup your schema and seed your database, use the `db/setup.sql` file. To run this file on the app's databasae, run:

		bundle exec rake db:setup
		
To learn how to manage the database when deploying, scroll down to the Deploy secction

## Models and ORM
Reloj uses the active record pattern for its object-relational mapping.
To use this functionality in your app, create a class for your model in `app/models` and have the model inherit from ModelBase  

```ruby
class Cat < ModelBase
	# custom code goes here
	
	finalize!
end
```
###Some commands:

```ruby
Cat.all
```
* Returns an array with instances of class Cat, one instance for each row in table cats

```ruby
Cat.find(2)
```
* Finds the record in table cats with id 2, returns instance of Cat corresponding to that record

## Controllers
Create controllers in `app/controllers`. Controllers should inherit from `ControllerBase`.

```ruby
class CatsController < ControllerBase

	def index
		@cats = Cat.all
		render :index
	end
	
end
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
3. run `bundle install`
4. Set up the database

		bundle exec rake db:create
		bundle exec rake db:setup

4. Run the server

		reloj server

5. Navigate to localhost:3000


## Deploying
Reloj is built to make deploying to heroku as easy as possible, here's how:

1. Make sure there's a procfile in the project's root directory. The Procfile should contain the following line:

		web: bundle exec reloj server

		
2. Commit your changes to git

		git commit -am "procfile"
		
3. Create a new heroku app using the heroku cli

		heroku apps:create mynewapp
		
4. Push your code to heroku (heroku apps:create should automatically add a remote repo to push to)

		git push heroku master
		
5. Wait for the push to finish, then create your database tables and seed it as defined in `db/setup.sql`

		heroku run rake db:setup
		
6. Wait for the rake task to finish, then open your app:

		heroku open
		
Enjoy your now-deployed app!

## TODO
* WEBrick doesn't support PATCH/DELETE. I need to either use a different http server or add that funcitonality to WEBrick.
* Right now it doesn't serve assets. I think I can get it that work using servlet.
* REFERENCE: [http://ruby-doc.org/stdlib-1.9.3/libdoc/webrick/rdoc/WEBrick.html#module-WEBrick-label-Servlets](http://ruby-doc.org/stdlib-1.9.3/libdoc/webrick/rdoc/WEBrick.html#module-WEBrick-label-Servlets)

