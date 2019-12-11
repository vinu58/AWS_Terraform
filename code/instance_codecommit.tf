
resource "aws_codecommit_repository" "flask" {
  repository_name = "flask"
  description     = "This is the App Repository"
}
