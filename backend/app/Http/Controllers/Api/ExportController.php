<?php

namespace App\Http\Controllers\Api;

use App\Exports\PointTemplateExportBuilder;
use App\Http\Controllers\Controller;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class ExportController extends Controller
{
    public function __construct(private readonly PointTemplateExportBuilder $builder)
    {
    }

    public function all()
    {
        return $this->downloadSpreadsheet($this->builder->build(), 'point-semua.xlsx');
    }

    public function kelas(int $kelas)
    {
        return $this->downloadSpreadsheet($this->builder->build(['kelas' => $kelas]), "point-kelas-{$kelas}.xlsx");
    }

    private function downloadSpreadsheet($spreadsheet, string $filename)
    {
        $writer = new Xlsx($spreadsheet);
        ob_start();
        $writer->save('php://output');
        $content = ob_get_clean();

        return response($content, 200, [
            'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
        ]);
    }
}
