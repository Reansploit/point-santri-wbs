<?php

namespace App\Http\Requests\Siswa;

use Illuminate\Foundation\Http\FormRequest;

class SiswaStoreRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'nama_siswa' => ['required', 'string', 'max:255'],
            'kelas' => ['required', 'integer', 'between:7,12'],
        ];
    }
}

