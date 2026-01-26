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
| *<img width="423" height="860" alt="Screenshot 2026-01-24 at 4 03 22 PM" src="https://github.com/user-attachments/assets/1c3eff7e-6797-40d8-8a5a-c1590366e39a" />* | *<img width="428" height="856" alt="Screenshot 2026-01-24 at 4 02 50 PM" src="https://github.com/user-attachments/assets/e3805bdf-a84c-4104-83fd-f0a0c7215f7b" />* | *<img width="429" height="867" alt="Screenshot 2026-01-24 at 4 03 07 PM" src="https://github.com/user-attachments/assets/ecb32cdb-5c2b-4744-9769-9f0c1ddb129f" />* |

---

##  Installation & Setup

1. Clone the repository:
   ```bash
   git clone [https://github.com/pythonusermia/FreshPlansiOS.git](https://github.com/pythonusermia/FreshPlansiOS.git)

---

## 📜 License
This project is currently for portfolio display. All rights reserved.
