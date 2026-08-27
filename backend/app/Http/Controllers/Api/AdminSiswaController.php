<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Imports\SiswaImport;
use App\Http\Requests\Siswa\SiswaStoreRequest;
use App\Http\Requests\Siswa\SiswaUpdateRequest;
use App\Http\Resources\SiswaResource;
use App\Services\SiswaService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Maatwebsite\Excel\Facades\Excel;

class AdminSiswaController extends Controller
{
    public function __construct(private readonly SiswaService $siswaService)
    {
    }

    public function index(Request $request)
    {
        $data = $this->siswaService->paginate($request->only(['kelas', 'search', 'per_page']));
        return SiswaResource::collection($data);
    }

    public function store(SiswaStoreRequest $request): SiswaResource
    {
        return new SiswaResource($this->siswaService->create($request->validated()));
    }

    public function show(int $id): SiswaResource
    {
        return new SiswaResource($this->siswaService->findOrFail($id));
    }

    public function update(SiswaUpdateRequest $request, int $id): SiswaResource
    {
        return new SiswaResource($this->siswaService->update($id, $request->validated()));
    }

    public function destroy(int $id): JsonResponse
    {
        $this->siswaService->delete($id);
        return response()->json(['message' => 'Siswa dihapus']);
    }

    public function byKelas(int $kelas)
    {
        return SiswaResource::collection($this->siswaService->byKelas($kelas));
    }

    public function import(Request $request): JsonResponse
    {
        $request->validate([
            'file' => ['required', 'file', 'mimes:xlsx,xls,csv,txt'],
            'kelas_default' => ['nullable', 'integer', 'between:7,12'],
        ]);

        $file = $request->file('file');
        $extension = strtolower((string) $file?->getClientOriginalExtension());

        if ($extension === 'txt') {
            $kelas = (int) $request->input('kelas_default', 0);
            if ($kelas < 7 || $kelas > 12) {
                return response()->json(['message' => 'Untuk file TXT, isi kelas_default (7-12)'], 422);
            }

            $lines = preg_split('/\r\n|\r|\n/', (string) file_get_contents($file->getRealPath()));
            $inserted = 0;
            $updated = 0;

            foreach ($lines as $line) {
                $nama = trim((string) $line);
                if ($nama === '') {
                    continue;
                }

                $existing = \App\Models\Siswa::query()
                    ->where('nama_siswa', $nama)
                    ->where('kelas', $kelas)
                    ->first();

                if ($existing) {
                    $existing->touch();
                    $updated++;
                    continue;
                }

                \App\Models\Siswa::query()->create([
                    'nama_siswa' => $nama,
                    'kelas' => $kelas,
                ]);
                $inserted++;
            }

            return response()->json([
                'message' => 'Import TXT selesai',
                'inserted' => $inserted,
                'updated' => $updated,
            ]);
        }

        $import = new SiswaImport();
        Excel::import($import, $file);

        return response()->json([
            'message' => 'Import selesai',
            'inserted' => $import->inserted,
            'updated' => $import->updated,
        ]);
    }
}
