<?php

namespace App\Services;

use App\Models\Siswa;
use App\Repositories\Contracts\SiswaRepositoryInterface;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

class SiswaService
{
    public function __construct(private readonly SiswaRepositoryInterface $siswaRepository)
    {
    }

    public function paginate(array $filters): LengthAwarePaginator
    {
        return $this->siswaRepository->paginate($filters);
    }

    public function byKelas(int $kelas): Collection
    {
        return $this->siswaRepository->byKelas($kelas);
    }

    public function findOrFail(int $id): Siswa
    {
        return $this->siswaRepository->findOrFail($id);
    }

    public function create(array $data): Siswa
    {
        return $this->siswaRepository->create($data);
    }

    public function update(int $id, array $data): Siswa
    {
        $siswa = $this->findOrFail($id);
        return $this->siswaRepository->update($siswa, $data);
    }

    public function delete(int $id): void
    {
        $siswa = $this->findOrFail($id);
        $this->siswaRepository->delete($siswa);
    }
}

