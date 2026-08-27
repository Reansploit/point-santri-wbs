<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Point\PointStoreRequest;
use App\Http\Requests\Point\PointUpdateRequest;
use App\Http\Resources\PointResource;
use App\Services\PointService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class QismPointController extends Controller
{
    public function __construct(private readonly PointService $pointService)
    {
    }

    public function index(Request $request)
    {
        $points = $this->pointService->paginate($request->only(['siswa_id', 'kategori', 'tanggal', 'per_page']));
        return PointResource::collection($points);
    }

    public function store(PointStoreRequest $request): PointResource
    {
        return new PointResource($this->pointService->create($request->validated(), auth()->id()));
    }

    public function show(int $id): PointResource
    {
        return new PointResource($this->pointService->findOrFail($id));
    }

    public function update(PointUpdateRequest $request, int $id): PointResource
    {
        return new PointResource($this->pointService->update($id, $request->validated()));
    }

    public function destroy(int $id): JsonResponse
    {
        $this->pointService->delete($id);
        return response()->json(['message' => 'Point dihapus']);
    }
}

