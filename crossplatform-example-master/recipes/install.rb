#
# Cookbook Name:: python
# Recipe:: install
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'python::repository' if node['python']['installrepo']

# Install it
if node['platform_family'] == 'windows'
  include_recipe 'python::install-windows'
else
  include_recipe 'python::install-linux'
end
