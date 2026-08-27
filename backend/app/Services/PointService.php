<?php

namespace App\Services;

use App\Models\Point;
use App\Repositories\Contracts\PointRepositoryInterface;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

class PointService
{
    public function __construct(private readonly PointRepositoryInterface $pointRepository)
    {
    }

    public function paginate(array $filters): LengthAwarePaginator
    {
        return $this->pointRepository->paginate($filters);
    }

    public function findOrFail(int $id): Point
    {
        return $this->pointRepository->findOrFail($id);
    }

    public function bySiswa(int $siswaId): Collection
    {
        return $this->pointRepository->bySiswa($siswaId);
    }

    public function create(array $data, int $inputBy): Point
    {
        [$positif, $negatif] = $this->normalizePoint($data);
        $data['tanggal'] = $data['tanggal'] ?? now()->toDateString();
        $data['kategori'] = $data['kategori'] ?? 'Umum';
        $data['deskripsi'] = $data['deskripsi'] ?? '-';
        $data['point_positif'] = $positif;
        $data['point_negatif'] = $negatif;
        $data['input_by'] = $inputBy;
        return $this->pointRepository->create($data);
    }

    public function update(int $id, array $data): Point
    {
        $point = $this->findOrFail($id);
        [$positif, $negatif] = $this->normalizePoint($data);
        $data['tanggal'] = $data['tanggal'] ?? $point->tanggal?->format('Y-m-d') ?? now()->toDateString();
        $data['kategori'] = $data['kategori'] ?? $point->kategori ?? 'Umum';
        $data['deskripsi'] = $data['deskripsi'] ?? $point->deskripsi ?? '-';
        $data['point_positif'] = $positif;
        $data['point_negatif'] = $negatif;
        return $this->pointRepository->update($point, $data);
    }

    public function delete(int $id): void
    {
        $point = $this->findOrFail($id);
        $this->pointRepository->delete($point);
    }

    private function normalizePoint(array $data): array
    {
        $positif = (int) ($data['point_positif'] ?? 0);
        $negatif = (int) ($data['point_negatif'] ?? 0);
        if ($positif > 0) {
            $negatif = 0;
        } elseif ($negatif > 0) {
            $positif = 0;
        }
        return [$positif, $negatif];
    }
}
