require 'minitest'
require "shoulda-context"
require "rdoc2md"

class TestRdoc2md < Minitest::Test
  context "When converting non-commented text" do
    should "leave dashed bulleted lists untouched" do
      text = <<EOF
- This is a bulleted list item
- So is this
EOF
      result = Rdoc2md::Document.new(text).to_md
      assert_equal text, result
    end


    should "leave starred bulleted lists untouched" do
      text = <<EOF
* This is a starred list item
* So is this
EOF
      result = Rdoc2md::Document.new(text).to_md
      assert_equal text, result
    end


    should "leave numbered lists untouched" do
      text = <<EOF
1. This is a numbered list item
2. So is this
EOF
      result = Rdoc2md::Document.new(text).to_md
      assert_equal text, result
    end


    should "leave paragraphs untouched" do
      text = <<EOF
This is a paragraph.

This is a second paragraph that
continues on more than one line.
EOF
      result = Rdoc2md::Document.new(text).to_md
      assert_equal text, result
    end


    should "convert equal signs for headings to hashes" do
      text = <<EOF
= Level 1 heading

== Level 2

=== Level 3

==== Level 4

===== Level 5

====== Level 6

======= Not a heading
EOF

      expected = <<EOF
# Level 1 heading

## Level 2

### Level 3

#### Level 4

##### Level 5

###### Level 6

======= Not a heading
EOF
      
      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end

    should "leave emphasized untouched" do
      text = <<EOF
This is _emphasized_ text.
EOF
      result = Rdoc2md::Document.new(text).to_md
      assert_equal text, result
    end

    should "convert strong to have two stars in the middle of the line" do
      text = <<EOF
This is *strong* text.
EOF

      expected = <<EOF
This is **strong** text.
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "convert strong to have two stars at the start of the line" do
      text = <<EOF
*strong* text at the beginning.
EOF

      expected = <<EOF
**strong** text at the beginning.
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "leave double stars untouched" do
      text = <<EOF
This is **double starred** text.
EOF
      result = Rdoc2md::Document.new(text).to_md
      assert_equal text, result
    end


    should "leave backslashed stars untouched" do
      text = <<EOF
This is \\*escaped starred* text.
EOF
      result = Rdoc2md::Document.new(text).to_md
      assert_equal text, result
    end


    should "convert typewriter to have backticks in the middle of the line" do
      text = <<EOF
This is +code+ text.
EOF

      expected = <<EOF
This is \`code\` text.
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "convert typewriter to have backticks at the start of the line" do
      text = <<EOF
+code+ text at the beginning.
EOF

      expected = <<EOF
`code` text at the beginning.
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "leave backslashed typewriter untouched" do
      text = <<EOF
This is \\+escaped code+ text.
EOF
      result = Rdoc2md::Document.new(text).to_md
      assert_equal text, result
    end


    should "convert typewriter and allow backslashes inside code span" do
      text = <<EOF
+code\\+ containing a backslash.
EOF

      expected = <<EOF
`code\\` containing a backslash.
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "leave backslashed typewriter untouched when describing C++" do
      text = <<EOF
This is C++
EOF
      result = Rdoc2md::Document.new(text).to_md
      assert_equal text, result
    end


    should "convert bare http reference to square bracketed with url as label" do
      text = <<EOF
Ruby : http://www.ruby-lang.org
EOF

      expected = <<EOF
Ruby : [http://www.ruby-lang.org](http://www.ruby-lang.org)
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "convert bare http reference at beginning of line" do
      text = <<EOF
http://www.ruby-lang.org is the url to follow
EOF

      expected = <<EOF
[http://www.ruby-lang.org](http://www.ruby-lang.org) is the url to follow
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "convert bare https reference to square bracketed with url as label" do
      text = <<EOF
https://github.com/kirkbowers/rdoc2md
EOF

      expected = <<EOF
[https://github.com/kirkbowers/rdoc2md](https://github.com/kirkbowers/rdoc2md)
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "convert bare mailto reference to square bracketed with url as label" do
      text = <<EOF
Email me at mailto:someone@example.com
EOF

      expected = <<EOF
Email me at [mailto:someone@example.com](mailto:someone@example.com)
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "convert bare ftp reference to square bracketed with url as label" do
      text = <<EOF
Download at ftp://phonyurl.com today!
EOF

      expected = <<EOF
Download at [ftp://phonyurl.com](ftp://phonyurl.com) today!
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "convert www reference to square bracketed with url as label and http protocol" do
      text = <<EOF
Get more details at www.ruby-lang.org
EOF

      expected = <<EOF
Get more details at [www.ruby-lang.org](http://www.ruby-lang.org)
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "convert link: reference to square bracketed with local link as label" do
      text = <<EOF
Check the link:faq.html file for more info.
EOF

      expected = <<EOF
Check the [faq.html](faq.html) file for more info.
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "convert label[url] references where label is one word" do
      text = <<EOF
Visit the Ruby[http://www.ruby-lang.com] site.
EOF

      expected = <<EOF
Visit the [Ruby](http://www.ruby-lang.com) site.
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


    should "convert {label}[url] references where label can be multiple words" do
      text = <<EOF
Visit the {Ruby website}[http://www.ruby-lang.com]
EOF

      expected = <<EOF
Visit the [Ruby website](http://www.ruby-lang.com)
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end

    should "convert {label}[url] references on beginning of the line" do
      text = <<EOF
{Visit the Ruby website}[http://www.ruby-lang.com]
EOF

      expected = <<EOF
[Visit the Ruby website](http://www.ruby-lang.com)
EOF

      result = Rdoc2md::Document.new(text).to_md
      assert_equal expected, result
    end


  end
end
