# needs to be a hash to make modifications
resources = node['resources'].to_h
Chef::log.debug 'Raw resources attributes hash (resources):'
Chef::log.debug(JSON.pretty_generate(resources))

# pull resource defaults out of resources hash
resource_defaults = resources.delete 'resource_defaults'
Chef::log.debug 'Resources defaults hash (resource_defaults):'
Chef::log.debug(JSON.pretty_generate(resource_defaults))

# merge resource defaults and defined resources
resources.map do |res|
  res = Chef::Mixin::DeepMerge.merge(resource_defaults, res)
end
Chef::log.debug 'Merged resources hash (resources):'
Chef::log.debug(JSON.pretty_generate(resources))

# sort resources by priority
resources.sort_by { |res| res['resource_priority'] }
Chef::log.debug 'Sorted resources hash (resources):'
Chef::log.debug(JSON.pretty_generate(resources))

# apply resources in order
resources.each do |res|
  Chef::log.debug 'Applying resource (res):'
  Chef::log.debug(JSON.pretty_generate(res))
  resource_type = res.delete 'resource_type'
  resource_name = res.delete 'resource_name'

  declare_resource(resource_type, resource_name) do
    res.each do |meth, val|
      send(meth, val)
    end
  end
end
