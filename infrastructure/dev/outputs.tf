output "lb_dns" {
  value = "http://${module.alb.lb_dns_name}"
}
