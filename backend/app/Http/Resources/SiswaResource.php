<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SiswaResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nama_siswa' => $this->nama_siswa,
            'kelas' => $this->kelas,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}

