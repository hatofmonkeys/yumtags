#
# Cookbook Name:: yumtags
# Recipe:: default
#
# Copyright 2012, Colin Humphreys
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "activemq"

%w(libxml2-devel libxslt-devel createrepo).each do |pkg|
    package pkg do
        action :install
    end
end

cookbook_file "/opt/apache-activemq-5.5.1/conf/activemq.xml" do
  source "activemq.xml"
  notifies :restart, resources(:service => "activemq"), :immediately
end

gem_package "bundler"

execute "Install bundle for Yumtags!" do
  command "/usr/local/rvm/bin/rvm-shell 1.9.2 -c 'cd #{node["yumtags"]["app_home"]} && bundle install'"
end

template "/etc/init.d/repo_creator" do
  source "repo_creator.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
      :app_home => node['yumtags']['app_home']
            )
end

service "repo_creator" do
  supports  :restart => true
  action [:enable, :start]
end

web_app "yumtags" do
  server_name node['hostname']
  server_aliases [ node['fqdn'] ] + node['yumtags']['aliases']
  docroot "#{node["yumtags"]["app_home"]}/public"
  template "yumtags.conf.erb"
end