#
# Cookbook Name:: Tomcat
# Recipe:: default
#
# Copyright 2011, Bryan W. Berry
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java::default"

tomcat_home = node['tomcat']['tomcat_home']
tomcat_url = node['tomcat']['dl_url']
tomcat_name = node['tomcat']['name']


remote_file "#{tomcat_name}.zip" do
  source tomcat_url
  path "/tmp/#{tomcat_name}.zip"
  action :create_if_missing

end

directory "#{tomcat_home}" do
  action :create

end

cookbook_file "tomcat.conf" do
  path "/etc/httpd/conf.d/tomcat.conf"
  mode "0755"
  group "root"
  owner "root"
  action :create_if_missing

end

bash "unzip tomcat" do
  code <<-EOS
  mkdir #{tomcat_home}
  unzip /tmp/#{tomcat_name}.zip -d #{tomcat_home}
  chmod +x #{tomcat_home}/#{tomcat_name}/bin/catalina.sh
  chmod +x #{tomcat_home}/#{tomcat_name}/bin/shutdown.sh
EOS

end

cookbook_file "tomcat" do
  path "/etc/init.d/tomcat"
  mode "0755"
  group "root"
  owner "root"
  action :create_if_missing
end

execute "add_chkconfig" do
  command "chkconfig --add tomcat"

end


