resource "ovh_cloud_project_storage" "storage" {
  service_name = var.service_name
  region_name  = var.region_name
  name         = var.bucket_name

  encryption = {
    sse_algorithm = "AES256"
  }

  versioning = {
    status = var.versioning_enabled
  }
}

resource "ovh_cloud_project_user" "user" {
  service_name = var.service_name
  description  = var.user_description
  role_names = [
    "objectstore_operator"
  ]
}

resource "ovh_cloud_project_user_s3_credential" "s3_credential" {
  service_name = ovh_cloud_project_user.user.service_name
  user_id      = ovh_cloud_project_user.user.id
}

resource "ovh_cloud_project_user_s3_policy" "policy" {
  service_name = ovh_cloud_project_user.user.service_name
  user_id      = ovh_cloud_project_user.user.id
  policy = jsonencode({
    "Statement" : [{
      "Sid" : "RWContainer",
      "Effect" : "Allow",
      "Action" : ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket", "s3:ListMultipartUploadParts", "s3:ListBucketMultipartUploads", "s3:AbortMultipartUpload", "s3:GetBucketLocation"],
      "Resource" : ["arn:aws:s3:::${var.bucket_name}", "arn:aws:s3:::${var.bucket_name}/*"]
    }]
  })
}
