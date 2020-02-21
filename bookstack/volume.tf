# resource "kubernetes_persistent_volume_claim" "uploads" {
#   metadata {
#     namespace = var.prefix
#     name      = "${var.prefix}-pvc-uploads"
#
#     labels = {
#       app      = "${var.prefix}-${local.environment}"
#       chart    = "bookstack-1.2.0"
#       heritage = "Helm"
#       release  = "${var.prefix}-${local.environment}"
#     }
#   }
#
#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "8Gi"
#       }
#     }
#     storage_class_name = "${var.prefix}-storage-class"
#   }
# }
#
# resource "kubernetes_persistent_volume_claim" "storage" {
#   metadata {
#     namespace = var.prefix
#     name      = "${var.prefix}-pvc-storage"
#
#     labels = {
#       app      = "${var.prefix}-${local.environment}"
#       chart    = "bookstack-1.2.0"
#       heritage = "Helm"
#       release  = "${var.prefix}-${local.environment}"
#     }
#   }
#
#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "8Gi"
#       }
#     }
#     storage_class_name = "${var.prefix}-storage-class"
#   }
# }
