module "stack" {
  source = "../stack"

  vpc_id         = "vpc-0fe862b1e74c2b8d3"
  inbound_blocks = [
    "10.0.32.0/20",
    "10.0.48.0/20"
  ]
  subnet_ids = [
    "subnet-0f33e3ea62752f61e",
    "subnet-0a589de5d3123fe0a"
  ]
}
