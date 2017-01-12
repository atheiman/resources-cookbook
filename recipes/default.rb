# needs to be a hash to make modifications
resource_types = node['resources'].to_h

# pull resource defaults out of resources hash
defaults = resource_types.delete 'defaults'

# list of resources to declare
resources = []

resource_types.each do |res_type, res_list|
  # if resource list is an array, it is assumed no properties will be passed to the resource
  res_list = Hash[res_list.map { |r| [r, {}] } ] if res_list.is_a?(Array)

  res_list.each do |res_name, res_definition|
    res = res_definition.merge({
      'resource_type' => res_type,
      'resource_name' => res_name
    })

    # apply resource defaults, add to the list of resources
    resources << Chef::Mixin::DeepMerge.merge(defaults, res)
  end
end

# sort resources by priority
resources.sort_by { |res| res['resource_priority'] }

# declare resources in order
resources.each do |res|
  Chef::Log.debug 'Declaring resource from hash definition:'
  Chef::Log.debug(JSON.pretty_generate(res))

  resource_type = res.delete 'resource_type'
  resource_name = res.delete 'resource_name'
  res.delete 'resource_priority'

  declare_resource(resource_type, resource_name) do
    res.each do |meth, val|
      send(meth, val)
    end
  end
end
