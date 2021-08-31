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

PS4="+:\$( basename \"\${0}\" ):\${LINENO}: "
set -xeu -o pipefail

declare -r dir_this="$( dirname "${0}" )"

source "${dir_this}/settings.sh"

while read token ; do
    vault operator unseal "${token}"
done <<< "$( cat "${dir_this}/tokens.json" | jq -r '.tokens.unseal[]' )"

vault status

set +x
echo "INFO:$( basename "${0}" ):${LINENO}: Job done." >&2
echo "" >&2
