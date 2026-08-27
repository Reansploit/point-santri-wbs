<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('siswa', function (Blueprint $table) {
            $table->id();
            $table->string('nama_siswa');
            $table->unsignedTinyInteger('kelas');
            $table->timestamps();
            $table->index('kelas');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('siswa');
    }
};

