# Kubernetes Cluster Setup using Ansible

This repository contains Ansible playbooks to set up a Kubernetes cluster with one master node and multiple slave nodes.

## **Prerequisites**
- Ubuntu-based servers (Master and Slave nodes)
- Ansible installed on the control machine
- SSH access to all nodes with passwordless authentication
- Docker and `kubeadm` installed on all nodes

## **Inventory File**
Define your master and slave nodes in the inventory file (`inventory`):


## **Playbooks**
### **1. Master Node Setup**
This playbook initializes the master node and stores the Kubernetes join command.

**File:** `playbook/kubeadmsetup/masternode.yaml`
```yaml
---
- name: Initialize Kubernetes Master Node
  hosts: masternode
  become: yes
  tasks:
    - name: Check if Kubernetes is already initialized
      stat:
        path: /etc/kubernetes/admin.conf
      register: kubeadm_installed

    - name: Initialize Kubernetes Master Node
      command: kubeadm init --cri-socket unix:///run/cri-dockerd.sock
      when: not kubeadm_installed.stat.exists

    - name: Get Kubernetes join command
      command: kubeadm token create --print-join-command
      register: join_command
      when: not kubeadm_installed.stat.exists

    - name: Save join command to local file
      local_action:
        module: copy
        content: "{{ join_command.stdout }}"
        dest: "./kube_join_command.sh"
      run_once: true

## **Playbooks**
### **1. Master Node Setup**
This playbook initializes the master node and stores the Kubernetes join command.

**File:** `playbook/kubeadmsetup/masternode.yaml`
```yaml
---
- name: Initialize Kubernetes Master Node
  hosts: masternode
  become: yes
  tasks:
    - name: Check if Kubernetes is already initialized
      stat:
        path: /etc/kubernetes/admin.conf
      register: kubeadm_installed

    - name: Initialize Kubernetes Master Node
      command: kubeadm init --cri-socket unix:///run/cri-dockerd.sock
      when: not kubeadm_installed.stat.exists

    - name: Get Kubernetes join command
      command: kubeadm token create --print-join-command
      register: join_command
      when: not kubeadm_installed.stat.exists

    - name: Save join command to local file
      local_action:
        module: copy
        content: "{{ join_command.stdout }}"
        dest: "./kube_join_command.sh"
      run_once: true



## **Playbooks**
### **1. Master Node Setup**
This playbook initializes the master node and stores the Kubernetes join command.

**File:** `playbook/kubeadmsetup/masternode.yaml`
```yaml
---
- name: Initialize Kubernetes Master Node
  hosts: masternode
  become: yes
  tasks:
    - name: Check if Kubernetes is already initialized
      stat:
        path: /etc/kubernetes/admin.conf
      register: kubeadm_installed

    - name: Initialize Kubernetes Master Node
      command: kubeadm init --cri-socket unix:///run/cri-dockerd.sock
      when: not kubeadm_installed.stat.exists

    - name: Get Kubernetes join command
      command: kubeadm token create --print-join-command
      register: join_command
      when: not kubeadm_installed.stat.exists

    - name: Save join command to local file
      local_action:
        module: copy
        content: "{{ join_command.stdout }}"
        dest: "./kube_join_command.sh"
      run_once: true


2. Slave Node Setup
This playbook copies the join command to slave nodes and executes it.

File: playbook/kubeadmsetup/slavenodes.yaml

yaml
Copy
Edit
---
- name: Copy and Execute Join Command on Slave Nodes
  hosts: slavenodes
  become: yes
  tasks:
    - name: Copy join command to slave nodes
      copy:
        src: "./kube_join_command.sh"
        dest: "/tmp/kube_join_command.sh"
        mode: '0755'

    - name: Execute join command on slave nodes
      command: sh /tmp/kube_join_command.sh
      register: join_output
      changed_when: join_output.rc == 0

    - name: Print join command output
      debug:
        msg: "{{ join_output.stdout_lines }}"
Running the Playbooks
Initialize the master node:
ansible-playbook -i inventory playbook/kubeadmsetup/masternode.yaml
Set up the slave nodes:
ansible-playbook -i inventory playbook/kubeadmsetup/slavenodes.yaml
Verifying the Cluster
After all nodes have joined, verify the cluster:

kubectl get nodes
If a slave node fails to join, check logs:
journalctl -u kubelet -f
Ensure kubeadm, kubelet, and kubectl are installed on all nodes.
