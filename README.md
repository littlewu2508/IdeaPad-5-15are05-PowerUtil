# Lenovo IdeaPad 5 15are05 Power Utility

This is a utility that can control power performance and battery mode under Linux. Similar for using Fn+Q on Windows platform.

It works for for Lenovo IdeaPad 5 15are05 like laptops, including Lenovo XiaoXin-15ARE 2020.

This sciprt is mainly a wrapper of https://wiki.archlinux.org/title/Lenovo_IdeaPad_5_15are05

## Installation

copy utility -> /usr/local/sbin/
copy bash-completion/utility -> /usr/local/share/bash-completion/completions

## Prerequest

1. Driver ideapad_acpi for cleanfan command. Should be exist in recent Linux kernels.
2. Dynamic kernel module [acpi_call](https://github.com/mkottman/acpi_call) for performance and battery adjusting. For debian based distos, there a package acpi-call-dkms providing this.

## Usage

`utility <cleanfan|get|set>`

`utility get <battery|performance>`

`utility set battery <conservation|normal|rapidcharge>`

`utility set performance <balance|conservation|extreme>`
