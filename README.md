# Quran Learning App (Baghdadi Qaida)

A professional, modern, and interactive Flutter application for learning the Holy Quran using the Baghdadi Qaida method.

## Features

- **Offline Mode**: All audio and content work without internet.
- **Multilingual Support**: English, Arabic, Dari (Persian), and Pashto.
- **Baghdadi Qaida**: Step-by-step lessons with word breakdown (spelling) audio.
- **Arabic Alphabet**: Interactive alphabet with pronunciation guides.
- **Holy Quran**: Full Mushaf support with verse-by-verse offline audio.
- **Quizzes**: Test your knowledge with interactive quizzes.
- **Progress Tracking**: Track your daily goals and completed lessons.
- **Modern UI**: Beautiful Islamic-themed design (Green & Gold).

## How to Get the APK

This project is set up with **GitHub Actions**. To get the APK:

1. Push this code to your GitHub repository.
2. Go to the **Actions** tab in your repository.
3. Find the "Build APK" workflow and wait for it to finish.
4. Download the **app-release.apk** from the artifacts section.

## Project Structure

- `lib/core`: Theme, localization, and state management.
- `lib/data`: Models and services for data handling.
- `lib/features`:
  - `alphabet`: Alphabet interactive screen.
  - `qaida`: Baghdadi Qaida lessons and word breakdown.
  - `mushaf`: Quran reading and audio player.
  - `quiz`: Quiz engine.
  - `dashboard`: App home and progress.
- `assets/audio`: Offline MP3 files.
- `assets/data`: JSON files for lessons and surahs.
- `assets/translations`: Localization files.

---

# اپلیکیشن آموزش قرآن (قاعده بغدادی)

یک اپلیکیشن حرفه‌ای، مدرن و تعاملی فلاتر برای آموزش قرآن کریم با روش قاعده بغدادی.

## قابلیت‌ها

- **حالت آفلاین**: تمام فایل‌های صوتی و محتوا بدون نیاز به انترنت کار می‌کند.
- **چندزبانه**: پشتیبانی از انگلیسی، عربی، دری و پشتو.
- **قاعده بغدادی**: درس‌های گام‌به‌گام با قابلیت تجزیه کلمات (هجی).
- **الفبای عربی**: آموزش تعاملی حروف با تلفظ صحیح.
- **قرآن کریم**: دسترسی به سوره‌ها با پخش آفلاین آیه به آیه.
- **آزمون‌ها**: ارزیابی یادگیری با آزمون‌های تعاملی.
- **پیگیری پیشرفت**: مشاهده میزان پیشرفت و اهداف روزانه.
- **رابط کاربری مدرن**: طراحی زیبای اسلامی با رنگ‌های سبز و طلایی.

## چطور فایل APK را دریافت کنیم؟

این پروژه با **GitHub Actions** تنظیم شده است:

1. کد را به مخزن (Repository) خود در گیت‌هاب Push کنید.
2. به تب **Actions** در گیت‌هاب بروید.
3. گردش‌کار "Build APK" را پیدا کرده و منتظر بمانید تا تمام شود.
4. فایل **app-release.apk** را از بخش Artifacts دانلود و در موبایل خود نصب کنید.
