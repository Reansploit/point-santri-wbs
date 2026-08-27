<?php

namespace App\Support;

use Illuminate\Support\Facades\Http;
use Throwable;

class DevHubBugReporter
{
    private const TIMEOUT_SECONDS = 9;
    private const DEDUPE_WINDOW_SECONDS = 60;
    private const MAX_TEXT_LENGTH = 4000;
    private const MAX_STACK_LENGTH = 6000;

    private static array $recentHashes = [];

    public static function report(array $payload): void
    {
        $endpoint = env('DEVHUB_BUG_ENDPOINT');
        $apiKey = env('DEVHUB_BUG_API_KEY');
        $sourceApp = env('DEVHUB_SOURCE_APP_NAME', config('app.name', 'unknown-source-app'));

        if (!$endpoint || !$apiKey) {
            logger()->warning('[DevHub Bug] Missing DEVHUB_BUG_ENDPOINT or DEVHUB_BUG_API_KEY.');
            return;
        }

        $normalized = self::normalizePayload($payload, $sourceApp);

        if (self::shouldThrottle($normalized)) {
            return;
        }

        try {
            Http::timeout(self::TIMEOUT_SECONDS)
                ->retry(2, 250)
                ->withHeaders([
                    'Content-Type' => 'application/json',
                    'x-devhub-api-key' => $apiKey,
                ])
                ->post($endpoint, $normalized);
        } catch (Throwable $exception) {
            logger()->warning('[DevHub Bug] Failed to send bug report: '.$exception->getMessage());
        }
    }

    public static function reportException(Throwable $exception, string $route = 'unknown'): void
    {
        $stack = $exception->getTraceAsString();

        self::report([
            'title' => 'Backend 5xx Error: '.class_basename($exception),
            'description' => self::truncate($exception->getMessage().' | '.$stack, self::MAX_STACK_LENGTH),
            'severity' => 'high',
            'route' => $route,
            'metadata' => [
                'exception' => get_class($exception),
                'code' => $exception->getCode(),
                'file' => $exception->getFile(),
                'line' => $exception->getLine(),
                'timestamp' => now()->toISOString(),
                'appVersion' => env('APP_VERSION', 'unknown'),
            ],
        ]);
    }

    private static function normalizePayload(array $payload, string $sourceApp): array
    {
        $title = self::sanitizeString((string) ($payload['title'] ?? ''));
        $description = self::truncate(self::sanitizeString((string) ($payload['description'] ?? '')), self::MAX_STACK_LENGTH);

        return [
            'title' => $title,
            'description' => $description,
            'sourceApp' => self::sanitizeString((string) ($payload['sourceApp'] ?? $sourceApp)),
            'severity' => $payload['severity'] ?? 'high',
            'reporter' => isset($payload['reporter']) ? self::sanitizeString((string) $payload['reporter']) : null,
            'route' => isset($payload['route']) ? self::sanitizeString((string) $payload['route']) : null,
            'screenshot' => isset($payload['screenshot']) ? self::sanitizeString((string) $payload['screenshot']) : null,
            'metadata' => self::sanitizeValue($payload['metadata'] ?? []),
        ];
    }

    private static function shouldThrottle(array $payload): bool
    {
        $hash = sha1(json_encode([
            'title' => $payload['title'] ?? '',
            'description' => $payload['description'] ?? '',
            'route' => $payload['route'] ?? '',
            'severity' => $payload['severity'] ?? '',
        ]) ?: '');

        $now = time();
        $last = self::$recentHashes[$hash] ?? null;

        if ($last && ($now - $last) < self::DEDUPE_WINDOW_SECONDS) {
            return true;
        }

        self::$recentHashes[$hash] = $now;

        foreach (self::$recentHashes as $key => $timestamp) {
            if (($now - $timestamp) > self::DEDUPE_WINDOW_SECONDS * 2) {
                unset(self::$recentHashes[$key]);
            }
        }

        return false;
    }

    private static function sanitizeValue(mixed $value): mixed
    {
        if (is_array($value)) {
            $sanitized = [];
            foreach ($value as $key => $item) {
                if (is_string($key) && preg_match('/(password|token|authorization|cookie|secret|api[_-]?key|credit[_-]?card|card[_-]?number)/i', $key)) {
                    $sanitized[$key] = '[REDACTED]';
                    continue;
                }

                $sanitized[$key] = self::sanitizeValue($item);
            }
            return $sanitized;
        }

        if (is_string($value)) {
            return self::sanitizeString($value);
        }

        return $value;
    }

    private static function sanitizeString(string $value): string
    {
        $redacted = preg_replace('/(bearer\s+[a-z0-9._-]+|password|token|authorization|cookie|secret|api[_-]?key|\b\d{13,19}\b)/i', '[REDACTED]', $value);
        return self::truncate($redacted ?? $value, self::MAX_TEXT_LENGTH);
    }

    private static function truncate(string $value, int $maxLength): string
    {
        if (strlen($value) <= $maxLength) {
            return $value;
        }

        return substr($value, 0, $maxLength).'...[truncated]';
    }
}
