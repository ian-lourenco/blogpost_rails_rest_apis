### Introduction
You've likely seen this old and famous [demo presentation](https://www.youtube.com/watch?v=Gzj723LkRJY) on how powerful and easy it is to build an app with Ruby on Rails. As the demo shows, it took only 15 minutes to create a blog.

But what if I told you that Rails could also be used to quickly and easily create an API, using all available tools that the framework provides, the same security, the same generators, and most of all, the same agility and easy-to-understand language?

Today we'll dive into Rails API mode and how it can be used to create powerful - yet simple - APIs for your back-end!

### What is an API?
First of all, what _is an API?_ Chances are that you've seen two definitions, so let us get this out of the way. API stands for _Application Programming Interface_ and is mostly used to describe accessible documentation of a framework, programming language, or service so a developer can learn, check or revisit any aspect of these tools, as an example we have the [GitHub API](https://docs.github.com/)(also referred and the GitHub Docs) or the [Rails API](https://api.rubyonrails.org/)(once again, also referred as the Rails Docs).

Although we can understand API as thorough documentation of a tool, we can also find public and private APIs that are applications that consume static resources via other applications or HTTP client calls. It is a way for one system to interact with other external systems, which means that there are applications out there that we access differently from the "common way" of interacting with a system with generated HTML that we click and bop, these APIs are usually accessed using direct HTTP calls, usually consuming a JSON resource.

To summarize, instead of generating a page to be interacted with through forms, links, and views, the application can be communicated with exposed endpoints that provide information in a set static structure.

1. **Documentation**: Reference materials for frameworks or services (like the [GitHub API](https://docs.github.com/) or [Rails API](https://api.rubyonrails.org/))
2. **Web Services**: Applications that provide structured data (typically JSON) through HTTP endpoints

### Why RoR for APIs?
Rails was created following the [Model-View-Controller (MVC)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) principles and it can be used to build both the front-end and back-end of a system. Following this MVC architecture, we can use Rails to have its views served as JSON resources, you'll develop focused on your models and controllers and serve the needed information to the outside world in a static pre-constructed structure. So, there is no need to be in charge of creating a front-end or complex views: you'll only need to organize the structure that will be served and the application that will consume what you provide will do as it pleases with the JSON you created.

This means you can keep the happy coding you already have for creating full-stack RoR applications while creating APIs, focusing mainly on controllers and models. Although there are simpler frameworks to create APIs using Ruby, RoR is a full-stack framework with a bunch of tools. Wouldn't it be better to use something else? Well, _it depends_, as mentioned in the [Rails Guides](https://guides.rubyonrails.org/api_app.html#why-use-rails-for-json-apis-questionmark):

>The first question a lot of people have when thinking about building a JSON API using Rails is: "Isn't using Rails to spit out some JSON overkill? Shouldn't I just use something like Sinatra?".
>
>For very simple APIs, this may be true. However, even in very HTML-heavy applications, most of an application's logic lives outside of the view layer.
>
>The reason most people use Rails is that it provides a set of defaults that allows developers to get up and running quickly, without having to make a lot of trivial decisions.
>
><cite>Rails Guides, Why Use Rails for JSON APIs?</cite>

Given these reasons, there is another major point: _**Active Record**_, Rails' built-in Object-Relational Mapping (ORM) layer. In a nutshell, Active Record simplifies database interactions by allowing you to work with database records as Ruby objects. Additionally, it gives us intuitive query methods, associations, validations, and callbacks—all working together to create an abstraction that Rails developers can easily use (it basically gives you superpowers). This means that, when building an API with Rails/Active Record, you can focus on creating efficient data structures without the need for verbose SQL or boilerplate logic. Features like eager loading, transactions, and migrations are all included by default or via semantic methods that are easy to access and use. This also means that the convention-over-configuration approach keeps all data consistent and maintainable, even in Rails API mode!

There you go, there is indeed an argument to be made about its usage, but we want all these **middleware defaults** including _development_ and _testing modes_, _rails logging_, _security_ against different kinds of attacks, and _parameters parsing_. We also want the **action pack layer** that includes _resourceful routing_, _generators_, _ORM_, _caching_, and access to all _rails gems_. You'll find the full list of features [here](https://guides.rubyonrails.org/api_app.html#why-use-rails-for-json-apis-questionmark)

Even though it all seems _too much_, a simple way of thinking is "Why _NOT_?", you already know the **_Rails Way™_** and it can be extended to this new way of building, making it a new tool in your developer toolbox.

> The short version is: that you may not have thought about which
> parts of Rails are still applicable even if you remove the
> view layer, but the answer turns out to be most of it.
&gt;
&gt;<cite>Rails Guides, Why Use Rails for JSON APIs?</cite>

### Differences between RoR and RoR --api
There are three main differences between creating a common RoR app and a RoR app on API mode, as described in the Rails Guides:

* **API mode has a limited set of middleware:** Browser-specific components removed
* **ApplicationController** inherits from **ActionController::API** instead of **ActionController::Base**
* **Generators are configured to skip views, helpers, and assets** when generating a new resource.

The middleware is now _leaner_, removing unnecessary features for API, like cookie support and so forth.

[ActionController::API](https://api.rubyonrails.org/classes/ActionController/API.html) is a lightweight version of [ActionController::Base](https://api.rubyonrails.org/classes/ActionController/Base.html), it allows us to create controllers with just the features an API needs, no overly "fancy" functionalities used in a normal Rails controller. In a nutshell, it does not have features that a browser requires, like layouts and template rendering, flash, assets, and cookies, but of course, you have the freedom to add them as needed.

```rb
# Maybe you want cookies? Be free, cookie monster!
# config/application.rb  
config.middleware.use ActionDispatch::Cookies  
```

Here is a quick summary of these Middleware Stack changes for us visual learners:

| **Middleware**           | **Standard Mode** | **API Mode** | **Notes** |
|--------------------------|------------------|--------------|-----------|
| `ActionDispatch::Cookies` | ✅ Included      | ❌ Excluded   | Disabled by default (can be manually added) |
| `ActionDispatch::Flash`   | ✅ Included      | ❌ Excluded   | Not needed for APIs |
| `ActionDispatch::Session` | ✅ Included      | ❌ Excluded   | Sessions are disabled |
| `Rack::MethodOverride`    | ✅ Included      | ❌ Excluded   | Used for `PATCH`/`PUT` in forms |
| `ActionDispatch::Static`  | ✅ Included      | ❌ Excluded   | No asset serving |

Now, about **rendering and redirecting.**

When rendering or redirecting there is a couple of things to keep in mind, we can freely choose to render, as an example using `render json: 'resource'`, but remember that since there are no templates, no implicit rendering will be made, so it is _necessary_ to either call `render` or `redirect_to`. Of course, this applies to _vanilla_ rails without a gem to build JSON as we please, but let's first get the basics.

Either way, we have some options on how to handle the end of action. For rendering, we can form a structure similar to how we see them in regular rails, just explicitly told what to do afterward.

```rb
def show
  @order = Order.find(params[:id]) # Normally we would stop here
  render json: @order # Added a render option with a variable
end
```
There are, of course, more options than just JSON, but that's what you will usually deal with. However, in case you are curious...
```rb
# A whole round of rendering for render lovers
render json: @order                    # JSON response
render xml: @order                     # XML response  
render plain: "Success"                # Plain text
render status: :no_content             # Header-only response
```
When talking about redirect, in API mode `redirects` are used to move from one action to another, so you can use them almost the same way as it is present in ActionController::Base, e.g:
```rb
def show
  redirect_to create_order_url and return if order_not_created?
  
  # ... rest of the action
end
```

**The key differences then are:**
* There is no implicit rendering! (Kind of)
  * Won't automagically look for *app/views/controller/action.html.erb*
  * Unless.. You use the JBuilder gem, which we will!
* Status code matters a bit more since as an API this info is usually needed
  * ```rb
      redirect_to url, status: :see_other           # 303
      redirect_to url, status: :moved_permanently   # 301
    ```

Lastly, before our practice, let's see some file and folder differences when creating a normal and an API RoR project. When creating an API you'll notice right away that it contains fewer folders.

Here we can see a list of files that the API mode removes on creation:
```bash
  remove  app/assets
  remove  app/helpers
  remove  test/helpers
  remove  app/views/layouts/application.html.erb
  remove  app/views/pwa
  remove  public/400.html
  remove  public/404.html
  remove  public/406-unsupported-browser.html
  remove  public/422.html
  remove  public/500.html
  remove  public/icon.png
  remove  public/icon.svg
  remove  config/initializers/assets.rb
  remove  app/assets/stylesheets/application.css
  remove  config/initializers/content_security_policy.rb
  remove  config/initializers/new_framework_defaults_8_0.rb

  # This means:
    # No asset pipelines (app/assets)
    # No view helpers (app/helpers)
    # No browser error pages (public/4xx.html)
    # No layout templates
```
We can also see these notable differences in the `app` folder
```bash
### Non API mode
app/
├── assets/
├── controllers/
├── helpers/
├── javascript/
├── jobs/
├── mailers/
├── models/
└── views/

#### API mode
app/
├── controllers/
├── jobs/
├── mailers/
├── models/
└── views/
```
As I said before, _leaner_, right?

### RoR API Mode
Let's put our new tool knowledge into practice then! What better way to learn? We'll create a simple app to gather information about our beloved miners, let's call it "PocketMiner42"

First, we create the rails app using the `new` command and passing the `--api` flag to it
```bash
 $ rails new pocket_miner_42 --api
```
To create a new resource, we do the same as always: we'll create a Miner with name, level, and Rare Gems that belong to said Miner, with name and color.
```bash
 $ rails generate scaffold Miner name:string level:integer
 $ rails generate scaffold RareGem name:string color:string miner:references
```
Remember that you'll need to migrate and update the schema.

```bash
 $ rails db:migrate
```
If we open their controllers, we'll notice we are rendering a JSON for each REST action.

```rb
class MinersController < ApplicationController
  before_action :set_miner, only: %i[ show update destroy ]

  # GET /miners
  def index
    @miners = Miner.all

    render json: @miners
  end

  # GET /miners/1
  def show
    render json: @miner
  end

  # POST /miners
  def create
    @miner = Miner.new(miner_params)

    if @miner.save
      render json: @miner, status: :created, location: @miner
    else
      render json: @miner.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /miners/1
  def update
    if @miner.update(miner_params)
      render json: @miner
    else
      render json: @miner.errors, status: :unprocessable_entity
    end
  end

  # DELETE /miners/1
  def destroy
    @miner.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_miner
      @miner = Miner.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def miner_params
      params.expect(miner: [ :name, :level ])
    end
end

class RareGemsController < ApplicationController
  before_action :set_rare_gem, only: %i[ show update destroy ]

  # GET /rare_gems
  def index
    @rare_gems = RareGem.all

    render json: @rare_gems
  end

  # GET /rare_gems/1
  def show
    render json: @rare_gem
  end

  # POST /rare_gems
  def create
    @rare_gem = RareGem.new(rare_gem_params)

    if @rare_gem.save
      render json: @rare_gem, status: :created, location: @rare_gem
    else
      render json: @rare_gem.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rare_gems/1
  def update
    if @rare_gem.update(rare_gem_params)
      render json: @rare_gem
    else
      render json: @rare_gem.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rare_gems/1
  def destroy
    @rare_gem.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rare_gem
      @rare_gem = RareGem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def rare_gem_params
      params.expect(rare_gem: [ :name, :color, :miner_id ])
    end
end
```
With this, we have a functioning REST API, _Easy as Sunday morning_.

We can do as we please, maybe create a service object to input some decision on how the Miners get their Rare Gems and create transactions and contracts for a stronger business/miner logic, just as you would in a normal rails app. The backend will work the same, the main difference here is how the data is passed to the end user.

### JSON, Serializing and JBuilder
Given we will mainly use JSON, what does it look like on a typical GET call on the API endpoint? After creating some Miners and Gems we have:
```
[
	{
		"id": 1,
		"name": "Mineirinho",
		"level": 99,
		"created_at": "2025-06-05T13:19:30.482Z",
		"updated_at": "2025-06-05T13:19:30.482Z"
	},
	{
		"id": 2,
		"name": "Marvin",
		"level": 77,
		"created_at": "2025-06-05T13:19:41.634Z",
		"updated_at": "2025-06-05T13:19:41.634Z"
	},
	{
		"id": 3,
		"name": "TalyBot",
		"level": 55,
		"created_at": "2025-06-05T13:19:56.373Z",
		"updated_at": "2025-06-05T13:19:56.373Z"
	}
]
```
Pretty cool, all working just fine! But wait... I don't remember setting up this format of return or even the info I want to display. Well... Rails automatically gets the instance variable we created `miners` and serializes the data into an organized JSON with all their information, which is good. But what if we want to display only the names and levels? And what if we wanted to show the rare gems they have? Here we can use [JBuilder](https://github.com/rails/jbuilder) gem to serialize what we want using a comprehensive DSL. It is an official gem maintained by the Rails team!

**When using JBuilder, you DON'T need to explicitly render the JSON, just create the views as you would in a common rails app. So go to your controller and remove the rendering on actions and places where there is a correspondent view!**

As of Rails 8, it should come in your gemfile as a commented line, just uncomment it and do a bundle install.
```rb
# gemfile.rb
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
```
Now we can create the equivalent of our views but in a `.json.jbuilder` format.

```rb
# app/views/miners/index.json.jbuilder
json.miners @miners do |miner|
  json.name miner.name
  json.level miner.level
  json.rare_gems miner.rare_gems do |rare_gem|
    json.name rare_gem.name
    json.color rare_gem.color
  end
end

# app/views/miners/show.json.jbuilder
json.miners @miners do |miner|
  json.name miner.name
  json.level miner.level
  json.rare_gems miner.rare_gems do |rare_gem|
    json.name rare_gem.name
    json.color rare_gem.color
  end
end
```

When making a GET Index call:
```json
{
	"miners": [
		{
			"name": "Mineirinho",
			"level": 99,
			"rare_gems": [
				{
					"name": "Ruby",
					"color": "Red"
				}
			]
		},
		{
			"name": "Marvin",
			"level": 77,
			"rare_gems": [
				{
					"name": "Sapphire",
					"color": "Green"
				}
			]
		},
		{
			"name": "TalyBot",
			"level": 55,
			"rare_gems": [
				{
					"name": "Lapis Lazuli",
					"color": "Blue"
				}
			]
		}
	]
}
```

When making a GET Show call:
```json
{
	"miner": {
		"name": "Mineirinho",
		"level": 99,
		"rare_gems": [
			{
				"name": "Ruby",
				"color": "Red"
			}
		],
		"created_at": "2025-06-05T13:19:30Z",
		"updated_at": "2025-06-05T13:19:30Z"
	}
}
```

In their controller actions:
```rb
# GET /miners
  def index
    @miners = Miner.includes(:rare_gems).all
  end

  # GET /miners/1
  def show
  end
```
See that I included the rare gems on the call? Well, the JSON view will iterate each Miner on @miners and that could cause some serious N+1 Query issues, so always bear that in mind!

### Conclusion: Rails for APIs - A good fit?
Through our small example, we've seen how Rails API mode provides:

* Rapid Development - Scaffolds and generators work just like traditional Rails
* Full Control - JBuilder lets you craft JSON responses as you wish they are
* Production-Ready - All of Rails' security and stability baked in
* Familiar Workflow - The same MVC patterns you already know

The next time you need to build an API, ask yourself: "Would I enjoy rebuilding Rails' features from scratch?" If the answer is no (and it usually is), Rails API mode may probably be a good idea.

___
Photo by <a href="https://unsplash.com/pt-br/@trapnation?utm_content=creditCopyText&amp;utm_medium=referral&amp;utm_source=unsplash">Andre Benz</a> on <a href="https://unsplash.com/pt-br/fotografias/fotografia-de-ferrovia-durante-a-noite-JnB8Gio4GZo?utm_content=creditCopyText&amp;utm_medium=referral&amp;utm_source=unsplash">Unsplash</a>
---

#### Previously: [Web Development with Ruby on Rails](https://blog.codeminer42.com/web-development-with-ruby-on-rails/)

> This post is part of our[ 'The Miners' Guide to Code Crafting'](https://blog.codeminer42.com/category/posts/the-miners-guide-to-code-crafting/) series, designed to help aspiring developers learn and grow. Stay tuned for more and continue your coding journey with us!! Check out the full summary [here](https://blog.codeminer42.com/the-miners-guide-to-crafting-code-gearing-up/#:~:text=Summary%20of%20Posts%3A%20The%20Miners%E2%80%99%20Guide%20to%20Code%20Crafting)!