resource "aws_instance" "wordpress_server" {
    ami = "ami-0ed9277fb7eb570c9"
    instance_type = "t2.micro"
    # VPC
    subnet_id = "${aws_subnet.wp_subnet.id}"
    # Security Group
    vpc_security_group_ids = ["${aws_security_group.ssh_http_allowed.id}"]
    # the Public SSH key
    key_name = "${aws_key_pair.terraform-aws-keypair.id}"
    # nginx installation

    provisioner "remote-exec" {
        inline = [
             "sudo yum install httpd -y",
             "sudo systemctl start httpd",
             "sudo mkfs -t ext4 /dev/xvdf",
             "sudo mount /dev/xvdf /var/www/html/",
             "sudo touch /var/www/html/index.html",
             "sudo chown -R $USER:$USER /var/www",
             "sudo echo 'hello world!!!' > /var/www/html/index.html"
        ]
    }
    connection {
        user = "ec2-user"
    host  = aws_instance.wordpress_server.public_ip
        private_key = "${file("${var.PRIVATE_KEY_PATH}")}"
    }
}
// Sends your public key to the instance
resource "aws_key_pair" "terraform-aws-keypair" {
    key_name = "terraform-aws-keypair"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
}

resource "aws_ebs_volume" "wordpress_code" {
  availability_zone = "us-east-1a"
  size              = 1
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.wordpress_code.id
  instance_id = aws_instance.wordpress_server.id
}