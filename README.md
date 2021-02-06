# ruby-lazy-config

### Description
Automatically link Ruby class/module with a config file in yaml.

### Tutorial
Require the gem:

```ruby
require 'ruby-lazy-config'
```
Set the base directory where the config is located:

```ruby
LazyConfig::Config.base_dir = 'some/config/dir'
```

Set the name of the environment you are in. You don't have to set this if you don't care about environments:
```ruby
LazyConfig::Config.environment = ENV['MY_APP_ENV']
```

Suppose you have a file:
#### development/foo.yaml
```yaml
name: Joe Blow
age: 200
```
#### foo.rb
```ruby
class Foo
  # include this module into your class to gain the functionality
  include LazyConfig::Loader
  
  # You now have access to a class method 'config' that will give you the YAML in hash form.
  # This config method will load the file that is the same name in snake_case. So this class
  # is named 'Foo' it will look in the ${base_dir}/development/foo.yaml. If you have a class
  # named 'SuperFoo', then it will be in ${base_dir}/development/super_foo.yaml. If you don't
  # set the environment, then it will default to 'development'. If you don't care about
  # environments, then you can disable environments per class. So you could do then following
  # in this class:
  # self.environment_aware = false
  # This will make it so your files are loaded without the environment part of the path, so
  # using the same files from before, it would be ${base_dir}/foo.yaml and
  # ${base_dir}/super_foo.yaml
  # You can also adjust the name of the config file it looks for, so if you don't want it
  # called foo.yaml, you can redefine the 'config_filename' method.
  # def config_filename
  #   'config.yaml'
  # end
  # Now it will look for 'config.yaml' and not 'foo.yaml'
  
  class << self
    def name_from_config
      # Access data in config file with config method on the class.
      config['name']
    end
  end
end
