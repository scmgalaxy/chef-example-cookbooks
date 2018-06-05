#
# Cookbook Name:: python
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

if node['python']['disabled']
  include_recipe 'python::disabled'
  Chef::Log.warn('Python is disabled on this node.')
  return
end

include_recipe 'python::serverlibs' if node['python']['is_server']
include_recipe 'python::install'
