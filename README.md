# ✨ Glowi — Rhythmic Gymnastics Companion App

### iOS App · SwiftUI · MVVM

📍 Mississauga, ON, Canada

---

## 📱 Overview

**Glowi** is a modern iOS application designed for parents of rhythmic gymnasts to manage their child’s training, events, payments, and progress — all in one place.

The app focuses on **clarity, structure, and real-world usability**, simulating a production-ready environment with role-based logic and scalable architecture.

---

## 🚀 Key Features

### 👨‍👩‍👧 Parent Dashboard

* Overview of training sessions, competitions, and upcoming events
* Real-time status indicators (completed, upcoming)
* Smart UI states (empty, loading, success)

---

### 👧 Multi-Child Support

* Add and manage multiple children
* Switch between profiles
* Independent tracking per child

---

### 🧾 Payments System

* View upcoming and completed payments
* “Pay Now” flow with confirmation sheet
* Status tracking (Paid / Pending)
* Mock checkout experience (production-ready structure)

---

### 📅 Calendar & Events

* Event list with detailed info
* Competition-specific UI
* Inline payment integration inside events

---

### 🔔 Notifications

* Payment reminders
* Event updates
* Account-related alerts
* Auto-mark as read

---

### 👤 Account & Profile

* Parent profile screen
* Add/Edit child profiles
* Reset demo data (for testing)

---

## 🧠 Product-Level Logic

### 🔐 Role-Based Behavior (Real-World UX)

* Parents **cannot edit athlete level**
* New child profiles are created with:

```text
Level: Pending coach approval
```

* Level is intended to be assigned by **coach/admin role**

---

### 💡 Why this matters

This mirrors real sports systems where:

* Athlete classification is controlled by professionals
* Parents manage logistics, not performance tiers

---

## 🎨 UI/UX Highlights

* Custom design system (`Theme`)
* Gradient-based premium interface
* Reusable components (cards, buttons, badges)
* Smooth animations and transitions
* Empty states and micro-interactions

---

## 🏗 Architecture

* **SwiftUI + MVVM**
* State-driven UI with `@Published`
* Local persistence via JSON (MockData)
* Modular structure:

  * Views
  * ViewModels
  * Models
  * Components

---

## 🧪 Demo Mode

The app uses mock data to simulate real usage.

### Reset Feature:

* Restore initial data
* Useful for testing flows and UI states

---

## 📦 Tech Stack

* Swift
* SwiftUI
* MVVM Architecture
* Combine (via ObservableObject)
* Local JSON data storage

---

## 🔮 Future Improvements

* Backend integration (Node.js / Firebase)
* Real authentication system
* Coach/Admin dashboard
* Push notifications
* Stripe payment integration
* Email confirmation flow
* AI-based training insights

---

## 💼 Portfolio Value

This project demonstrates:

* Real-world product thinking
* Clean UI architecture
* State management
* Role-based UX decisions
* Scalable mobile app structure

---

## 👩‍💻 Author

**Irina S.**
iOS & Web Developer

📍 Mississauga, ON, Canada

---

## ⭐️ Notes

This app is built as a **portfolio-level production simulation**, focusing on both technical implementation and product design thinking.

