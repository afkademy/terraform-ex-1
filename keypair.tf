resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "foo" {
  content  = tls_private_key.private_key.private_key_openssh
  filename = "backend-key.pem"
}