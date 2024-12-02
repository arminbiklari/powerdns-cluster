# powerdns-cluster

# PowerDNS Ansible and Terraform Setup

This repository provides a comprehensive solution for setting up and managing a **PowerDNS Authoritative Server** with primary and secondary designs. It integrates **Ansible** for installation and configuration, and **Terraform** for zone and record management. Additionally, it includes **dnsdist** for load balancing, DNS spoofing, and forwarding.

---

## Features
- Automated installation and configuration of PowerDNS using Ansible.
- Primary and Secondary DNS server setup for authoritative DNS management.
- Management of DNS zones and records with Terraform.
- Integration with **dnsdist** as a loadbalancer:
  - Supports DNS forwarding and spoofing.
  - Ensures high availability and load distribution for DNS queries.
  - Health check on pdns services
- Use mysql for backend storage

---

## Prerequisites
- **Ansible** installed on your control node.
- **Terraform** installed on your local machine.
- Target servers running a supported Linux distribution (e.g., Ubuntu 22.04).

---

## Usage Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/<your-username>/powerdns-ansible-terraform.git
cd powerdns-ansible-terraform
```

### 2. How to run ansible playbook

```bash
ansible-playbook -i inventory site.yaml --diff -t powerdns  -vvv 
```

## Adding zone or A record
# Edit Inventory 
New zones add in blow var on inventory/zones.yml
```yaml
    zones:
      - example.ir
      - foo.bar

```
For new A records (or any records) edit records var in inventory/zones.yml
```yaml
    records: # add records
      foo.bar: # for domain foo.bar
        - name: ns1.foo.nar
          type: A
          ttl: 300
          records:
            - 192.168.1.10
        - name: ns2.foo.nar
          type: A
          ttl: 300
          records:
            - 192.168.1.11
```
## Changing forwarder and spoofing configs
# Edit Inventory (only custom recursor, spoofing and forwarder)

inventory/zones.yml
```yaml
# Variable to control whether DNS spoofing is enabled or not
spoof_enabled: true

# Key-value pairs for spoofed domains and their IPs
spoof_domains:
    foobar.baz: 1.1.1.1 ## foobar.baz resolve 1.1.1.1


# List of recursors
recursors:    # this is forwarde option (the default dns routing)
    - address: 8.8.8.8
    name: Google
    - address: 1.1.1.1
    name: Cloudflare

custom_recursors:   # forward specific domains to specified ip
    - zone: foobarbaz.com
    addresses: 
        - 1.2.3.4
```
and then run:
```bash
ansible-playbook -i inventory site.yaml --diff -t powerdns-mgmt -vvv
```

**NOTE**: For each zones, must be add **ns1** and **ns2** records