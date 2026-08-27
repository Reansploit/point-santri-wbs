import {
  HashRouter,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";
import { AuthProvider, useAuth } from "./lib/auth";
import { ProtectedRoute } from "./components/ProtectedRoute";
import Layout from "./components/Layout";
import Login from "./pages/Login";
import AdminDashboard from "./pages/admin/Dashboard";
import AdminSiswa from "./pages/admin/Siswa";
import AdminAkun from "./pages/admin/Akun";
import QismDashboard from "./pages/qism/Dashboard";
import QismPoint from "./pages/qism/Point";
import QismRekap from "./pages/qism/Rekap";
import QismKelas from "./pages/qism/Kelas";
import QismSiswaDetail from "./pages/qism/SiswaDetail";
import QismExport from "./pages/qism/Export";

function DashboardSwitch() {
  const { user } = useAuth();
  return user?.role === "admin" ? <AdminDashboard /> : <QismDashboard />;
}

export default function App() {
  return (
    <AuthProvider>
      <HashRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route
            path="/"
            element={
              <ProtectedRoute>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route index element={<Navigate to="/dashboard" replace />} />
            <Route path="dashboard" element={<DashboardSwitch />} />
            <Route path="admin/siswa" element={<AdminSiswa />} />
            <Route path="admin/akun" element={<AdminAkun />} />
            <Route path="qism/point" element={<QismPoint />} />
            <Route path="qism/rekap" element={<QismRekap />} />
            <Route path="qism/kelas" element={<QismKelas />} />
            <Route path="qism/kelas/:kelas" element={<QismKelas />} />
            <Route path="qism/siswa/:id" element={<QismSiswaDetail />} />
            <Route path="qism/export" element={<QismExport />} />
          </Route>
          <Route path="*" element={<Navigate to="/dashboard" replace />} />
        </Routes>
      </HashRouter>
    </AuthProvider>
  );
}
