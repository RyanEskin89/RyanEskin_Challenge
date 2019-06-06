provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "credentials"
}

//declaration of the domain name to be used
variable "domain" {
    default = "ryaneskin.com"
}


resource "aws_s3_bucket" "static_site" {
    bucket = "${var.domain}"
    acl = "public-read"
    tags = {
        Name = "Static_Content"
        Environment = "Prod"
    }
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"1",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.domain}/*"]
    }
  ]
}
POLICY

    website {
        index_document = "index.html"
    }
}

resource "aws_s3_bucket_object" "content" {
    bucket = "${aws_s3_bucket.static_site.bucket}"
    key = "index.html"
    source = "www/index.html"
    etag = "${filemd5("www/index.html")}"
    content_type = "text/html"
}

resource "aws_acm_certificate" "domain_cert" {
    domain_name = "${var.domain}"
    validation_method = "DNS"

    tags = {
        Domain = "${var.domain}"
        Environment = "Prod"
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_route53_record" "cert_validation" {
    name = "${aws_acm_certificate.domain_cert.domain_validation_options.0.resource_record_name}"
    type = "${aws_acm_certificate.domain_cert.domain_validation_options.0.resource_record_type}"
    zone_id = "Z1NFK5XA32KC1H"
    records = ["${aws_acm_certificate.domain_cert.domain_validation_options.0.resource_record_value}"]    
    ttl = 60
}

resource "aws_acm_certificate_validation" "domain_cert" {
  certificate_arn         = "${aws_acm_certificate.domain_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

resource "aws_cloudfront_distribution" "domain_distro" {
    origin {
        domain_name = "${aws_s3_bucket.static_site.bucket_regional_domain_name}"
        origin_id = "${var.domain}"
        //s3_origin_config {
        //    origin_access_identity = "${aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path}"
        //}
    }

    enabled = true
    default_root_object = "index.html"
    aliases = ["${var.domain}"]
    price_class = "PriceClass_100"

    default_cache_behavior {
        allowed_methods = ["HEAD", "GET"]
        cached_methods = ["HEAD", "GET"]
        target_origin_id = "${var.domain}"
        viewer_protocol_policy = "redirect-to-https"
        min_ttl = 0
        default_ttl = 86400

        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = false
        acm_certificate_arn = "${aws_acm_certificate_validation.domain_cert.certificate_arn}"
        ssl_support_method = "sni-only"
    }
}


resource "aws_route53_record" "domain_records" {
    zone_id = "Z1NFK5XA32KC1H"
    name = "${var.domain}"
    type = "A"

    alias {
        name = "${aws_cloudfront_distribution.domain_distro.domain_name}"
        zone_id = "${aws_cloudfront_distribution.domain_distro.hosted_zone_id}"
        evaluate_target_health = false
    }
}