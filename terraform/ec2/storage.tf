## Allocation EBS for persistent storage
resource "aws_ebs_volume" "ec2_ebs" {
  availability_zone = data.aws_availability_zone.az.name
  size = var.ebs_size
  encrypted = var.ebs_encrypted
  tags = local.tags
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ec2_ebs.id
  instance_id = aws_instance.base_instance.id
}