#!/usr/bin/env bash

# This file contains functions based on AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) to manipulate S3 data
# Env vars requirement:
# - `AWS_ACCESS_KEY_ID`
# - `AWS_SECRET_ACCESS_KEY`
# - `AWS_SESSION_TOKEN`

# Stacks scalingo-22 and earlier have AWS CLI v1 installed.
# Starting with scalingo-24, AWS CLI v2 is installed.
awscli_major_version() {
	aws --version \
		| cut -d " " -f1 \
		| cut -d "/" -f2 \
		| cut -d "." -f1
}

s3_upload() {
	# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-object.html
	bucket="${1}"
	file="${2}"
	key="${3}"
	cli_major_version="$( awscli_major_version )"

	if [[ "${cli_major_version}" -eq 1 ]]; then
		aws s3api put-object --acl "public-read" --body "${file}" \
			--bucket "${bucket}" --key "${key}"
	elif [[ "${cli_major_version}" -eq 2 ]]; then
		aws s3 mv "${file}" "s3://${bucket}/${key}" --acl "public-read"
	else
		echo "Unsupported AWS CLI major version (${cli_major_version})" >&2
		exit 1
	fi
}
