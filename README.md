# `resources` Cookbook

Apply resources to nodes via attributes!

This cookbook applies resources to nodes dynamically using attributes. Here is a complete example role using this cookbook to download a file, run commands against the file, then delete the file:

```ruby
name 'example_resources_cookbook_role'
description 'Example role using the resources cookbook'

run_list 'recipe[resources]'

default_attributes({
  'resources' => {
    'remote_file' => {
      '/tmp/file.txt' => {
        # pass properties and arguments to resources as key value pairs in a hash
        'source' => 'http://host/file.txt',
        'mode' => '755',
        # priority 90 will occur before the default of 100
        'resource_priority' => 90
      }
    },
    'execute' => [
      # if no extra args are needed to the resources, an array is acceptable
      # (arguments default to the ['resources']['defaults'] attribute)
      'ls -alh /tmp/file.txt',
      'cat /tmp/file.txt'
    ],
    'file' => {
      '/tmp/file.txt' => {
        # actions can be passed just like other properties
        'action' => 'delete',
        # priority 110 will occur after the default of 100
        'resource_priority' => 110
      }
    }
  }
})
```

Here is that same role in JSON format:

```json
{
  "name": "example_resources_cookbook_role",
  "description": "Example role using the resources cookbook",

  "run_list": [
    "recipe[resources]"
  ],

  "default_attributes": {
    "resources": {
      "remote_file": {
        "/tmp/file.txt": {
          "source": "http://host/file.txt",
          "mode": "755",
          "resource_priority": 90
        }
      },
      "execute": [
        "ls -alh /tmp/file.txt",
        "cat /tmp/file.txt"
      ],
      "file": {
        "/tmp/file.txt": {
          "action": "delete",
          "resource_priority": 110
        }
      }
    }
  }
}
```

# Notes

## Using the `execute` resource

Remember this warning from the [Chef docs](https://docs.chef.io/resource_execute.html):

> Commands that are executed with this resource are (by their nature) not idempotent, as they are typically unique to the environment in which they are run. Use not_if and only_if to guard this resource for idempotence.

## Should you use this?

Generally writing a cookbook to apply resources would be a much better approach because it is testable and more readable. I would recommend only use this cookbook in simple situations to apply a few resources to a node. I have created this cookbook mostly just to see if this was possible.

That said, I have used it in roles as shown in the example above when I dont want to go through the hassle of writing an entire cookbook just to execute a couple commands. This cookbook fills the use case of piecing together a small number of cookbooks with a role and a few extra resources very well.
