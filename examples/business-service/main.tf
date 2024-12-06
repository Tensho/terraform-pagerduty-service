module "example" {
  source = "../../"

  business = true

  name             = "Acme Corp Mega Service"
  description      = "The Acme Corp Mega Service is the most important service in the company."
  point_of_contact = "acme@example.com"
  team_name        = "Platform"
}
