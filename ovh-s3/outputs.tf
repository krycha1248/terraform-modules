output "endpoint" {
  value = "https://s3.${var.region_name}.io.cloud.ovh.net"
}

output "bucket_name" {
  value = ovh_cloud_project_storage.storage.name
}

output "access_key_id" {
  value = ovh_cloud_project_user_s3_credential.s3_credential.access_key_id
}

output "secret_access_key" {
  value     = ovh_cloud_project_user_s3_credential.s3_credential.secret_access_key
  sensitive = true
}
