<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Point;
use App\Models\Siswa;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class AdminMaintenanceController extends Controller
{
    /**
     * Hapus seluruh record point. Data siswa & akun tetap aman.
     */
    public function clearPoints(): JsonResponse
    {
        $deleted = DB::transaction(fn () => Point::query()->delete());

        return response()->json([
            'message' => 'Semua point berhasil dihapus',
            'deleted' => $deleted,
        ]);
    }

    /**
     * Hapus seluruh data siswa. Point siswa ikut terhapus via on delete cascade.
     * Akun (users) tidak dihapus.
     */
    public function clearSiswa(): JsonResponse
    {
        [$deleted, $pointsDeleted] = DB::transaction(function () {
            $pointsDeleted = Point::query()->count();
            $deleted = Siswa::query()->delete();

            return [$deleted, $pointsDeleted];
        });

        return response()->json([
            'message' => 'Semua data siswa berhasil dihapus',
            'deleted' => $deleted,
            'points_deleted' => $pointsDeleted,
        ]);
    }
}
