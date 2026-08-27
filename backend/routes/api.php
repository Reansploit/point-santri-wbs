<?php

use App\Http\Controllers\Api\AdminMaintenanceController;
use App\Http\Controllers\Api\AdminSiswaController;
use App\Http\Controllers\Api\AdminUserController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ExportController;
use App\Http\Controllers\Api\QismKelasController;
use App\Http\Controllers\Api\QismPointController;
use App\Http\Controllers\Api\RekapController;
use Illuminate\Support\Facades\Route;

Route::prefix('auth')->group(function () {
    Route::post('/login', [AuthController::class, 'login']);
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me', [AuthController::class, 'me']);
    });
});

Route::middleware(['auth:sanctum', 'role:admin'])->prefix('admin')->group(function () {
    Route::get('/siswa', [AdminSiswaController::class, 'index']);
    Route::post('/siswa', [AdminSiswaController::class, 'store']);
    Route::post('/siswa/import', [AdminSiswaController::class, 'import']);
    Route::get('/siswa/{id}', [AdminSiswaController::class, 'show']);
    Route::put('/siswa/{id}', [AdminSiswaController::class, 'update']);
    Route::delete('/siswa/{id}', [AdminSiswaController::class, 'destroy']);
    Route::get('/siswa/kelas/{kelas}', [AdminSiswaController::class, 'byKelas']);
    Route::post('/points/clear', [AdminMaintenanceController::class, 'clearPoints']);
    Route::post('/siswa/clear', [AdminMaintenanceController::class, 'clearSiswa']);
    Route::get('/users', [AdminUserController::class, 'index']);
    Route::post('/users', [AdminUserController::class, 'store']);
    Route::put('/users/{id}', [AdminUserController::class, 'update']);
    Route::put('/users/{id}/password', [AdminUserController::class, 'updatePassword']);
    Route::delete('/users/{id}', [AdminUserController::class, 'destroy']);
});

Route::middleware(['auth:sanctum', 'role:qism'])->prefix('qism')->group(function () {
    Route::get('/kelas/{kelas}', [QismKelasController::class, 'show']);

    Route::get('/point', [QismPointController::class, 'index']);
    Route::post('/point', [QismPointController::class, 'store']);
    Route::get('/point/{id}', [QismPointController::class, 'show']);
    Route::put('/point/{id}', [QismPointController::class, 'update']);
    Route::delete('/point/{id}', [QismPointController::class, 'destroy']);

    Route::get('/rekap', [RekapController::class, 'index']);
    Route::get('/rekap/kelas/{kelas}', [RekapController::class, 'kelas']);
    Route::get('/rekap/siswa/{id}', [RekapController::class, 'siswa']);
    Route::get('/statistik', [RekapController::class, 'statistik']);

    Route::get('/export/all', [ExportController::class, 'all']);
    Route::get('/export/kelas/{kelas}', [ExportController::class, 'kelas']);
});
