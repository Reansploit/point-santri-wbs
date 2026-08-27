<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class AdminUserController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $search = (string) $request->query('search', '');
        $users = User::query()
            ->when($search !== '', fn ($q) => $q->where('username', 'ilike', "%{$search}%"))
            ->orderBy('username')
            ->paginate((int) $request->query('per_page', 10));
        return response()->json($users);
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'username' => ['required', 'string', 'max:255', 'unique:users,username'],
            'password' => ['required', 'string', 'min:6'],
            'role' => ['required', Rule::in(['admin', 'qism'])],
        ]);

        $user = User::query()->create([
            'username' => $data['username'],
            'password' => Hash::make($data['password']),
            'role' => $data['role'],
        ]);

        return response()->json($user, 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $user = User::query()->findOrFail($id);
        $data = $request->validate([
            'username' => ['required', 'string', 'max:255', Rule::unique('users', 'username')->ignore($user->id)],
            'role' => ['required', Rule::in(['admin', 'qism'])],
        ]);
        $user->update($data);
        return response()->json($user->refresh());
    }

    public function updatePassword(Request $request, int $id): JsonResponse
    {
        $user = User::query()->findOrFail($id);
        $data = $request->validate([
            'password' => ['required', 'string', 'min:6'],
        ]);
        $user->update(['password' => Hash::make($data['password'])]);
        return response()->json(['message' => 'Password berhasil diubah']);
    }

    public function destroy(int $id): JsonResponse
    {
        if (auth()->id() === $id) {
            return response()->json(['message' => 'Akun sendiri tidak bisa dihapus'], 422);
        }
        $user = User::query()->findOrFail($id);
        $user->delete();
        return response()->json(['message' => 'Akun dihapus']);
    }
}

