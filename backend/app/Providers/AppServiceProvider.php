<?php

namespace App\Providers;

use App\Http\Middleware\RoleMiddleware;
use App\Repositories\Contracts\PointRepositoryInterface;
use App\Repositories\Contracts\SiswaRepositoryInterface;
use App\Repositories\Eloquent\PointRepository;
use App\Repositories\Eloquent\SiswaRepository;
use Illuminate\Routing\Router;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->bind(SiswaRepositoryInterface::class, SiswaRepository::class);
        $this->app->bind(PointRepositoryInterface::class, PointRepository::class);
    }

    public function boot(Router $router): void
    {
        $router->aliasMiddleware('role', RoleMiddleware::class);
    }
}

