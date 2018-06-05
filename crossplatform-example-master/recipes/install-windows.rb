#
# Cookbook Name:: python
# Recipe:: install-windows
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

if ! platform?('windows')
  Chef::Log.warn "[python::install-windows] unsupported platform family: #{node[:platform_family]}"
  return
end

::Chef::Recipe.send(:include, MyProcess::Helper)
::Chef::Recipe.send(:include, MyApplication::Helper)

# Do Windowsy stuff..
Chef::Log.warn "Installing Windows python.." if ! is_process_running?('python.exe')
