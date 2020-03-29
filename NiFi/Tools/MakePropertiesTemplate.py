#!/usr/bin/env python3
# Copyright (c) 2020 Regulus Data Services.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import click


@click.group()
def cli():
    pass


@cli.command()
@click.option(
    '--template',
    '-t',
    type=click.File('w'),
    required=True,
    help='Template config file to create.',
)
@click.option(
    '--configfile',
    '-c',
    type=click.File('r'),
    required=True,
    help='Config file to read. Can be used multiple times.'
)
@click.option(
    '--keypath',
    '-k',
    required=True,
    help='Keypath. This is the prefix to the full key in the KV store'
)
@click.option(
    '--kvseperator',
    '-s',
    default="=",
    help='What character separates keys from values. Defaults to "="'
)
@click.option(
    '--comment',
    '-m',
    default="#",
    help='What character denotes a linecomment. Defaults to "#"'
)
def mktemplate(template, configfile, kvseperator, keypath, comment):
    lines = []
    template.write('{{ $keypath := env "' + keypath + '" }}')
    template.write("\n")

    for line in configfile:
        lines.append(line)
        line = line.strip()
        if not line or line.startswith(comment):
            template.write(line + "\n")
            continue

        k, v = line.split(kvseperator, 1)
        v = '{{ keyOrDefault (print $keypath "' + k + '") ' + '"' + v + '" }}'

        template.write(k + "=" + v + "\n")

    return


def main():
    cli()
    return


main()
