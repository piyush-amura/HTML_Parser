require_relative './tag'
require 'pry'

fp = File.open('./demo.html','r')
# filestring = ''

# def process_tag(fp, count, tag, tags, line)
#   fp[count..-1].each do |line|
#     break if line.scan(//) { |match|  }
#   end
# end

def format_tag(tag)
  t = tag.to_s
  t = t[0..-2] if t[-1] == ' '
  t[t.length] = '>'
  t
end

def build_tree(fp)
  tags = []
  count = -1
  fp.each do |line|
    count += 1
    temp_tags = line.scan(/((<[a-z0-9]+\s{0,1})|(<\/[a-z0-9]+\s{0,1}))/)
    temp_tags.each do |tag|
      unless tag.nil?
        tag = format_tag(tag)
        # tag = process_tag(tagname, fp, count, tags, line)
        tags<< tag
      end
  	end
  end
  tags.flatten
end

tags = build_tree(fp)

tags.each{|p|  puts p}