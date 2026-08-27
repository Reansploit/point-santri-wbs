<?php

namespace App\Repositories\Contracts;

use App\Models\Siswa;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

interface SiswaRepositoryInterface
{
    public function paginate(array $filters): LengthAwarePaginator;
    public function byKelas(int $kelas): Collection;
    public function findOrFail(int $id): Siswa;
    public function create(array $data): Siswa;
    public function update(Siswa $siswa, array $data): Siswa;
    public function delete(Siswa $siswa): void;
}

