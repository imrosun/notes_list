# 📝 Flutter Notes App

A simple and elegant **Notes App** built using **Flutter** and powered by **Supabase** for user authentication and data storage. This app works on **Web**, **Android**, and **iOS**, and supports **dark/light themes**, smooth UI, and animations.

---

## 🚀 Features

- ✅ User Signup & Login
- 🗒️ Create, Edit, Delete Notes
- ☁️ Supabase Backend Integration
- 🌗 Light & Dark Mode with Toggle
- 💻 Web, Android & iOS support
- 🧠 Maintains auth sessions
- ⚡ Smooth and animated UI

---

## 📁 Project Structure

lib/
│
├── app/
│   ├── theme.dart
│
├── auth/
│   ├── auth_gate.dart
│
├── pages/
│   ├── dashboard_screen.dart
│   ├── login_screen.dart
│   └── register_screen.dart
│
├── models/
│   └── note_database.dart
│   └── note.dart
│
├── main.dart
├── .env


## 🛠️ Getting Started

### 1. 📦 Clone the Repository

```bash
git clone https://github.com/imrosun/notes_list.git
cd flutter-notes-app
```

### 2. 📱 Setup Flutter

Make sure you have Flutter installed:
```bash 
flutter doctor
```

### 3. 📁 Install Dependencies

```bash 
flutter pub get
```

### 4. 🔐 Setup Environment Variables

Create a .env file at the root level (same level as pubspec.yaml) with your Supabase credentials:

```bash 
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### 5. 🧩 Supabase Setup

1. Create a Supabase Project
Go to https://supabase.com

Sign in and create a new project

Copy the Project URL and anon key from the Project → Settings → API

2. Create a notes Table
Go to your project's Table Editor and create a new table:

Table name: notes
Column     --	Type	  -- Description
id	       --   int8	  -- Primary Key, auto incr
title      --	text      -- Note title
content    --	text	  -- Note body
created_at --	timestamp -- default: now()

3. Enable Row Level Security Row-Level Security(RLS)
In your table settings:

Turn ON RLS

### 6. ▶️ Running the App

```bash 
flutter run
flutter run -d chrome - web
```

### 7. 🔁 Hot Reload vs Hot Restart

Hot Reload:
Hot reload loads code changes into the VM and re-builds the widget tree, preserving the app state; it doesn’t rerun main() or initState().

Hot Restart:
Hot restart loads code changes into the VM, and restarts the Flutter app, losing the app state.
