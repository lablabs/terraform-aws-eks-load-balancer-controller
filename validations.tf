resource "terraform_data" "validations" {
  lifecycle {

    precondition {
      condition     = var.cluster_name != ""
      error_message = "The `cluster_name` variable must be set."
    }
  }
}
