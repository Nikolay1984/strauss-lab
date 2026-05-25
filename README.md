# Strauss Lab

PoC for isolating Composer dependencies in WordPress MU plugins with Strauss.

## Result

Two MU plugins use different versions of the same Composer package:

- plugin-a uses psr/log 1.x
- plugin-b uses psr/log 3.x

After Strauss prefixing:

- plugin-a uses StraussLab\PluginA\Vendor\Psr\Log\LoggerInterface
- plugin-b uses StraussLab\PluginB\Vendor\Psr\Log\LoggerInterface

The global Psr\Log\LoggerInterface is not loaded when only vendor-prefixed/autoload.php files are required.

## Runtime rule

Production runtime must require only:

- plugin-a/vendor-prefixed/autoload.php
- plugin-b/vendor-prefixed/autoload.php

Do not require regular vendor/autoload.php in production plugin bootstrap.
