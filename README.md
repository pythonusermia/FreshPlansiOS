# Fresh Plans  

**Fresh Plans** is a modern, data-driven iOS meal planning and grocery management application. It helps users eliminate "decision fatigue" by generating intelligent meal plans and automatically aggregating ingredients into a checkable shopping list.

Note: This project is currently a Work in Progress (WIP).

---

##  Features

###  Smart Meal Generation
- Generate custom meal plans for 1 to 14 days.
- Filter by meal type (Breakfast, Lunch, Dinner).
- **Recipe Locking:** "Lock" your favorite meals to keep them while regenerating the rest of the plan.

###  Automated Grocery Logic
- **Smart Aggregation:** Ingredients from all planned recipes are automatically merged into a single list.
- **Deduplication:** Prevents multiple entries for the same item (e.g., "Salt" from three different recipes appears once).
- **Checkable Rows:** Easily track what’s in your cart versus what's left to buy.

###  Dynamic Dashboard
- **Recipe of the Day:** Features a high-impact "Hero Card" for today's main meal.
- **Cooking Stats:** Glanceable view of prep time and serving sizes.
- **Upcoming Meals:** A horizontal preview of tomorrow's menu.

---

##  Tech Stack

- **SwiftUI:** For a modern, declarative user interface.
- **SwiftData:** Persistent storage for recipes, locks, and meal plan states.
- **Spoonacular API:** Integration for fetching high-quality recipes and nutritional data.
- **Observation Framework:** Reactive UI updates that stay in sync with the database.
- **Async/Await:** Clean asynchronous networking for smooth data fetching.

---

##  Screenshots

| Dashboard | Meal Planner | Grocery List |
| :--- | :--- | :--- |
| *<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-12 at 11 32 17" src="https://github.com/user-attachments/assets/df344b79-6f1e-48ab-9e83-e9d39560b584" />* | *<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-12 at 11 32 27" src="https://github.com/user-attachments/assets/93dd27e2-ea5f-4a4c-b370-7227e246853f" />* | *<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-12 at 11 32 30" src="https://github.com/user-attachments/assets/c5d08954-c8a7-438d-b798-e6dd7546424f" />* |

---

##  Installation & Setup

1. Clone the repository:
   ```bash
   git clone [https://github.com/pythonusermia/FreshPlansiOS.git](https://github.com/pythonusermia/FreshPlansiOS.git)

---

## 📜 License
This project is currently for portfolio display. All rights reserved.
