# Flutter library

Collection of common functionalities.

# Getting Started

## Environment variables

* `baseUrl` -> Sets the api base url.
* `s3BaseUrl` -> Sets the base url for amazon s3 bucket.

Usage:

`flutter <options/flags> --dart-define=baseUrl=<base_url> --dart-define=s3BaseUrl=<s3_base_url>`

To customize the above command, replace `<...>`.

## iOS certificates, provisioning profiles.

[Link to the drive folder](https://drive.google.com/drive/folders/1wF9Z7sNaCTo7_OL7qmnw6IoUELvGw6QM?usp=sharing)

# AmazonSNS BodyStructure

```json
{
  "GCM": "{ \"notification\": { \"body\": \"Sample message body.\", \"title\":\"Flutter library\" } }"
}
```