#-------storage.tf------
resource random_id tf_bucket_id {
  byte_length = 2
}

#create S3

resource "aws_s3_bucket" "storage_s3" {
    bucket = "${var.project_name}-${random_id.tf_bucket_id.dec}"
    acl = "private"
    force_destroy = true
    tags = {
        Name = "tf_bucket"
    }
}
