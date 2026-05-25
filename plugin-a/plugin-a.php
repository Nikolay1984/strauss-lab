<?php

declare(strict_types=1);

/**
 * Plugin Name: Strauss Lab A
 * Description: Test plugin A with prefixed psr/log 1.x dependency.
 */

require_once __DIR__ . '/vendor-prefixed/autoload.php';

add_action('admin_notices', static function (): void {
    $interface = \StraussLab\PluginA\Vendor\Psr\Log\LoggerInterface::class;

    if (!interface_exists($interface)) {
        echo '<div class="notice notice-error"><p><strong>Strauss Lab A:</strong> prefixed LoggerInterface not found.</p></div>';

        return;
    }

    $method = new ReflectionMethod($interface, 'emergency');

    $messageParameter = $method->getParameters()[0] ?? null;

    $messageType = $messageParameter !== null && $messageParameter->hasType() ? (string)$messageParameter->getType() : 'none';

    $returnType = $method->hasReturnType() ? (string)$method->getReturnType() : 'none';

    echo '<div class="notice notice-success"><p>';
    echo '<strong>Strauss Lab A:</strong> ';
    echo 'class = <code>' . esc_html($interface) . '</code>; ';
    echo 'message type = <code>' . esc_html($messageType) . '</code>; ';
    echo 'return type = <code>' . esc_html($returnType) . '</code>';
    echo '</p></div>';
});
