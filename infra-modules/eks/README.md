- **Understanding EKS Cluster Creation (Manual vs. Automated)**
  - This guide first outlines the manual steps for creating an EKS cluster to provide foundational understanding before automating the process with Infrastructure as Code (IaC).
- **Prerequisites: AWS IAM User for Terraform**
  - Before proceeding, ensure you have an AWS IAM user configured for Terraform. This user will authenticate with AWS to make API calls for resource creation.
  - **Important:** Adhere to the principle of least privilege by limiting the scope of access for this IAM user.

-**MANUAL**
- **EKS Cluster IAM Role Creation**
  - **Purpose:** This IAM role is assumed by the EKS control plane, enabling it to interact with other AWS services on your behalf (e.g., managing EC2 instances for worker nodes, interacting with VPC components).
  - **Required Permissions:**
    - `AmazonEKSClusterPolicy`: Grants permissions necessary for the EKS control plane to manage cluster resources.
    - `AmazonEC2ContainerRegistryReadOnly`: Allows the EKS control plane to pull images from Amazon ECR.
  - **Trust Policy Configuration:** The trust policy for this role **must** allow `eks.amazonaws.com` to assume the role. This is crucial for the EKS service to operate correctly.

  - IAM -> Roles -> Create role -> AWS Service -> Use case (EKS) -> choose EKS cluster -> Add Amazomn EKS cluster ploicy

  



