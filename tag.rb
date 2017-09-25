# Class Tag provides attributes to Tag that are required 
# to build the html tree
# @author Piyush Wani <piyush.wani@amuratech.com>
#
class Tag
  attr_accessor :children, :content, :tagdata , :name

  # constructor
  #
  # @param [<String>] name <name of a tag>
  # 
  def initialize(name)
    @name = name 
    @children = []
    @content = ''
    @tagdata = {}
  end
end
