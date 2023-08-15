locals {

 common_tags ={
    Env = var.env
    Team = var.team
 }

 inbound_rules = [22,80,3000,443,8081,8080]

}

