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

###
##
#

function vault_operator_init {
    set -e
    echo -n "" > "${dir_this}/init.text"
    chmod 600 "${dir_this}/init.text"
    vault operator init > "${dir_this}/init.text" || true
    cat "${dir_this}/init.text"

    #echo "WARNING:$( basename "${0}" ):${LINENO}: _/\__/\__/\__/\__/\__/\__/\__/\_" >&2
    #echo 'Unseal Key 1: HdxYEzEdDvjzbKUnyIzxiQlYoOzLusEYskxTtfg9P/Wm
#Unseal Key 2: uc4uQNjAYauNHqTkL4IAxG/VuDRMdNPw1fSeAAX/5FbI
#Unseal Key 3: kCnZFoRTO5WtirRl4c4eG2C1ovY0sNDNHr1H6u10GrGp
#Unseal Key 4: UMBsSEz5U8ywh8Uo8aNHzNQHfwjII7khEEqbrK8PIx5G
#Unseal Key 5: MUdQPAVgJp0FVXxkW5BJPhXzNFqFcuvNlLe8wgg4YP/B

#Initial Root Token: s.THbbRJ8clVZVl6Afh7VQ00i1

#Vault initialized with 5 key shares and a key threshold of 3. Please securely
#distribute the key shares printed above. When the Vault is re-sealed,
#restarted, or stopped, you must supply at least 3 of these keys to unseal it
#before it can start servicing requests.

#Vault does not store the generated master key. Without at least 3 key to
#reconstruct the master key, Vault will remain permanently sealed!

#It is possible to generate new unseal keys, provided you have a quorum of
#existing unseal keys shares. See "vault operator rekey" for more information.
#'
}

###
##
#

declare -r regex_token_unseal='^Unseal Key [0-9]*:[[:space:]]'
declare -r regex_token_root='^Initial Root Token:[[:space:]]'

declare -a token_unseal_pool=()
declare    token_root=""


while read str_in ; do
    t="$( awk '{print $4}' <<< "${str_in}" )"
    if [[ "${str_in}" =~ $regex_token_unseal ]] ; then
        token_unseal_pool+=("$t")
    elif [[ "${str_in}" =~ $regex_token_root ]] ; then
        token_root="${t}"
    fi
done <<< "$( vault_operator_init )"


token_pool_json="
{
    \"tokens\": {
        \"unseal\": [
            \"${token_unseal_pool[0]}\",
            \"${token_unseal_pool[1]}\",
            \"${token_unseal_pool[2]}\",
            \"${token_unseal_pool[3]}\",
            \"${token_unseal_pool[4]}\"
        ],
        \"root\": \"${token_root}\"
    }
}"

echo "${token_pool_json}" | jq
echo -n > "${dir_this}/tokens.json"
chmod 600 "${dir_this}/tokens.json"
echo "${token_pool_json}" >> "${dir_this}/tokens.json"

set +x
echo "INFO:$( basename "${0}" ):${LINENO}: Job done." >&2
echo "" >&2
