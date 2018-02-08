# Basic Intro
<a href="https://github.com/DennyZhang?tab=followers"><img align="right" width="200" height="183" src="https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/fork_github.png" /></a>

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com) [![LinkedIn](https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/linkedin.png)](https://www.linkedin.com/in/dennyzhang001) <a href="https://www.dennyzhang.com/slack" target="_blank" rel="nofollow"><img src="http://slack.dennyzhang.com/badge.svg" alt="slack"/></a> [![Github](https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/github.png)](https://github.com/DennyZhang)

File me [tickets](https://github.com/DennyZhang/popular-github-template/issues) or star [the repo](https://github.com/DennyZhang/popular-github-template).

Table of Contents
=================
<a href="https://www.dennyzhang.com"><img align="right" width="201" height="268" src="https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/denny_201706.png"></a>

   * [Basic Intro](#basic-intro)
   * [What For?](#what-for)
   * [Create VM With pure bash](#create-vm-with-pure-bash)
   * [Create VM With Jenkins job](#create-vm-with-jenkins-job)

# What For?
- Support create and provision DigitalOcean VMs from Jenkins GUI
- Support users to customize the machine flavor, and whether to attach additional volumes
- Support users to specify the userdata of the VM
- Support users to run adenoidal scripts after the VM provisioning
```
You might have some sensitive credentials, which you don't want to pass through userdata.

Hence here we support you scp a script folder, find all bash scripts by
lexicographical order, then run them one by one
```

# Create VM With pure bash
- 1 Prepare parameters
```
export vm_hostname="denny-vm1"
export machine_flavor="512mb"
export region="sfo2"
export provision_sh="https://raw.githubusercontent.com/DennyZhang/dennytest/master/hashicorp_terraform/userdata.sh"
export provision_folder="scripts"

# export ssh_keys="XXXX"
# export do_token="XXX"
```

- 2.1 Provision a vm without volumes

vm_without_volume_example.tf: [here](vm_without_volume_example.tf)
```
bash -e terraform_create.sh "$vm_hostname" "vm_without_volume_example.tf"
```

- 2.2 Provision a vm with volumes

vm_with_volume_example.tf: [here](vm_with_volume_example.tf)
```
bash -e terraform_create.sh "$vm_hostname" "vm_without_volume_example.tf"
```

- 3 [Optional] Destroy
```
bash -e terraform_destroy.sh "$vm_hostname"
```

# Create VM With Jenkins job
jenkins_job/config.xml: [here](jenkins_job/config.xml)

![CreateDigitalOceanVM_job.png](https://raw.githubusercontent.com/dennyzhang/terraform_jenkins_digitalocean/master/CreateDigitalOceanVM_job.png)

- License

Code is licensed under [MIT License](https://www.dennyzhang.com/wp-content/mit_license.txt).
<a href="https://www.dennyzhang.com"><img align="right" width="185" height="37" src="https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/dns_small.png"></a>
