# S3 Bucket
resource "aws_s3_bucket" "website" {
  bucket = "nazneen-terraform-bucket-123"
  force_destroy = true
}

# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 Bucket Policy to allow public access
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# Upload index.html
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"
  content = <<EOT
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome Nazneen!</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #a1c4fd, #c2e9fb);
            color: #333;
            text-align: center;
            padding: 50px;
        }
        h1 {
            color: #ff4b5c;
            font-size: 48px;
        }
        p {
            font-size: 20px;
        }
        .footer {
            margin-top: 50px;
            font-size: 14px;
            color: #555;
        }
    </style>
</head>
<body>
    <h1>Hello, Nazneen!</h1>
    <p>Welcome to your Terraform-powered AWS S3 website.</p>
    <p>Everything is deployed automatically and live now!</p>
    <div class="footer">
        &copy; 2025 Nazneen Zahra
    </div>
</body>
</html>
EOT
  content_type = "text/html"
}
