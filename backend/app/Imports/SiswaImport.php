<?php

namespace App\Imports;

use App\Models\Siswa;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class SiswaImport implements ToCollection, WithHeadingRow
{
    public int $inserted = 0;
    public int $updated = 0;

    public function collection(Collection $rows): void
    {
        foreach ($rows as $row) {
            $nama = trim((string) ($row['nama_siswa'] ?? ''));
            $kelas = (int) ($row['kelas'] ?? 0);

            if ($nama === '' || $kelas < 7 || $kelas > 12) {
                continue;
            }

            $existing = Siswa::query()
                ->where('nama_siswa', $nama)
                ->where('kelas', $kelas)
                ->first();

            if ($existing) {
                $existing->touch();
                $this->updated++;
                continue;
            }

            Siswa::query()->create([
                'nama_siswa' => $nama,
                'kelas' => $kelas,
            ]);
            $this->inserted++;
        }
    }
}

