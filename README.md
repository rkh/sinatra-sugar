Sinatra::Sugar
==============

Basic [Sinatra](http://sinatrarb.com) extension (mainly extending Sinatra's standard methods, like set or register).
Also it features a more advanced path guessing than Sinatra::Base.

Normally you do not have to register this module manually, as the other extensions will do so if necessary.

BigBand
-------

Sinatra::Sugar is part of the [BigBand](http://github.com/rkh/big_band) stack.
Check it out if you are looking for other fancy Sinatra extensions.

More advanced set
-----------------

- Adds set\_#{key} and set_value hooks to set.
- Merges the old value with the new one, if both are hashes:

    set :haml, :format => :html5, :escape_html => true
    set :haml, :excape_html => false
    haml # => { :format => :html5, :escape_html => false }
    
- Allowes passing a block:

    set(:foo) { Time.now }
    
- Defines a helper to access #{key} and #{key}? unless a helper/method with that name already exists.

More advanced register
----------------------

If an exntesion is registered twice, the registered hook will only be called once.

Ability to extend command line options
--------------------------------------

Example:

  require "sinatra"
  require "sinatra/sugar"
  
  configure do
    run_option_parser.on("-i") { puts "yes, -i is a nice option" }
  end