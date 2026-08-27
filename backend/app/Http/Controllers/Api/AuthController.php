<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(LoginRequest $request): JsonResponse
    {
        $username = (string) $request->input('username');
        $password = (string) $request->input('password');

        $user = User::query()->where('username', $username)->first();

        if (!$user || !Hash::check($password, $user->password)) {
            return response()->json(['message' => 'Username atau password tidak valid'], 422);
        }

        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'token' => $token,
            'user' => ['id' => $user->id, 'username' => $user->username, 'role' => $user->role],
        ]);
    }

    public function logout(): JsonResponse
    {
        auth()->user()->currentAccessToken()?->delete();
        return response()->json(['message' => 'Logout berhasil']);
    }

    public function me(): JsonResponse
    {
        return response()->json(auth()->user());
    }
}
