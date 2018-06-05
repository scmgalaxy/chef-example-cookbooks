#
# Cookbook Name:: python
# Recipe:: install-linux
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

Chef::Application.fatal! "[python::install-linux] unsupported platform family: #{node[:platform_family]}" if platform?('windows')

::Chef::Recipe.send(:include, MyProcess::Helper)
::Chef::Recipe.send(:include, MyApplication::Helper)

# Do stuff..
Chef::Log.warn "Installing Linux Python.."
