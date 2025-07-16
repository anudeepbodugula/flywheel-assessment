### IAM ROle for EKS Control PLane
resource "aws_iam_role" "eks_cluster_role" {
    name = "${var.cluster_name}-eks-cluster-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect = "Allow",
            Principal = {
                Service = "eks.amazonaws.com"
        },   
            Action = "sts:AssumeRole"
        }]
    })

    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    role = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

## EKS Cluster ########
resource "aws_eks_cluster" "eks_cluster" {
    name = var.cluster_name
    version = var.cluster_version
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
        subnet_ids = var.subnet_ids
        endpoint_private_access = true
        endpoint_public_access = false

    }
    tags = var.tags

    depends_on = [ aws_iam_role.eks_cluster_role, aws_iam_role_policy_attachment.eks_cluster_policy ]
}

### IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_group_role" {
    name = "${var.cluster_name}-eks-node-group-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect = "Allow",
            Principal = {
                Service = "ec2.amazonaws.com"
            },
            Action = "sts:AssumeRole"
        }]
    })
    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "node_group_policies" {
    for_each = toset([
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    ])

    role = aws_iam_role.eks_node_group_role.name
    policy_arn = each.value
}

#### Node Group ########
resource "aws_eks_node_group" "main" {
    for_each = var.node_groups

    cluster_name = aws_eks_cluster.eks_cluster.name
    node_group_name = each.key
    node_role_arn = aws_iam_role.eks_node_group_role.arn
    subnet_ids = var.subnet_ids

    instance_types = each.value.instance_types
    capacity_type = each.value.capacity_type

    scaling_config {
        desired_size = each.value.scaling_config.desired_size
        max_size = each.value.scaling_config.max_size
        min_size = each.value.scaling_config.min_size
    }

    disk_size = each.value.disk_size
    ami_type = each.value.ami_type

    tags = merge(var.tags, {
        Name = "${var.cluster_name}-${each.key}-node-group"
        NodeGroup = each.key
        Environment = var.environment
    })

    depends_on = [ 
        aws_eks_cluster.eks_cluster, 
        aws_iam_role.eks_node_group_role, 
        aws_iam_role_policy_attachment.node_group_policies 
    ]
}

