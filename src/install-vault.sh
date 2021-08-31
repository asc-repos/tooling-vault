#!/bin/bash

##
#
# The MIT License (MIT)
# Copyright © 2021 ASC
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files
# (the “Software”), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

PS4="+:\${0}:\${LINENO}: "
set -xeu -o pipefail

which get-timestamp

declare -r version="${1:-1.8.2}"
test -n "${version}"
declare -r url_distro="https://releases.hashicorp.com/vault/${version}/vault_${version}_linux_amd64.zip"

declare -r dir_distro="/tmp/h-vault-distro/Vault"
declare -r dir_unzip="${dir_distro}/UnZip"
declare -r dir_install="/usr/local/bin"
declare -r file_distro="${dir_distro}/$( basename "${url_distro}" )"
declare -r file_bin="${dir_unzip}/vault"
declare -r bin_file_install="${dir_install}/vault-${version}"

if [ ! -e "${file_distro}" ] ; then
    curl -L -o "${file_distro}"  "${url_distro}"
fi

mkdir -p "${dir_unzip}"
unzip "${file_distro}" -d "${dir_unzip}"

sudo install \
        --mode=755 \
        --owner=root \
        --group=root \
        "${file_bin}" \
        "${bin_file_install}"

for bin_symlink in /usr/local/bin/vault /usr/bin/vault ; do
    sudo ln --force --symbolic "${bin_file_install}" "${bin_symlink}"
done

vault -autocomplete-install

set +x
echo "INFO:${0}:${LINENO}: Job done." >&2
echo "" >&2
