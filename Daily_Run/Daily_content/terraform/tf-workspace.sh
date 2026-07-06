#!/bin/bash
# Switch or create workspace
terraform workspace select $1 2>/dev/null || terraform workspace new $1
