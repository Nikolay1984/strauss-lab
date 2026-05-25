<?php

declare(strict_types=1);

namespace StraussLab\PluginA;

use StraussLab\PluginA\Vendor\Psr\Log\LoggerInterface;

final class Tester
{
    public static function loggerInterface(): string
    {
        return LoggerInterface::class;
    }
}
