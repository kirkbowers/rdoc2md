
module Rdoc2md
  VERSION = "0.1.0"
  
  # Rdoc2md::Document takes a String representing a document in Rdoc format (sans leading
  # hashmark comments) and converts it into a similar markdown document.
  #
  # Author:: Kirk Bowers (mailto:kirkbowers@yahoo.com)
  # Copyright:: Copyright (c) 2014 Frabjous Apps LLC
  # License:: MIT License
  class Document
    # The text is the document to be converted from rdoc style to markdown.
    # It should be a String.
    attr_accessor :text
    
    # The initializer takes an optional text, which is the document to be converted from
    # rdoc style to markdown.
    def initialize(text = "")
      @text = text
    end
    
    # Convert the existing document to markdown.  The result is returned as a String.
    def to_md
      # Usually ruby is extremely readable, but I think "-1" means "give me all the 
      # trailing blank lines" is surprisingly opaque.  That's what the -1 does...
      lines = @text.split("\n", -1)
      lines.collect do |line|
        result = line
 
        # Leave lines that start with 4 spaces alone.  These are code blocks and
        # should pass through unchanged.
        unless result =~ /^\s{4,}/
 
          # Convert headers
          result.sub!(/^(=){1,6}/) { |s| "#" * s.length} unless result =~ /^={7,}/
 
          # Convert strong to have two stars
          # The matching pair of stars should start with a single star that is either at
          # the beginning of the line or not following a backslash, have at least one
          # non-star and non-backslash in between, then end in one star
          result.gsub!(/(\A|[^\\\*])\*([^\*]*[^\*\\])\*/, '\1**\2**')

          # Convert inline code spans to use backticks
          result.gsub!(/(\A|[^\\])\+([^\+]*)\+/, '\1`\2`')

          # Convert bare http:, mailto: and ftp: links
          result.gsub!(/(\A|\s)(http:|https:|mailto:|ftp:)(\S*)/, '\1[\2\3](\2\3)')

          # Convert bare www to an http: link
          result.gsub!(/(\A|\s)www\.(\S*)/, '\1[www.\2](http://www.\2)')

          # Convert link: links to refer to local files
          result.gsub!(/(\A|\s)link:(\S*)/, '\1[\2](\2)')

          # Convert multi word labels surrounded by {} with a url
          result.gsub!(/\{([^\}]*)\}\[(\S*)\]/, '[\1](\2)')

          # Convert one word labels with a url
          result.gsub!(/(\A|\s)([^\{\s]\S*)\[(\S*)\]/, '\1[\2](\3)')

        end
        
        result
      end.join("\n")
    end
  end
end
