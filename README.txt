= rdoc2md

https://github.com/kirkbowers/rdoc2md

== Description

+rdoc2md+ is a utility for converting Rdoc style documents into markdown.  The primary
motivation is to make a Hoe gem project more github friendly.  Hoe depends on a README.txt
file in Rdoc format.  Github expects a README.md file to display nicely on the webpage.
This utility lets you make the .txt file the master and autogenerate the .md version
without Repeating Yourself.

Incidentally, if you are reading this on github, this README was produced by +rdoc2md+.
Kinda meta, eh?

<a href="https://www.omniref.com/ruby/gems/rdoc2md"><img src="https://www.omniref.com/ruby/gems/rdoc2md.png" alt="rdoc2md API Documentation" /></a>

== Usage

To use +rdoc2md+, first install it:

    [sudo] gem install rdoc2md
    
Most likely you will want to run it on the command line, like so:

    rdoc2md README.txt > README.md
    
You can use it inside of a Ruby program by passing a +String+ to the initializer of the 
+Rdoc2md::Document+ object and calling +to_md+:

    require 'rdoc2md'

    result = Rdoc2md::Document.new(text).to_md
    
I tried for the life of me to make it work as a Hoe plugin, but no luck.  That may be a
future feature.  In the meantime, add +require 'rdoc2md'+ near the top of your
+Rakefile+ and add this near the bottom:

    task :readme do
      readme = File.open("README.txt").read
      File.open('README.md', 'w') do |file| 
        file.write(Rdoc2md::Document.new(readme).to_md)
      end
    end

This will allow you to run +rake readme+ before you commit to github and generate a
markdown version of your README.

== Dependencies

+rdoc2md+ does not depend on any other gem in order to run.

It does, however, depend on by hoe[https://github.com/seattlerb/hoe] and
shoulda[https://github.com/thoughtbot/shoulda] for development and testing.

== Developers/Contributing

After checking out the source, run:

    rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

This first pass is very ad-hoc.  I make no claims that it exhaustively covers all 
situations where Rdoc could be converted to an equivalent markdown notation.  If you 
find a shortcoming, by all means, feel free to upgrade it.  I welcome all contributions.

I do prefer that such shortcomings be documented first in the Issues.  I may be working on a fix already.  No sense in two people fixing the same thing....

== License

+rdoc2md+ is released under the MIT license.  
