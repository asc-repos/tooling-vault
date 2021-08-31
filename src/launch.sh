#!/bin/bash

##
#
# The MIT License (MIT)
# Copyright © 2021 ASC
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files
# (the “Software”), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
# THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -xeu

declare -r dir_this="$( dirname "${0}" )"

for file_exe in vault jq docker docker-compose ; do
    which "${file_exe}"
done

cd "${dir_this}"  # Compose file is using relative path and this 'cd' is critical for 'docker-compose'.

sudo docker-compose \
    --file "${dir_this}/docker-compose.yaml" \
    --project-name vault-poc \
    up \
    --detach
trap "sudo docker-compose \
            --file ${dir_this}/docker-compose.yaml \
            --project-name vault-poc \
            down \
        ; sudo docker rm --force vault-poc_vault_1" \
            EXIT KILL QUIT STOP TERM ABRT INT
#sudo docker-compose logs -f vault
set +x
echo "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░" >&2
echo "INFO:$( basename "${0}" ):${LINENO}: Init how to:" >&2
echo "bash '${dir_this}/init.sh'" >&2
echo "bash '${dir_this}/unseal.sh'" >&2
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓" >&2
set -x
sudo docker logs -f vault-poc_vault_1