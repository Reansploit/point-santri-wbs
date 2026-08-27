<?php

namespace App\Repositories\Eloquent;

use App\Models\Point;
use App\Repositories\Contracts\PointRepositoryInterface;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

class PointRepository implements PointRepositoryInterface
{
    public function paginate(array $filters): LengthAwarePaginator
    {
        return Point::query()
            ->with('siswa')
            ->when($filters['siswa_id'] ?? null, fn ($q, $siswaId) => $q->where('siswa_id', $siswaId))
            ->when($filters['kategori'] ?? null, fn ($q, $kategori) => $q->where('kategori', $kategori))
            ->when($filters['tanggal'] ?? null, fn ($q, $tanggal) => $q->whereDate('tanggal', $tanggal))
            ->latest('tanggal')
            ->paginate($filters['per_page'] ?? 10);
    }

    public function findOrFail(int $id): Point
    {
        return Point::query()->with('siswa')->findOrFail($id);
    }

    public function create(array $data): Point
    {
        return Point::query()->create($data);
    }

    public function update(Point $point, array $data): Point
    {
        $point->update($data);
        return $point->refresh()->load('siswa');
    }

    public function delete(Point $point): void
    {
        $point->delete();
    }

    public function bySiswa(int $siswaId): Collection
    {
        return Point::query()->where('siswa_id', $siswaId)->latest('tanggal')->get();
    }
}
