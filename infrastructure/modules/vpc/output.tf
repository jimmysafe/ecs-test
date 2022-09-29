
output "output_vpc_id" {
    description = "VPC ID"
    value = "${aws_vpc.main.id}"
}

output "output_public_subnet_1_id" {
    description = "Public Subnet 1 ID"
    value = "${aws_subnet.public_subnet_1.id}"
}

output "output_public_subnet_2_id" {
    description = "Public Subnet 2 ID"
    value = "${aws_subnet.public_subnet_2.id}"
}

