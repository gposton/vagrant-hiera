Puppet::Parser::Functions.newfunction(:search_nodes, :type => :rvalue) do |args|

  @doc =  '
    Takes a hash of the classes that will be used to create
    the list of hosts. It also has an optional parameter, that
    when set to true, will limit the search to nodes that share
    the environment of the caller.
  '

  class_filter = args[0].to_a || {}
  class_filter.collect! do |filter|
    filter = filter.split("::").collect { |s| s.capitalize }.join("::")
  end
  puts class_filter

  use_same_environment = args[1] || false

  if Puppet.features.rails? then
    require 'puppet/rails'
    Puppet::Rails.connect
    nodes = Puppet::Rails::Resource.find_all_by_title_and_restype(
      class_filter,'Class').to_a.collect { |resource| resource.host.name }.uniq
  end

  #TODO: Implement use_same_environment efficiently
  nodes

end
