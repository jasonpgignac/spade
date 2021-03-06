`===========================================================================
 Project:   Spade - CommonJS Microkernel
 Copyright: ©2011 Strobe Inc.
 ===========================================================================`

Spade makes it easy to share and run JavaScript in both the browser and on the
command line.

# Setup

Please note that, as of now, Spade depends on your rubygem to be version 1.7.2.
You can install rubygems 1.7.2 with the following command:
    gem update --system 1.7.2

The following commands will get you started on spade with an initial set of
packages:

    git clone git://github.com/strobecorp/spade.git
    cd spade
    git submodule update --init
    bundle

You should now be able to run the demos in the examples folder.  Be sure to 
check out any README files in the example folders for instructions there.

Run the test suite:

    rake

Run an individual test:

    bundle exec rspec spec/login_spec.rb

To install the gem for global use of the spade command:

    gem build spade.gemspec
    gem install spade-0.0.1.gem

# Quick Start Guide

## From the Command Line

Let's write a simple script.  Create a new file called 'main.js' and put in 
the following:

    console.log('Hello World');

Now run this from the command line:

    spade main.js

Now we want to run this in the browser.  To run in the browser, you need to 
make a JavaScript _package_.  A package is simply a folder containing your 
JavaScript structured in a way that the module system can understand.  All
shared libraries that you load are also packages.

## From the Browser

To make the hello-world app package, create a folder called 'hello-world'.  
Inside of that, create a folder called 'lib' and put your main.js in there.
You should also create index.html and package.json files.  The folder 
structure should look like this:

    /hello-world
      index.html
      package.json
      /lib
        main.js <-- your previous main.js file

Your index.html should contain the following:

    <html>
      <head>
        <script src="spade-boot.js" data-require="hello-world"></script>
      </head>
      <body>
      </body>
    </html>

This index.html file will simply load a boot script that we are about to 
generate.

The package.json should list at minimum the app name and dependencies:

    {
      "name": "hello-world"
    }

Next, we need to setup this package so it includes any dependencies.  To do 
this, use the `spade update` command:

    spade update

This will create a new, hidden '.spade' directory with info along with a new
file called spade-boot.js.  This contains the bootstrap needed to get your 
modules loading in the browser.

Finally, to load in the browser, you will need to access your files through a server.  You could use Apache or Rails, but spade comes with a built-in preview as well (which currently is just a static file server).  Start the 
preview server with:

    spade preview

Then visit http://localhost:4020/index.html

If you open the JavaScript console you should see `Hello World` printed out.

Note that you can still run main.js from the command line:

    spade lib/main.js

## From the Console

Now that you have a package setup you can also easily use the interactive
console that comes with spade.  When you drop into the console you can load
modules from your project onto the command line.

    spade console

From within the console, load your main hello-world module to see it log:

    require('hello-world/main');

You should see it log 'Hello World'.

# Defining Packages

In addition to creating packages as apps, as we did above.  You can also 
define shared package libraries.

TODO: Finish this...

## Ruby Modules

Drop a ruby file into a package and then you can require it.  The Ruby should
set the Spade.exports to a new instance of a class to make it into the exports
for the class.

Note that Ruby modules only work when code is run from the command line.

## Distributing your packages

Distributing your spade packages is easy, first:

    spade login

Once you've bundled your package...

    spade push pkg/awesome-0.0.0.spade

Then it should be available for install with:

    spade install awesome
