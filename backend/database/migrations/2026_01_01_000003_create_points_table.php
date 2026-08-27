<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('points', function (Blueprint $table) {
            $table->id();
            $table->foreignId('siswa_id')->constrained('siswa')->cascadeOnDelete();
            $table->date('tanggal');
            $table->string('deskripsi');
            $table->string('kategori');
            $table->integer('point_positif')->default(0);
            $table->integer('point_negatif')->default(0);
            $table->foreignId('input_by')->constrained('users');
            $table->timestamps();
            $table->index(['tanggal', 'kategori']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('points');
    }
};
