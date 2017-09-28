require_relative './tag'
require_relative './lib/stack'

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
  content = ''
  # binding.pry if tagname=='<a>';
  binding.pry
  line.scan(/>(.*?)</) { |match|  content += match[0].to_s }
  tag.content = Content.new( content ) unless content[1..-2] == ''

  tagdata = line.scan(/(\w+='.*?'|\w+=\".*?\")/)
  h = {}
  unless tagdata.nil?
    tagdata.each do |i|
      v = i[0].scan(/(\S+)=('.*?')|(\S+)=(\".*?\")/)[0].compact
      key = v[0]
      value = v[1]
      value = value[1..-2] unless value.nil?
      h[key] = value unless key.nil? && value.nil?
    end
  end
  tag.tagdata = h

  fp[count..-1].each do |l|
    break unless /(<\/#{tagname[1..-2]}\s{0,1})/.match(l).nil?
    temp = l.scan(/(<[a-z0-9]+\s{0,1})|(<\/[a-z0-9]+\s{0,1})/).flatten.compact
    next if temp.nil?
    temp.each do |t|
      tempname = format_tag(t)
      (tag.children.push(tempname) && next) unless tempname.start_with?('</')
      tag.children.push(tempname) if tag.children.include?("<#{tempname[2..-2]}>")
    end
  end
  tag.children.shift unless tag.children.empty?
  stack = Stack.new

  temp = tag.children.first
  flag = true
  tag.children.each do |t|
    unless flag
      temp = t
      flag = true
    end
    unless t.scan(/(<\/#{temp[1..-2]}\s{0,1})/).empty?
      stack.push(temp)
      flag = false
    end
  end
  tag.children = stack.store
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
    o_t = line.scan(/(<[a-z0-9]+\s{0,1})/)
    # regex for closing tag
    c_t = line.scan(/(<\/[a-z0-9]+\s{0,1})/)
    # skip if there are no matches

    next if o_t.nil? && c_t.nil?

    unless o_t.empty?
      o_t.each do |t|
        # formatting tag
        o_tagname = format_tag(t[0])
        # process tag
        process_tags(o_tagname, fp, count, tags, line)
      end
    end

    unless c_t.empty?
      c_t.each do |t|
        c_tagname = format_tag(t[0])
        tag = Tag.new(c_tagname)
        tags << tag
      end
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
  HTML_TAGS_TREE.each do |node|
    puts node.name
  end
end

# method that printS the children of tags in html tree
#
#
# @return [Constant] HTML_TAGS_TREE
#
def show_children
  HTML_TAGS_TREE.each do |node|
    if node.name.scan(/(<\/[a-z0-9]+\s{0,1})/).empty?
      puts node.name
      puts node.children.to_s
    end
  end
end

def show_content
  HTML_TAGS_TREE.each do |node|
    # binding.pry
    unless node.content.nil? || node.content.data == ''
      puts node.name
      puts node.content.data
    end
  end
end

def show_tagdata
  HTML_TAGS_TREE.each do |node|
    unless node.tagdata.empty?
      puts node.name
      puts node.tagdata
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
  when 4 then show_tagdata
  end
end

until ch == 5
  puts '------ HTML PARSER ------'
  puts '1. print tree'
  puts '2. show children'
  puts '3. show content'
  puts '4. show tagdata'
  puts '5.exit'
  ch = gets.chomp.to_i
  process_choice(ch)
end
