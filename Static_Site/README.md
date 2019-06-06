This terraform project is designed to deliver a static website in a scalable manner, with HTTPS only, and HTTP requests being redirected to HTTPS.

The design of this delivery method is:
*S3 Bucket for Storage
*Cloudfront for distributed distribution

This design allows us to be incredibly scalable and fault tolerant by leveraging AWS Cloudfront's distributed endpoints.

The above design can be seen visually by viewing the "diagram.png"

A credentials file will have to be created in this directory, with the aws credentials file format of:

[profilename]
aws_access_key_id=XYZ
aws_secret_access_key=ABC

the profile variable will have to be populated in the AWS provider if the profile name is anything other than "default"

This terraform script works in the following steps:

1. Create a public access S3 bucket and store our content here
2. Create an ACM SSL certificate for our domain with a DNS validation method
3. Create DNS records in route53 hosted zone for SSL cert validation
4. Trigger ACM Certificate validation once DNS records are created
5. Create a cloudfront distribution targeting the S3 bucket with the index.html as the data