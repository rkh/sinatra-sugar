Sinatra::Sugar
==============

Basic [Sinatra](http://sinatrarb.com) extension (mainly extending Sinatra's standard methods, like set or register).
Also it features a more advanced path guessing than Sinatra::Base.

Normally you do not have to register this module manually, as the other extensions will do so if necessary.

BigBand
-------

Sinatra::Sugar is part of the [BigBand](http://github.com/rkh/big_band) stack.
Check it out if you are looking for other fancy Sinatra extensions.

Installation
------------

    gem install sinatra-sugar --prerelease

More advanced set
-----------------

- Adds set\_#{key} and set_value hooks to set.
- Merges the old value with the new one, if both are hashes:

        set :haml, :format => :html5, :escape_html => true
        set :haml, :excape_html => false
        haml # => { :format => :html5, :escape_html => false }
    
- Allows passing a block in Sinatra 0.9, too:

        set(:foo) { Time.now }

More advanced register
----------------------

If an extension is registered twice, the registered hook will only be called once.

Ability to extend command line options
--------------------------------------

Example:

    require "sinatra/base"
    require "sinatra/sugar"
    
    class App < Sinatra::Base
      register Sinatra::Sugar
      run_option_parser.on("-i") { puts "yes, -i is a nice option" }
      run! if $0 == __FILE__
    end