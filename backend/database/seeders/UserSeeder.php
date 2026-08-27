<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::query()->updateOrCreate(
            ['username' => 'admin'],
            ['password' => Hash::make('password'), 'role' => 'admin']
        );
        User::query()->updateOrCreate(
            ['username' => 'qism'],
            ['password' => Hash::make('password'), 'role' => 'qism']
        );
    }
}

