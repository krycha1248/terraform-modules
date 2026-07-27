output "ingress_lb_ip" {
  value = try(
    data.kubernetes_service_v1.traefik[0].status[0].load_balancer[0].ingress[0].ip,
    null
  )
}
