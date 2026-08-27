<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Siswa extends Model
{
    protected $table = 'siswa';

    protected $fillable = ['nama_siswa', 'kelas'];

    public function points(): HasMany
    {
        return $this->hasMany(Point::class);
    }
}

