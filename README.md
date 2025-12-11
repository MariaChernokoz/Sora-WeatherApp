# ☁️ Sora Weather App

**Sora** — MVP метеорологического iOS-приложения. Проект фокусируется на предоставлении чистого, атмосферного пользовательского опыта, вдохновленного визуальным стилем студии Ghibli (мультфильмов Миядзаки), и демонстрирует владение ключевыми фреймворками Apple, включая CoreLocation, WidgetKit и SwiftData.

---

## ✨ Ключевые Функции

* **Динамический Фон:**
    Визуальное оформление меняется в зависимости от погоды с использованием **видео-фонов**, что создает неповторимую атмосферу, вдохновленную работами Хаяо Миядзаки. Реализована логика сопоставления погодных SF Symbols с пулом видеофайлов, включая рандомизацию (например, `cloudy_day_1` или `cloudy_day_2`).
* **Кастомный Виджет (WidgetKit):**
    Создание полноценного Widget Extension с использованием `TimelineProvider` для актуализации данных. Синхронизация данных с основным приложением осуществляется через App Groups.
* **Управление Геолокацией и Городами:**
    Реализован полный цикл работы с местоположением: определение текущих координат через CoreLocation, поиск новых локаций с помощью MapKit, сохранение избранного в SwiftData и высвечивающиеся подсказки при поисковом вводе.
* **Персистентность (SwiftData):**
    Использована для локального и надежного хранения списка избранных городов пользователя и их данных.
* **Проба нового "Liquid Glass" модификатора:**
    Применение модификатора для создания стильного "стеклянного" дизайна, повышающего UX.

---

## 🛠️ Технологический Стек

* **Swift**
* **SwiftUI**
* **Swift Concurrency (async/await)**
* **URLSession** (для сетевых запросов)
* **OpenWeatherMap API** (источник данных о погоде)
* **SwiftData** (для локального хранения данных)
* **WidgetKit** (для расширения виджета)
* **CoreLocation** (для определения местоположения)
* **MapKit** (для карт и поиска)
* **App Groups / UserDefaults** (для синхронизации данных между приложением и виджетом)
* **Custom View Modifiers** (для UI эффектов, например, Liquid Glass)

---

## 🎬 Видео-Демонстрация

[Демо-видео 1] https://github.com/user-attachments/assets/3f268ebb-d153-4759-a9ec-26ac9caa2964 <br>
[Демо-видео 2] https://github.com/user-attachments/assets/6930d72e-e8b1-4d2a-a661-fea9650655d1 <br>

## 📸 Скриншоты

<p align="center">
  <img src="https://github.com/user-attachments/assets/867df98b-6f3a-4c69-baa3-1f87e9a3d737" width="150" alt="Главный экран - Ясно" />
  <img src="https://github.com/user-attachments/assets/34f19d42-82de-4670-82ea-ab0acf9ea160" width="150" alt="Экран поиска" />
  <img src="https://github.com/user-attachments/assets/8bc6c163-48cd-49ae-867f-c1594af97c4f" width="150" alt="Выбор города на карте" />
  <img src="https://github.com/user-attachments/assets/4f31003d-ff61-4963-81a1-8bb467023dac" width="150" alt="Главный экран - Облачно" />
  <img src="https://github.com/user-attachments/assets/f99772d0-227b-4c4f-854a-d7ebbdc56879" width="150" alt="Виджет на темном фоне" />
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/fb24380a-40b1-47c6-918c-7f378f086056" width="150" alt="Главный экран - Гроза" />
  <img src="https://github.com/user-attachments/assets/958f9480-ab6f-41f1-8c7c-90e70d837336" width="150" alt="Список избранных городов" />
  <img src="https://github.com/user-attachments/assets/a852ac2f-2f96-404e-873e-709dcddc2a70" width="150" alt="Скролл Осло" />
  <img src="https://github.com/user-attachments/assets/86b8bcb9-0b08-4999-a206-630e34301a33" width="150" alt="Виджет на светлом фоне" />
  <img src="https://github.com/user-attachments/assets/1a38ee26-1790-4de2-856e-7000f6d17d09" width="150" alt="Главный экран - Дождь" />
</p>
