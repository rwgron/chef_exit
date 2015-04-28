url_testweb = node['testweb']['app_repo']

tomcat_deploy = node['tomcat']['deploy']
tomcat_name = node['tomcat']['name']
tomcat_home = node['tomcat']['home']

remote_file "testweb.zip" do
  source "#{url_testweb}"
  path "/tmp/testweb.zip"	
  action :create_if_missing
end

execute "stop tomcat" do
  command "service tomcat stop"
end

bash "unzip testweb" do
  code <<-EOS
  unzip -j "/tmp/testweb.zip" "testweb/testweb.war" -d /opt/tomcat/#{tomcat_name}/webapps
EOS

end

execute "start tomcat" do
  command "service tomcat start"
end
