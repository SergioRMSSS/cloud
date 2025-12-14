Host bastion
  HostName ${bastion_ip}
  User ${bastion_user}
  IdentityFile ~/.ssh/${bastion_key}
  StrictHostKeyChecking no

%{ for index, ip in private_ips ~}
Host private-${index + 1}
  HostName ${ip}
  User ec2-user
  IdentityFile ~/.ssh/${private_keys[index]}
  ProxyJump bastion
  StrictHostKeyChecking no

%{ endfor ~}