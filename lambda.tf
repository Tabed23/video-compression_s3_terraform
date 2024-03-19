resource "aws_iam_role" "lambda_role" {
  name = "lambda-video-compression-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
    {
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }
  ]
})
}

resource "aws_iam_policy" "dynamodb_put_item" {
  name = "lambda_dynamodb_put_item_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": [
        "arn:aws:dynamodb:region1:account_id:table/tablename"
      ]
    }
  ]
}
EOF
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name          = "video_package_layer"
  s3_bucket           = aws_s3_bucket.lambda_bucket.id
  s3_key              = aws_s3_object.lambda_layer_zip.key

  compatible_runtimes = ["python3.12"]
}

resource "aws_lambda_function" "function" {
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_bkt.key
  timeout =  900
  memory_size =  1020
  function_name    = var.lambda_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  layers = [aws_lambda_layer_version.lambda_layer.arn]
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  ephemeral_storage {
    size = 1020
  }
}

data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "lambda/"
  output_path = "lambda.zip"
}
