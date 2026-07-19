# Quran Learning App (Baghdadi Qaida) - Developer Handover

## Overview
This project is a professional mobile application built with Flutter following Clean Architecture principles. It aims to teach Quran using the Baghdadi Qaida method, supporting English, Arabic, Persian (Dari), and Pashto.

## Implemented Features
1. **Interactive Alphabet (Phase 1):** Grid view of letters with audio playback and visual feedback on tap.
2. **Baghdadi Qaida (Phase 2):** Structured lesson viewer with harakat explanations.
3. **Word-by-Word Breakdown (Phase 3):** Splitting Quranic words into learning units with individual audio sync.
4. **Mushaf Viewer (Phase 4 & 5):** High-fidelity rendering with word-level and verse-level highlighting.
5. **AI Teacher:** Integration with Google Gemini API for recitation analysis and feedback.
6. **Multi-language Support:** Ready-to-use translations for 4 languages.
7. **Theme:** Modern Islamic design with Green and Gold palette.

## Technical Setup
- **State Management:** Riverpod.
- **Audio:** `just_audio` & `audio_service`.
- **Localization:** `easy_localization`.
- **UI:** `flutter_screenutil`, `animate_do`, `google_fonts`.

## Next Steps
1. **Audio Assets:** Add real MP3 files to `assets/audio/` matching the paths in `arabic_letter.dart` and `WordUnit` models.
2. **Fonts:** Download `traditional_quran.ttf` and `Amiri-Regular.ttf` to `assets/fonts/`.
3. **API Key:** Create a `.env` file and add `GEMINI_API_KEY=your_key_here`.
4. **Supabase:** Configure `Supabase.initialize` in `main.dart` with your project URL and Anon Key for cloud features.
5. **Data Expansion:** Fill `quranSurahs` list and `verses` data from a complete Quranic JSON source.

## How to Run
1. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
2. **Setup AI Teacher:**
   - Create a `.env` file in the root directory.
   - Add your API key: `GEMINI_API_KEY=AIzaSy...`
3. **Run the App:**
   ```bash
   flutter run
   ```

## Supabase Database Setup
To enable cloud sync, create a table named `user_progress` in your Supabase project with the following SQL:

```sql
create table user_progress (
  user_id uuid references auth.users not null primary key,
  alphabet int[] default '{}',
  qaida int[] default '{}',
  surahs int[] default '{}',
  updated_at timestamp with time zone default now()
);

-- Enable RLS
alter table user_progress enable row level security;

-- Create policies
create policy "Users can view their own progress" on user_progress
  for select using (auth.uid() = user_id);

create policy "Users can update their own progress" on user_progress
  for upsert with check (auth.uid() = user_id);
```
