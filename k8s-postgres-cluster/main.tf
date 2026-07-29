resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = var.namespace
  }
}

locals {
  base_spec = {
    instances = var.instances_count

    storage = {
      size = var.storage_size
    }
  }

  backup_spec = var.backup != null && var.mode == "normal" ? {
    backup = {
      retentionPolicy = var.backup_retention_policy

      barmanObjectStore = {
        destinationPath = "s3://${var.backup.bucket}/${var.backup.path}"
        endpointURL     = var.backup.endpoint

        s3Credentials = {
          accessKeyId = {
            name = kubernetes_secret_v1.backup[0].metadata[0].name
            key  = "ACCESS_KEY_ID"
          }

          secretAccessKey = {
            name = kubernetes_secret_v1.backup[0].metadata[0].name
            key  = "ACCESS_SECRET_KEY"
          }
        }

        wal = {
          compression = "gzip"
        }

        data = {
          compression = "gzip"
        }
      }
    }
  } : {}

  restore_spec = var.mode == "restore" && var.backup != null ? {
    bootstrap = {
      recovery = {
        source = "${var.cluster_name}-backup-source"
      }
    }

    externalClusters = [
      {
        name = "${var.cluster_name}-backup-source"

        barmanObjectStore = {
          destinationPath = "s3://${var.backup.bucket}/${var.backup.path}"
          endpointURL     = var.backup.endpoint

          s3Credentials = {
            accessKeyId = {
              name = kubernetes_secret_v1.backup[0].metadata[0].name
              key  = "ACCESS_KEY_ID"
            }

            secretAccessKey = {
              name = kubernetes_secret_v1.backup[0].metadata[0].name
              key  = "ACCESS_SECRET_KEY"
            }
          }
        }
      }
    ]
  } : {}

  cluster_spec = merge(
    local.base_spec,
    local.backup_spec,
    local.restore_spec
  )
}

resource "kubernetes_manifest" "cluster" {
  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "Cluster"

    metadata = {
      name      = var.cluster_name
      namespace = kubernetes_namespace_v1.namespace.metadata[0].name
    }

    spec = local.cluster_spec
  }

  wait {
    fields = {
      "status.phase" = "Cluster in healthy state"
    }
  }
}

resource "kubernetes_manifest" "scheduled_backup" {
  count = var.backup != null && var.mode == "normal" ? 1 : 0

  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "ScheduledBackup"

    metadata = {
      name      = "${var.cluster_name}-backup"
      namespace = kubernetes_namespace_v1.namespace.metadata[0].name
    }

    spec = {
      schedule = var.backup.schedule

      backupOwnerReference = "cluster"

      cluster = {
        name = var.cluster_name
      }
    }
  }
}