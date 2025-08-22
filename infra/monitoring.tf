resource "aws_cloudwatch_dashboard" "main" {
  provider       = aws.use1
  dashboard_name = "devops-aws-cicd"
  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "metric",
        "x" : 0, "y" : 0, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "CloudFront Requests",
          "region" : "us-east-1",
          "view" : "timeSeries",
          "stat" : "Sum",
          "period" : 300,
          "metrics" : [
            ["AWS/CloudFront", "Requests", "DistributionId", aws_cloudfront_distribution.cdn.id, "Region", "Global"]
          ]
        }
      },
      {
        "type" : "metric",
        "x" : 0, "y" : 6, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "4xx / 5xx Error Rates",
          "region" : "us-east-1",
          "view" : "timeSeries",
          "stat" : "Average",
          "period" : 300,
          "metrics" : [
            ["AWS/CloudFront", "4xxErrorRate", "DistributionId", aws_cloudfront_distribution.cdn.id, "Region", "Global"],
            ["AWS/CloudFront", "5xxErrorRate", "DistributionId", aws_cloudfront_distribution.cdn.id, "Region", "Global"]
          ]
        }
      }
    ]
  })
}
