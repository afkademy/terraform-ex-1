# -----------creation of an s3 bucket-------------
resource "aws_s3_bucket" "assignment-bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "${var.vpc_name}-${var.backend_instance_name}"
    Env= local.common_tags["Env"]
    Team= local.common_tags["Team"]
  }
}

# ...................uploading .sh files into s3...........
resource "aws_s3_bucket_object" "s3objects_inside_s3bucket" {
  bucket = aws_s3_bucket.assignment-bucket.id
  for_each = fileset("${path.module}","**/*.sh")
  key = "${each.value}"
  source = "${path.module}/${each.value}" 
}
