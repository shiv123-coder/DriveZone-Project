# DriveZone Features

## 1. Authentication & Security
*   **User Registration**: Secure account creation with visual password strength indication.
*   **Role-Based Access**: Distinct login pathways. Regular users access inventory, whereas administrators ("SSP" or "admin") gain access to the complete dashboard.
*   **Session Checks**: Core management pages (`admin.jsp` and `editCar.jsp`) are protected. Unauthorized users attempting direct URL access are immediately redirected to the login screen.

## 2. Dynamic UI/UX Theme Engine
*   **Light/Dark Toggle**: A robust toggle mechanism implemented across all pages using CSS Custom Properties (`:root` for light mode, `[data-theme="dark"]` for dark mode).
*   **Persistent State**: The user's theme preference is stored in `localStorage` and applied instantly upon page load, preventing visual flashing.
*   **Premium Aesthetics**: Modern typography (Inter & Poppins), smooth gradients, animated glassmorphism panels, and customized SweetAlert2 notifications enhance the showroom feel.

## 3. Inventory Management (Admin Dashboard)
*   **Vehicle Addition**: Easily add new cars with specifications (Brand, Model, Price, Fuel Type, Description) and image URLs.
*   **Vehicle Modification**: Edit existing vehicle details to update prices or specifications.
*   **Vehicle Deletion**: Securely remove outdated or sold inventory from the database.

## 4. Customer Interaction
*   **Inventory Browsing**: Public access to view available cars and their detailed specifications.
*   **Real-time Search**: Client-side filtering of vehicles based on model or brand keywords.
*   **Enquiries**: Dedicated enquiry forms on vehicle detail pages. Submitted enquiries are routed directly to the database for administrative review.
