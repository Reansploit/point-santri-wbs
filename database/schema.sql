create table if not exists users (
  id bigserial primary key,
  username varchar(255) not null unique,
  password varchar(255) not null,
  role varchar(20) not null,
  created_at timestamp null,
  updated_at timestamp null
);

create table if not exists siswa (
  id bigserial primary key,
  nama_siswa varchar(255) not null,
  kelas smallint not null check (kelas between 7 and 12),
  created_at timestamp null,
  updated_at timestamp null
);

create table if not exists points (
  id bigserial primary key,
  siswa_id bigint not null references siswa(id) on delete cascade,
  tanggal date not null,
  deskripsi varchar(255) not null,
  kategori varchar(100) not null,
  point_positif integer not null default 0,
  point_negatif integer not null default 0,
  input_by bigint not null references users(id),
  created_at timestamp null,
  updated_at timestamp null,
  check ((point_positif = 0 and point_negatif >= 0) or (point_negatif = 0 and point_positif >= 0))
);

create index if not exists idx_siswa_kelas on siswa(kelas);
create index if not exists idx_points_tanggal_kategori on points(tanggal, kategori);
