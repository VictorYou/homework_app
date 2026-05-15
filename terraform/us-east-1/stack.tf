module "stack" {
  source = "../stack"

  vpc_id         = "vpc-7f158202"
  inbound_blocks = [
    "10.0.32.0/20",
    "10.0.48.0/20"
  ]
  subnet_ids = [
    "subnet-0d67f21eedcb2c1ff",
    "subnet-07783bbff204e3b7f"
  ]
}
