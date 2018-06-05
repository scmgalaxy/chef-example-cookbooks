# Cross Platform Cookbook Development

## Synopsis of Problem
Cookbook metadata.rb does not provide a way to optionally depend on another cookbook based upon its platform architecture.  Thus is it tempting to write platform specific cookbooks and use other logic to affect inclusion of the patfrom specific cookbook in a node's run_list.

## Example Scenario
Often as you write cookbooks for your organization you may encounter a situation where the initial target scope of infrastructure platform changes. For instance, perhaps initially your entire environment was comprised of Windows nodes but now you're adding Linux systems to the environment. You have a couple of options:

1. Write new library cookbooks for the Linux systems
2. Re-factor the existing (Windows) library cookbooks for both platforms

Since cookbook duplication (inadvertent or purposeful duplication) can lead to maintenance nightmares, poor factoring, and logical contradictions (see [DRY](http://c2.com/cgi/wiki?DontRepeatYourself)), the second option is superior in most cases.

However, this option can present an immediate problem if your existing Windows library cookbook contains a require statement like this and you attempt to include the cookbook in a Linux node's run_list:

```
# libraries/process_helper.rb

require 'win32/registry'
require 'win32ole'

module MyLib
  module Helper

    ...
  end
end
```
When Chef attempts to converge the node (run the compile then execution stages), the compile phase fails since the required ruby libraries do not exist on the system.

```
Compiling Cookbooks...

================================================================================
Recipe Compile Error in libraries/process_helper.rb
================================================================================

LoadError
---------
cannot load such file -- win32/registry
cannot load such file -- win32ole
```

## Solution Patterns

Since cookbook libraries are just ruby and they have access to the Chef namespace including helper functions, we can leverage platform detection logic and wrap the problem areas in conditional statements.

Thus our cookbook's library require statements change to this:

```
# libraries/process_helper.rb

if Chef::Platform.windows?
  require 'win32/registry'
  require 'win32ole'
end

...
```

This simple pattern allows the compile phase to complete successfully and the execution phase begins. With this practice we can now leverage one library cookbook for multiple node architectures.

To ease the ongoing maintenance of the cookbook it is additionally a good practice to avoid having all your logic and code in just one or two recipes.  Treating recipes like you would Class files helps group your code into functional chunks and greatly improves readability and usability.

This is where you can break apart your Chef code into platform specific sections, using recipes like so:

```
#
# Cookbook Name:: myOrgPython
# Recipe:: install

# Decide how to install it
case node['platform']
when 'debian', 'ubuntu'
  include_recipe 'myOrgPython::install-debian'
when 'redhat', 'centos', 'fedora'
  include_recipe 'myOrgPython::install-rhel'
when 'windows'
  include_recipe 'myOrgPython::install-windows'
end

```

Finally, you can ensure that recipes do not get included and executed on the incorrect platform architecture like this:

```
#
# Cookbook Name:: myOrgPython
# Recipe:: install-windows
#

if ! platform?('windows')
  Chef::Log.warn "[python::install-windows] unsupported platform family: #{node[:platform_family]}"
  return
end

::Chef::Recipe.send(:include, MyLib::Helper)

# Do Windowsy stuff..
Chef::Log.warn "Installing Windows python.." if ! is_process_running?('python.exe')
```
