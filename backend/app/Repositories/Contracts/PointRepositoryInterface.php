<?php

namespace App\Repositories\Contracts;

use App\Models\Point;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

interface PointRepositoryInterface
{
    public function paginate(array $filters): LengthAwarePaginator;
    public function findOrFail(int $id): Point;
    public function create(array $data): Point;
    public function update(Point $point, array $data): Point;
    public function delete(Point $point): void;
    public function bySiswa(int $siswaId): Collection;
}

