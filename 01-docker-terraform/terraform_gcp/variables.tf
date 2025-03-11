variable "credentials" {
  description = "Project credentials API"
  default     = "./keys/key-creds.json"

}

variable "project" {
  description = "Project"
  default     = "indigo-muse-452811-u7"
}

variable "region" {
  description = "region"
  default     = "asia-southeast2-c"
}

variable "location" {
  description = "Default Location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My Biqeury Dataset Name"
  default     = "demo_dataset"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDART"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucet Name"
  default     = "muse-452811-u7"
}

