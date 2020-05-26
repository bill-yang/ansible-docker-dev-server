# My DevOps with Ansible and Docker

## Idea

I am trying to setup an environment in my local machine without Virtualbox and Vagrant

    - Using Ansible to install/setup the environment
    - Using Ansible to build/deploy Dockers
    - Using Docker to run services e.g. mysql, redis and nginx
    - Test/Run applications in Docker

## Folder structure
    .
    +-- README.md
    +-- run.sh
    +-- ansible
        +-- ansible.cfg
        +-- playbooks
            +-- develop.yml
                ...
        +-- roles
            ...
    +-- docker
        +-- data
        +-- db
        +-- elasticsearch
        +-- redis
        +-- web-serve
    +-- log
    +-- webapp
    +-- www

## Folders Description
    - `data`: data volumes container for persistence
    - `elasticsearch`: Elasticsearch
    - `mysql`: MySQL database
    - `nginx`: nginx
    - `redis`: redis


## Get Ansible roles ready

A third-party role will be used for installing Node.js, get that role from github.

```
cd devops/ansible/
git clone https://github.com/morgangraphics/ansible-role-nvm.git nvm
```

## Install by Ansible

Make sure the ansible is installed (recommend install ansible with python3/pip3)

```
ansible --version
```

Then run ansible

```
ansible-playbook -i inventory -K playbook-local.yml
```

If have not ssh private key pair ready, use follow command to generate it:

```
ssh-keygen
```

Then copy ssh key file to remote server, e.g. 192.168.56.100

```
ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.56.100
```


## Start

Goto the devops folder, start environment by:

```
./run.sh
```

##  Hosts file (/etc/hosts) update

We need update the `/etc/hosts` file to access the VM from host machine. Add following to bottom of the `/etc/hosts` file.

```
# VM host IP and name
192.168.56.201   info.web.vm
```

## Debug in VS code with xdebug
Add following configure in `.vscode/launch.json`:

```json
        {
            "name": "PHP - Listen for XDebug",
            "type": "php",
            "request": "launch",
            "port": 9000,
            "stopOnEntry": false,
            "pathMappings": {
                "/var/www": "${workspaceFolder}/www"
            },
            "log": true
        }
```