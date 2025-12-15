#!/bin/bash -xe
#
# Simple test for genfatimage
#
# It needs one or more input directory trees to populate the image.
#

input="$1"
genfatimage="${GENFATIMAGE:-./genfatimage}"
TMPDIR="${TMPDIR:-/tmp}"
testdir="${TESTDIR:-${TMPDIR}/genfatimage-test.$$}"

mkdir -p "$testdir"
"$genfatimage" --flat -o "$testdir"/flat.img -- "$@"
"$genfatimage" --efi -o "$testdir"/efi.img -- "$@"
"$genfatimage" --mbr -o "$testdir"/mbr.img -- "$@"
"$genfatimage" --exfat=force --flat -o "$testdir"/exfat.img -- "$@"

fsck.vfat -nv "$testdir"/flat.img
fsck.exfat -nv "$testdir"/exfat.img
fdisk -l "$testdir"/mbr.img
printf 'p\ni\nv\n' | gdisk "$testdir"/efi.img
