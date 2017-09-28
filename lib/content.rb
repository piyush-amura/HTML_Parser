# Class Content provides <method for manipulation on content>
#
# @author Piyush Wani <piyush.wani@amuratech.com>
#
class Content
  attr_accessor :data

  # <constructor for Content class>
  #
  # @param [<String>] data <content data>
  #
  def initialize(data = nil)
    @data = data
  end
end
