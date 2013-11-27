#
# Cookbook Name:: rs-cloud
# Recipe:: default
#
# Copyright 2013, Corrarello
#
# All rights reserved - Do Not Redistribute
#
# Recipe Data
# 1) Import Signing Keys
# 2) Create the Repo Files (EL5/6)
# 3) Install Rackspace Monitoring Agent
# 4) Register it after your api key
# 5) Set Up Cloud Backup Agent Repo
# 6) Install Rackspace Cloud Backup Agent

rsapikey = data_bag_item("rs-cloud", "api-key")

yum_repository "rs-monitoring" do
    only_if { platform_family?('rhel') && node['platform_version'].to_f > 6.0 }
    description "Rackspace Cloud Monitoring"
    url "http://stable.packages.cloudmonitoring.rackspace.com/centos-6-x86_64"
    key "https://monitoring.api.rackspacecloud.com/pki/agent/linux.asc"
    action :add
end

yum_key "rs-monitoring.asc" do
    only_if { platform_family?('rhel') && node['platform_version'].to_f < 6.0 }
    url" https://monitoring.api.rackspacecloud.com/pki/agent/centos-5.asc"
    action :add
end

yum_key "rs-monitoring.asc" do
    only_if { platform_family?('rhel') && node['platform_version'].to_f > 6.0 }
    url" https://monitoring.api.rackspacecloud.com/pki/agent/linux.asc"
    action :add
end

yum_repository "rs-monitoring" do
    only_if { platform_family?('rhel') && node['platform_version'].to_f < 6.0 }
    description "Rackspace Cloud Monitoring"
    url "http://stable.packages.cloudmonitoring.rackspace.com/centos-5-x86_64"
    key "https://monitoring.api.rackspacecloud.com/pki/agent/centos-5.asc"
    action :add
end

package "rackspace-monitoring-agent" do
   action :install
end

execute 'rs-mon-agent-setup' do
    command "/usr/bin/rackspace-monitoring-agent --setup --username #{rsapikey['username']} --apikey #{rsapikey['key']}"
    not_if "test -s /etc/rackspace-monitoring-agent.cfg"
end

service "rackspace-monitoring-agent" do
    action [:enable, :restart]
end

yum_repository "rs-backup" do
    description "Rackspace Cloud Backup"
    url "http://agentrepo.drivesrvr.com/redhat/"
    action :add
end

package "driveclient" do
    action :install
end

execute 'rs-backup-agent-setup' do
    command "/usr/local/bin/driveclient --configure -u #{rsapikey['username']} -k #{rsapikey['key']}"
    not_if "test -f /etc/driveclient/cacert.pem"
end

service "driveclient" do
    action [:enable, :restart]
end


