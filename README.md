# `resources` Cookbook

Apply resources to nodes via attributes!

```json
{
  "name": "example_resources_cookbook_role",
  "description": "Example role using the resources cookbook",
  "json_class": "Chef::Role",
  "chef_type": "role",

  "run_list": [
    "recipe[resources]"
  ],

  "default_attributes": {
    "resources": {
      "remote_file": {
        "/tmp/file_a": {
          // pass arguments to resources as key value pairs in the hash
          "source": "http://host/file_a",
          // priority 90 will occur before the default of 100
          "resource_priority": 90
        }
      },
      "execute": [
        // if no extra args are needed to the resources, an array is acceptable
        // (arguments default to the ['resources']['defaults'] attribute)
        "ls -alh /tmp/file_a",
        "cat /tmp/file_a"
      ],
      "file": {
        "/tmp/file_a": {
          // actions can be passed just like arguments
          "action": "delete",
          // priority 110 will occur after the default of 100
          "resource_priority": 110
        }
      }
    }
  }
}
```
