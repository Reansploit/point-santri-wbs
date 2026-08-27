<?php

namespace App\Http\Requests\Point;

use Illuminate\Foundation\Http\FormRequest;

class PointStoreRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'siswa_id' => ['required', 'exists:siswa,id'],
            'tanggal' => ['nullable', 'date'],
            'deskripsi' => ['nullable', 'string', 'max:255'],
            'kategori' => ['nullable', 'string', 'max:100'],
            'point_positif' => ['nullable', 'integer', 'min:0'],
            'point_negatif' => ['nullable', 'integer', 'min:0'],
        ];
    }
}
