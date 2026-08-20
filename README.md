# neuro-stack-aws-modules

A small collection of reusable Terraform modules for provisioning AWS infrastructure,
originally written for my `neuro-stack` project. Each module lives in its own directory,
is self-contained, and is documented with [terraform-docs](https://terraform-docs.io/).

## Modules

| Module | Description |
|--------|-------------|
| [`backend`](./backend) | S3 bucket + optional DynamoDB lock table for Terraform remote state. |
| [`network`](./network) | VPC with public/private subnets, Internet Gateway, NAT Gateways, and route tables. |
| [`eks`](./eks) | EKS cluster with managed node groups, IAM/IRSA, OIDC, addons, KMS secret encryption, and security groups. |
| [`kms`](./kms) | Customer-managed KMS key with a flexible, statement-based key policy. |
| [`gh_oidc`](./gh_oidc) | GitHub Actions OIDC provider + IAM role for keyless CI/CD authentication. |

See each module's `README.md` for its full inputs, outputs, and resources.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14 |
| aws provider | >= 6.38 |

## Usage

Reference a module by its Git source (pin to a tag/commit for stability):

```hcl
module "network" {
  source = "github.com/MichalMusialPJ/neuro-stack-aws-modules//network?ref=v1.0.0"

  name_prefix = "neuro-stack"
  region      = "eu-central-1"
  cidr        = "10.0.0.0/16"

  create_public_subnets  = true
  create_private_subnets = true
  enable_nat_gateway     = true

  tags = {
    Project = "neuro-stack"
  }
}
```

Or clone the repo and reference the modules with a local path:

```hcl
module "kms" {
  source = "../neuro-stack-aws-modules/kms"

  description = "neuro-stack secrets encryption"
}
```

## Regenerating docs

Each module README is generated with terraform-docs into the `BEGIN_TF_DOCS` / `END_TF_DOCS`
markers. After changing a module's variables or outputs, regenerate its docs:

```bash
terraform-docs markdown table --output-file README.md --output-mode inject ./<module>
```

## Acknowledgements

Some modules (notably `eks` and `network`) draw on patterns from the community
[terraform-aws-modules](https://github.com/terraform-aws-modules) projects, which are
licensed under Apache-2.0.

## License

Distributed under the MIT License. See [LICENSE](./LICENSE).
