<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Point;
use App\Models\Siswa;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class RekapController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $kelas = $request->integer('kelas');
        $query = Siswa::query()
            ->withSum('points as total_positif', 'point_positif')
            ->withSum('points as total_negatif', 'point_negatif')
            ->withCount('points as total_input');
        if ($kelas) {
            $query->where('kelas', $kelas);
        }
        return response()->json($query->orderBy('kelas')->orderBy('nama_siswa')->get());
    }

    public function kelas(int $kelas): JsonResponse
    {
        return $this->index(new Request(['kelas' => $kelas]));
    }

    public function siswa(int $id): JsonResponse
    {
        $siswa = Siswa::query()
            ->with(['points' => fn ($q) => $q->latest('tanggal')])
            ->withSum('points as total_positif', 'point_positif')
            ->withSum('points as total_negatif', 'point_negatif')
            ->withCount('points as total_input')
            ->findOrFail($id);
        return response()->json($siswa);
    }

    public function statistik(): JsonResponse
    {
        $topBase = Siswa::query()
            ->leftJoin('points', 'points.siswa_id', '=', 'siswa.id')
            ->select('siswa.id', 'siswa.nama_siswa', 'siswa.kelas')
            ->selectRaw('coalesce(sum(points.point_positif), 0) as total_positif')
            ->selectRaw('coalesce(sum(points.point_negatif), 0) as total_negatif')
            ->groupBy('siswa.id', 'siswa.nama_siswa', 'siswa.kelas');

        $stats = [
            'total_siswa' => Siswa::query()->count(),
            'total_point_positif' => (int) Point::query()->sum('point_positif'),
            'total_point_negatif' => (int) Point::query()->sum('point_negatif'),
            'total_input_point' => Point::query()->count(),
            'per_kelas' => Siswa::query()
                ->select('kelas')
                ->selectRaw('count(*) as jumlah_siswa')
                ->selectRaw('coalesce(sum(points.point_positif), 0) as total_positif')
                ->selectRaw('coalesce(sum(points.point_negatif), 0) as total_negatif')
                ->selectRaw('count(points.id) as jumlah_input_point')
                ->leftJoin('points', 'points.siswa_id', '=', 'siswa.id')
                ->groupBy('kelas')
                ->orderBy('kelas')
                ->get(),
            'kategori' => Point::query()
                ->select('kategori', DB::raw('count(*) as total'))
                ->groupBy('kategori')
                ->orderByDesc('total')
                ->get(),
            'top_global_negatif' => (clone $topBase)
                ->orderByDesc('total_negatif')
                ->orderBy('nama_siswa')
                ->limit(10)
                ->get(),
            'top_global_positif' => (clone $topBase)
                ->orderByDesc('total_positif')
                ->orderBy('nama_siswa')
                ->limit(10)
                ->get(),
            'top_per_angkatan_negatif' => collect(range(7, 12))->mapWithKeys(function ($kelas) use ($topBase) {
                return [
                    (string) $kelas => (clone $topBase)
                        ->where('kelas', $kelas)
                        ->orderByDesc('total_negatif')
                        ->orderBy('nama_siswa')
                        ->limit(10)
                        ->get(),
                ];
            }),
            'top_per_angkatan_positif' => collect(range(7, 12))->mapWithKeys(function ($kelas) use ($topBase) {
                return [
                    (string) $kelas => (clone $topBase)
                        ->where('kelas', $kelas)
                        ->orderByDesc('total_positif')
                        ->orderBy('nama_siswa')
                        ->limit(10)
                        ->get(),
                ];
            }),
        ];

        return response()->json($stats);
    }
}
