<?php

namespace App\Repositories\Eloquent;

use App\Models\Siswa;
use App\Repositories\Contracts\SiswaRepositoryInterface;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

class SiswaRepository implements SiswaRepositoryInterface
{
    public function paginate(array $filters): LengthAwarePaginator
    {
        return Siswa::query()
            ->when($filters['kelas'] ?? null, fn ($q, $kelas) => $q->where('kelas', $kelas))
            ->when($filters['search'] ?? null, fn ($q, $search) => $q->where('nama_siswa', 'ilike', "%{$search}%"))
            ->orderBy('nama_siswa')
            ->paginate($filters['per_page'] ?? 10);
    }

    public function byKelas(int $kelas): Collection
    {
        return Siswa::query()->where('kelas', $kelas)->orderBy('nama_siswa')->get();
    }

    public function findOrFail(int $id): Siswa
    {
        return Siswa::query()->findOrFail($id);
    }

    public function create(array $data): Siswa
    {
        return Siswa::query()->create($data);
    }

    public function update(Siswa $siswa, array $data): Siswa
    {
        $siswa->update($data);
        return $siswa->refresh();
    }

    public function delete(Siswa $siswa): void
    {
        $siswa->delete();
    }
}

