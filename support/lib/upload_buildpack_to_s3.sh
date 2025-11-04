#!/usr/bin/env bash

s3_upload() {
	# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-object.html
	bucket="${1}"
	file="${2}"
	key="${3}"
	cli_major_version=$(awscli_major_version)

	if [[ "$cli_major_version" -eq 1 ]]; then
		aws s3api put-object --acl "public-read" --body "${file}" \
			--bucket "${bucket}" --key "${key}"
	elif [[ "$cli_major_version" -eq 2 ]]; then
		aws s3 mv "${file}" "s3://${bucket}/${key}" --acl "public-read"
	else
		echo "Unsupported AWS CLI major version ($cli_major_version)" >&2
		exit 1
	fi
}
