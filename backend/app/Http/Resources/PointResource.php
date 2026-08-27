<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PointResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'siswa_id' => $this->siswa_id,
            'siswa' => new SiswaResource($this->whenLoaded('siswa')),
            'tanggal' => optional($this->tanggal)->format('Y-m-d'),
            'deskripsi' => $this->deskripsi,
            'kategori' => $this->kategori,
            'point_positif' => $this->point_positif,
            'point_negatif' => $this->point_negatif,
            'input_by' => $this->input_by,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
