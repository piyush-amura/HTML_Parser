require_relative './tag'
require 'pry'

ch = 0
HTML_FILE = ''

# method to format tag after extraction
#
#
# @return [<String>] formatted tag
#
def format_tag(tag)
  t = tag.to_s
  t = t[0..-2] if t[-1] == ' '
  t[t.length] = '>'
  t
end

# method for finding the children of a tag object
#
#
# @return [<Tag object>] object of tag class
# 
def process_tags(tagname, fp, count, tags, line)
  tag = Tag.new(tagname)
  tags << tag
  content = />(.*?)</.match(line)
  tag.content = content.to_s[1..-2] unless content.to_s[1..-2] == ''
  # binding.pry
  fp[count .. -1].each do |l|
    break unless /(<\/#{tagname[1..-2]}\s{0,1})/.match(l).nil?
    temp = /((<[a-z0-9]+\s{0,1})|(<\/[a-z0-9]+\s{0,1}))/.match(l)
    next if temp.nil?
    tempname = format_tag(temp)
    (tag.children.push(tempname) && next) unless tempname.start_with?('</')
    tag.children.push(tempname) if tag.children.include?("<#{tempname[2..-2]}>")
  end
  tag.children.shift if tag.children.size!=0
end

# method for building tree after parsing html file
#
#
# @return [<Array>] Array of Tag objects
# 
def build_tree
  fp = IO.readlines('./demo.html')
  tags = []
  count = -1
  fp.each do |line|
    count += 1
    # regex for opening tag
    o_t = /(<[a-z0-9]+\s{0,1})/.match(line)
    # regex for closing tag
    c_t = /(<\/[a-z0-9]+\s{0,1})/.match(line)
    # skip if there are no matches
    next if o_t.nil? && c_t.nil?

    unless o_t.nil?
      # formatting tag
      o_tagname = format_tag(o_t)
      # process tag
      process_tags(o_tagname, fp, count, tags, line)
    end

    unless c_t.nil?
    c_tagname = format_tag(c_t)
    tag = Tag.new(c_tagname)
    tags << tag
    end
  end
  tags
end

HTML_TAGS_TREE = build_tree

# method that print the html tree
#
#
# @return [Constant] HTML_TAGS_TREE
#
def print_tree
  HTML_TAGS_TREE.each { |node| puts node.name }
  # binding.pry
end

# method that printS the children of tags in html tree
#
#
# @return [Constant] HTML_TAGS_TREE
#
def show_children
  HTML_TAGS_TREE.each do |node|
    puts node.name
    puts node.children.to_s
    puts node.content
  end
end

def show_content
  HTML_TAGS_TREE.each do |node|
    unless node.content.nil?
      puts node.name
      puts node.content      
    end
  end
end
# method that routes the user according to his/her particular choice
#
# @param [<Integer>] ch <choice>
#
# @return [<Nil>]
#
def process_choice(ch)
  case ch
    when 1 then print_tree
    when 2 then show_children
    when 3 then show_content  
  end
end

until ch == 5
  puts '------ HTML PARSER ------'
  puts '1. print tree'
  puts '2. show children'
  puts '3. show content'
  puts '5.exit'
  ch = gets.chomp.to_i
  process_choice(ch)
end
