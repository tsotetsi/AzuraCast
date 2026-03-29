<?php

declare(strict_types=1);

namespace App\Container;

use DI\Attribute\Inject;
use Psr\Log\LoggerInterface;

trait LoggerAwareTrait
{
    protected LoggerInterface $logger;

    #[Inject]
    public function setLogger(LoggerInterface $logger): void
    {
        $this->logger = $logger;
    }

    public function getLogger(): LoggerInterface
    {
        return $this->logger;
    }
}