# 🚀 Production-Style DevOps on AWS (Terraform + GitHub Actions + Monitoring)

This project demonstrates how to build a **real-world DevOps pipeline** on AWS with industry best practices.  
The goal was to provision secure infra with Terraform, automate deployments with GitHub Actions, and add basic observability with CloudWatch — then demo it and tear down resources to avoid costs.

---

## 🧱 Architecture

```
Developer push → GitHub Actions → S3 (private)
                               └→ CloudFront (OAC)
                                               └→ End Users (HTTPS)
CloudWatch → Alarms for 4xx/5xx, optional dashboard (us-east-1)
```

- **Private S3** (no public ACLs) — content is served only via CloudFront  
- **CloudFront OAC** — modern, secure access from CloudFront to S3  
- **IaC (Terraform)** — reproducible infrastructure  
- **CI/CD (GitHub Actions)** — push to `main` deploys & invalidates cache  
- **Monitoring (CloudWatch)** — alarms + dashboard for error rates

---

## 📹 Demo

- **Short video (60–90s):** [Add your link here: YouTube / Google Drive / LinkedIn]  
  _(Shows: `git push` → GitHub Actions → S3 sync → CloudFront invalidation → updated site)_

---

## 📂 Project Structure

```
.
├── infra/                   # Terraform code (S3, CloudFront, Alarms)
├── site/                    # Static site content (index.html, assets)
├── .github/workflows/       # CI/CD pipeline
│   └── deploy.yml
├── docs/images/             # Screenshots for README
└── README.md
```

---

## 🚀 Quick Start (Deploy It Yourself)

> ⚠️ Intended for demo only — build, record, then `terraform destroy` to keep costs ~₹0.

```bash
# Setup
aws configure   # region: ap-south-1

cd infra
terraform init
terraform apply -auto-approve

# Upload content
CF_URL=$(terraform -chdir=. output -raw cloudfront_domain_name)
BUCKET=$(terraform -chdir=. output -raw bucket_name)
cd ..
aws s3 sync site/ s3://$BUCKET/ --delete
echo "Open CloudFront: https://$CF_URL"
```

---

## 🔁 CI/CD with GitHub Actions

- Repo secrets required:  
  `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `S3_BUCKET`, `CLOUDFRONT_DISTRIBUTION_ID`

- Workflow: `.github/workflows/deploy.yml`

```yaml
name: Deploy static site to S3 + CloudFront
on:
  push:
    branches: [ "main" ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}
      - run: aws s3 sync site/ s3://$S3_BUCKET/ --delete
        env: { S3_BUCKET: ${{ secrets.S3_BUCKET }} }
      - run: aws cloudfront create-invalidation --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" --paths "/*"
        env: { CLOUDFRONT_DISTRIBUTION_ID: ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }} }
```

---

## 📈 Monitoring

- **CloudWatch Alarms** → 4xx/5xx error rates  
- **Optional Dashboard** → Requests, 4xx/5xx trends  
- View in **us-east-1 (N. Virginia)** region

---

## 🧹 Teardown

```bash
cd infra
terraform destroy -auto-approve
```

---

## 🖼️ Screenshots

| Stage | Screenshot |
|-------|------------|
| GitHub Actions success | ![Actions](docs/images/01_actions_success.png) |
| Updated CloudFront page | ![CloudFront](docs/images/02_cloudfront_live.png) |
| CloudWatch requests | ![Requests](docs/images/03_cw_requests.png) |
| CloudWatch errors | ![Errors](docs/images/04_cw_errors.png) |
| AWS resources (S3, CloudFront) | ![Resources](docs/images/05_aws_resources.png) |

---

## 💡 Why This Is Industry-Grade

- **Security** → Private S3 + OAC, no public ACLs, SSE  
- **IaC** → Full infra defined in Terraform  
- **Automation** → CI/CD pipeline, cache invalidation  
- **Observability** → Alarms & dashboards for CloudFront  
- **Cost Control** → Built → Demoed → Destroyed

---

## 🗣️ Interview Talking Points

- OAC vs OAI vs public bucket — why OAC is best practice now  
- Cache invalidation strategy & TTLs for static assets  
- Terraform lifecycle: init, plan, apply, destroy  
- CI/CD workflow separation (plan vs apply) in larger teams  
- Cost optimization (build/destroy cycles, budgets)

---

## 📜 License
MIT
