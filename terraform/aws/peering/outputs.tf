output "peering_status" {
  value = aws_vpc_peering_connection.peering.accept_status
}
