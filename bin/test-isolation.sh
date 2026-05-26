#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "${ROOT_DIR}"

echo "== Checking Strauss PHAR =="
/usr/local/bin/strauss.phar --version

echo "== Cleaning generated directories =="
rm -rf plugin-a/vendor plugin-a/vendor-prefixed plugin-b/vendor plugin-b/vendor-prefixed

echo "== Installing Plugin A =="
composer install --working-dir="plugin-a" --optimize-autoloader --no-dev

echo "== Installing Plugin B =="
composer install --working-dir="plugin-b" --optimize-autoloader --no-dev

echo "== Checking vendor-prefixed autoload files =="
test -f plugin-a/vendor-prefixed/autoload.php
test -f plugin-b/vendor-prefixed/autoload.php

echo "== Checking source files were not rewritten =="
grep -q 'use Psr\\Log\\LoggerInterface;' plugin-a/src/Tester.php
grep -q 'use Psr\\Log\\LoggerInterface;' plugin-b/src/Tester.php

echo "== Checking prefixed interfaces exist =="
php -r "require 'plugin-a/vendor-prefixed/autoload.php'; require 'plugin-b/vendor-prefixed/autoload.php'; exit(interface_exists('StraussLab\\PluginA\\Vendor\\Psr\\Log\\LoggerInterface') && interface_exists('StraussLab\\PluginB\\Vendor\\Psr\\Log\\LoggerInterface') ? 0 : 1);"

echo "== Checking global Psr\\Log is not loaded =="
php -r "require 'plugin-a/vendor-prefixed/autoload.php'; require 'plugin-b/vendor-prefixed/autoload.php'; exit(interface_exists('Psr\\Log\\LoggerInterface', false) ? 1 : 0);"

echo "== Checking isolated versions are different =="
php -r "require 'plugin-a/vendor-prefixed/autoload.php'; require 'plugin-b/vendor-prefixed/autoload.php'; \$a = new ReflectionMethod('StraussLab\\PluginA\\Vendor\\Psr\\Log\\LoggerInterface', 'emergency'); \$b = new ReflectionMethod('StraussLab\\PluginB\\Vendor\\Psr\\Log\\LoggerInterface', 'emergency'); \$ap = \$a->getParameters()[0] ?? null; \$bp = \$b->getParameters()[0] ?? null; \$aMessage = \$ap && \$ap->hasType() ? (string) \$ap->getType() : 'none'; \$aReturn = \$a->hasReturnType() ? (string) \$a->getReturnType() : 'none'; \$bMessage = \$bp && \$bp->hasType() ? (string) \$bp->getType() : 'none'; \$bReturn = \$b->hasReturnType() ? (string) \$b->getReturnType() : 'none'; exit(\$aMessage === 'none' && \$aReturn === 'none' && \$bMessage === 'Stringable|string' && \$bReturn === 'void' ? 0 : 1);"

echo "== OK: Strauss dependency isolation works =="
