#!/bin/bash

curl \
  --header "Authorization: Bearer ${token}" \
  https://app.terraform.io/api/v2/organizations/${organization}/oauth-tokens
