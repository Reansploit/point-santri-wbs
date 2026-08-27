// Prevents an extra console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod commands;
mod db;
mod models;

use db::AppState;
use tauri::Manager;

fn main() {
    tauri::Builder::default()
        .plugin(tauri_plugin_dialog::init())
        .setup(|app| {
            let dir = app
                .path()
                .app_data_dir()
                .expect("Gagal mendapatkan app data dir");
            let conn = db::open(dir).expect("Gagal membuka database");
            app.manage(AppState {
                db: std::sync::Mutex::new(conn),
                current: std::sync::Mutex::new(None),
            });
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            commands::login,
            commands::logout,
            commands::get_current_user,
            commands::list_siswa,
            commands::create_siswa,
            commands::update_siswa,
            commands::delete_siswa,
            commands::import_siswa,
            commands::clear_siswa,
            commands::list_points,
            commands::create_point,
            commands::update_point,
            commands::delete_point,
            commands::clear_points,
            commands::rekap,
            commands::rekap_siswa,
            commands::kelas_rekap,
            commands::statistik,
            commands::list_users,
            commands::create_user,
            commands::update_user,
            commands::update_user_password,
            commands::delete_user,
            commands::export_excel,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
