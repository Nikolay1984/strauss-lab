# Strauss Lab

PoC for isolating Composer dependencies in WordPress MU plugins with Strauss.

## Goal

Validate that default WordPress MU plugins can isolate Composer dependencies by moving vendor packages into plugin-specific prefixed namespaces.

## Plugins

Two MU plugins use different versions of the same Composer package:

- plugin-a uses psr/log 1.1.4
- plugin-b uses psr/log 3.0.2

## Build model

Strauss is not installed as a plugin dependency.

Strauss is expected to be installed globally on the deploy/build server and available at:

/usr/local/bin/strauss

Composer hooks run the prefixing step automatically:

composer install --working-dir="${ComposerJsonDir}" --optimize-autoloader --no-dev

## Source code rule

Strauss must not rewrite plugin source files.

The configuration uses:

update_call_sites: false

Plugin developers are responsible for their own source code architecture and imports.

## Runtime rule

Production runtime must require only:

- plugin-a/vendor-prefixed/autoload.php
- plugin-b/vendor-prefixed/autoload.php

Do not require regular vendor/autoload.php in production plugin bootstrap.

## Expected isolation result

After Strauss prefixing, vendor classes are available under plugin-specific namespaces:

- StraussLab\PluginA\Vendor\Psr\Log\LoggerInterface
- StraussLab\PluginB\Vendor\Psr\Log\LoggerInterface

The global Psr\Log\LoggerInterface must not be loaded by vendor-prefixed/autoload.php.
