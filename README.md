# MyToko - Flutter E-Commerce App

Aplikasi e-commerce mobile menggunakan Flutter yang menampilkan data produk dari [DummyJSON API](https://dummyjson.com/products).

## Fitur

### Wajib
- ✅ **Login Page** - Form login dengan validasi username & password, session disimpan di SharedPreferences
- ✅ **Main Page / Store** - Daftar produk dalam GridView (2 kolom) dari API DummyJSON
- ✅ **Detail Page** - Detail produk lengkap dengan gambar carousel, tombol Add/Remove from Cart
- ✅ **Cart Page** - Daftar produk yang disimpan di keranjang (via SharedPreferences)
- ✅ **Profile Page** - Info Nama, NIM, Username (dari SharedPreferences), tombol Logout
- ✅ **Session Persistence** - Auto-login jika sudah pernah login sebelumnya

### Opsional
- ✅ **Category Filter** - Filter produk berdasarkan kategori menggunakan FilterChip
- ✅ **Camera & Gallery** - Ganti foto profil dari kamera atau galeri (image_picker)

## Akun Demo

| Username | Password  |
|----------|-----------|
| admin    | admin123  |
| user     | user123   |
| emilys   | emilyspass |

## Cara Menjalankan

### Prasyarat
- Flutter SDK >= 3.0.0
- Android Studio / VS Code
- Android Emulator atau perangkat fisik

### Langkah

```bash
# 1. Clone atau ekstrak project
cd mytoko

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

## Struktur Project

```
lib/
├── main.dart                  # Entry point
├── theme.dart                 # Warna & tema aplikasi
├── models/
│   └── product.dart           # Model data produk
├── services/
│   ├── api_service.dart       # HTTP request ke DummyJSON
│   └── prefs_service.dart     # SharedPreferences helper
└── pages/
    ├── splash_page.dart       # Splash screen + auto-login check
    ├── login_page.dart        # Halaman login
    ├── main_page.dart         # Bottom navigation wrapper
    ├── store_page.dart        # Grid produk + filter kategori
    ├── detail_page.dart       # Detail produk + Add to Cart
    ├── cart_page.dart         # Keranjang belanja
    └── profile_page.dart      # Profil user + logout
```

## Dependensi

```yaml
http: ^1.2.0                   # HTTP requests
shared_preferences: ^2.2.2     # Penyimpanan lokal
image_picker: ^1.0.7           # Kamera & galeri
cached_network_image: ^3.3.1   # Cache gambar dari internet
```

## API Endpoints

- `GET https://dummyjson.com/products` - Semua produk
- `GET https://dummyjson.com/products/{id}` - Produk by ID
- `GET https://dummyjson.com/products/category-list` - Daftar kategori
- `GET https://dummyjson.com/products/category/{category}` - Produk by kategori
