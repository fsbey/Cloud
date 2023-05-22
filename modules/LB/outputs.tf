#outputss.tf is needed as resources created by this module is used by other modules, hence needing to expose them to the outside.
output "load_balancer_sg" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
    value =  aws_lb_target_group.TG.arn
}