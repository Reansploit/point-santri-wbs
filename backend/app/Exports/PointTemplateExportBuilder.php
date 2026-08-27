<?php

namespace App\Exports;

use App\Models\Siswa;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;

class PointTemplateExportBuilder
{
    public function build(array $filters = []): Spreadsheet
    {
        $templateCandidates = [
            dirname(base_path()) . DIRECTORY_SEPARATOR . 'point-kelas-10 (1).xlsx',
            dirname(base_path()) . DIRECTORY_SEPARATOR . 'point-bulanan.xlsx',
        ];

        $templatePath = null;
        foreach ($templateCandidates as $candidate) {
            if (file_exists($candidate)) {
                $templatePath = $candidate;
                break;
            }
        }

        if ($templatePath) {
            $spreadsheet = IOFactory::load($templatePath);
        } else {
            $spreadsheet = new Spreadsheet();
            $sheet = $spreadsheet->getActiveSheet();
            $sheet->setCellValue('A1', 'كشف الدرجات لقسم النتائج');
            $sheet->setCellValue('A4', 'Tanggal');
            $sheet->setCellValue('B4', 'Nama Siswa');
            $sheet->setCellValue('C4', 'Kelas');
            $sheet->setCellValue('D4', 'Kategori');
            $sheet->setCellValue('E4', 'Deskripsi');
            $sheet->setCellValue('F4', 'Point Positif');
            $sheet->setCellValue('G4', 'Point Negatif');
            $sheet->setCellValue('H4', 'Total');
        }

        $sheet = $spreadsheet->getActiveSheet();
        $sheet->setCellValue('A2', 'Tanggal export: ' . now()->format('Y-m-d H:i'));

        $rows = Siswa::query()
            ->when($filters['kelas'] ?? null, fn ($q, $kelas) => $q->where('kelas', $kelas))
            ->withSum('points as total_positif', 'point_positif')
            ->withSum('points as total_negatif', 'point_negatif')
            ->orderBy('kelas')
            ->orderBy('nama_siswa')
            ->get();

        $startRow = 5;
        foreach ($rows as $index => $row) {
            $excelRow = $startRow + $index;
            $positif = (int) ($row->total_positif ?? 0);
            $negatif = (int) ($row->total_negatif ?? 0);
            $sheet->setCellValue("A{$excelRow}", '-');
            $sheet->setCellValue("B{$excelRow}", $row->nama_siswa);
            $sheet->setCellValue("C{$excelRow}", $row->kelas);
            $sheet->setCellValue("D{$excelRow}", '-');
            $sheet->setCellValue("E{$excelRow}", '-');
            $sheet->setCellValue("F{$excelRow}", $positif);
            $sheet->setCellValue("G{$excelRow}", $negatif);
            $sheet->setCellValue("H{$excelRow}", $positif - $negatif);
        }

        return $spreadsheet;
    }
}
