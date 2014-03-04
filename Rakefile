# -*- ruby -*-

require "rubygems"
require "hoe"
require "rdoc2md"

# Hoe.plugin :compiler
# Hoe.plugin :gem_prelude_sucks
# Hoe.plugin :inline
# Hoe.plugin :minitest
# Hoe.plugin :racc
# Hoe.plugin :rcov
# Hoe.plugin :rubyforge

Hoe.spec "rdoc2md" do
  developer("Kirk Bowers", "kirkbowers@yahoo.com")

  license "MIT" # this should match the license in the README
end

task :readme do
  readme = File.open("README.txt").read
  File.open('README.md', 'w') do |file| 
    file.write(Rdoc2md::Document.new(readme).to_md)
  end
end

task :md2html, [:readme] do
  `Markdown.pl README.md > README.html`
end

# vim: syntax=ruby
