<?php

namespace App\Exports;

use App\Models\Point;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class PointExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    public function __construct(private readonly array $filters = [])
    {
    }

    public function collection()
    {
        return Point::query()
            ->with('siswa')
            ->when($this->filters['kelas'] ?? null, fn ($q, $kelas) => $q->whereHas('siswa', fn ($sq) => $sq->where('kelas', $kelas)))
            ->when($this->filters['siswa_id'] ?? null, fn ($q, $siswaId) => $q->where('siswa_id', $siswaId))
            ->when($this->filters['month'] ?? null, fn ($q, $month) => $q->whereMonth('tanggal', $month))
            ->when($this->filters['year'] ?? null, fn ($q, $year) => $q->whereYear('tanggal', $year))
            ->orderBy('tanggal')
            ->get();
    }

    public function headings(): array
    {
        return ['Tanggal', 'Nama Siswa', 'Kelas', 'Kategori', 'Deskripsi', 'Point Positif', 'Point Negatif', 'Total'];
    }

    public function map($row): array
    {
        return [
            optional($row->tanggal)->format('Y-m-d'),
            $row->siswa?->nama_siswa,
            $row->siswa?->kelas,
            $row->kategori,
            $row->deskripsi,
            $row->point_positif,
            $row->point_negatif,
            $row->point_positif - $row->point_negatif,
        ];
    }

    public function styles(Worksheet $sheet): array
    {
        $sheet->setCellValue('A1', 'كشف الدرجات لقسم النتائج');
        $sheet->mergeCells('A1:H1');
        $sheet->setCellValue('A2', 'Tanggal export: ' . now()->format('Y-m-d H:i'));
        $sheet->mergeCells('A2:H2');
        $sheet->insertNewRowBefore(3, 1);

        return [
            1 => ['font' => ['bold' => true, 'size' => 14]],
            4 => ['font' => ['bold' => true]],
        ];
    }
}

