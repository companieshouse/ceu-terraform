output "rg_ceu_arn" {
	value = aws_resourcegroups_group.rg_ceu.arn
} 

output "all_tags" {
    value = aws_resourcegroups_group.rg_ceu.tags_all
}