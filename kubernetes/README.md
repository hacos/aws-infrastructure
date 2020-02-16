# Initial Set Up
https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started
https://learn.hashicorp.com/terraform/aws/eks-intro

# Helm Stuff
https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html

# Other
`aws eks --region [region] update-kubeconfig --name [cluster_name]`

`kubectl config delete-context eks-staging && kubectl config rename-context arn:aws:eks:us-west-2:978651561347:cluster/eks-staging eks-staging`
