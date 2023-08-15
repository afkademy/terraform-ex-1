output instance_public_ip {
  value       = aws_instance.backend.public_ip
  description = "instance public ip"
}

output instance_public_dns {
  value       = aws_instance.backend.public_dns
  description = "instance public ip"
}

output nexus_instance_public_dns {
  value       = aws_instance.nexus.public_dns
  description = "instance public ip"
}
