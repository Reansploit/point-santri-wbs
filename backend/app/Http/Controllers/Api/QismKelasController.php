<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Siswa;
use Illuminate\Http\JsonResponse;

class QismKelasController extends Controller
{
    public function show(int $kelas): JsonResponse
    {
        $items = Siswa::query()
            ->withSum('points as total_positif', 'point_positif')
            ->withSum('points as total_negatif', 'point_negatif')
            ->withCount('points as total_input')
            ->where('kelas', $kelas)
            ->orderBy('nama_siswa')
            ->get();

        return response()->json($items);
    }
}

