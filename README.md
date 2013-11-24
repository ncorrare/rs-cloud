rs-cloud Cookbook
=================
This cookbook installs the Rackspace Cloud Monitoring Agent and the Cloud Backup agent, which can later be configured from the Control Panel. For the time being it only supports RHEL 5/6.

Requirements
------------
- yum LWRP (http://docs.opscode.com/resource_yum.html)
- Create a databag (yup, unencrypted) named 'rs-cloud' with an 'api-key' item, which should contain the following:

endpoint: https://lon.identity.api.rackspacecloud.com/v2.0/
id:       api-key
key:      <your Rackspace Cloud API Key>
username: <your username>

needless to say it should be json encoded ;-).

Attributes
----------
None that I can think of

Usage
-----
Just include `rs-cloud` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[rs-cloud]"
  ]
}
```

Contributing
------------
Sure we can think of something....


License and Authors
-------------------
Authors: Nicolas Corrarello <nicolas@corrarello.com>
