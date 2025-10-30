# Burger Builder Frontend

The Burger Builder frontend is a React + TypeScript single-page application that powers the customer experience for Group1's burger ordering platform. It communicates with the Spring Boot API, provides an interactive burger builder, and persists cart activity across sessions.

## Highlights
- Ingredient catalogue grouped by category with instant burger preview and pricing
- Cart, checkout, and order-history flows built with React Router and Context API
- Graceful offline mode that seeds sample ingredients if the backend API is unreachable
- Axios client configured through `VITE_API_BASE_URL`, with console logging to make misconfiguration obvious
- Fully tested with Vitest + Testing Library (19 suites / 46 assertions passing in the latest run)

## Tech Stack
- React 19, React Router DOM 7
- TypeScript 5.8 with Vite 7 build tooling
- Axios for HTTP, React Context for shared state
- CSS Modules for scoped styling
- Vitest, @testing-library/react, and ESLint 9 for quality gates

## Project Structure
```
frontend/
├── public/                         # Static assets
├── src/
│   ├── components/
│   │   ├── BurgerBuilder/          # Builder UI + live preview
│   │   ├── Cart/                   # Cart list, summary, and item cards
│   │   ├── Ingredients/            # Ingredient grid and cards
│   │   ├── Layout/                 # Header, navigation shell
│   │   ├── OrderHistory/           # Past orders view
│   │   └── OrderSummary/           # Checkout flow
│   ├── context/                    # CartProvider & BurgerBuilderProvider
│   ├── services/api.ts             # Axios client + REST helpers
│   ├── types/                      # Shared TS interfaces
│   ├── utils/sessionManager.ts     # Session ID persistence utilities
│   ├── App.tsx / main.tsx          # Routing and bootstrap
│   └── index.css / App.css         # Global and app-scoped styles
├── Dockerfile                      # Multi-stage build → Nginx runtime
├── package.json                    # Scripts and dependencies
├── vite.config.ts / vitest.config.ts
├── tsconfig*.json
└── README.md
```

## Prerequisites
- Node.js 20 (or newer LTS) and npm 10+
- Running backend API (local `http://localhost:8080` or a deployed endpoint)

## Setup
```bash
npm install
cp .env.example .env   # if you keep an example file; otherwise create .env
```

Populate `.env` with the backend URL:
```
VITE_API_BASE_URL=http://localhost:8080
```

Start the dev server:
```bash
npm run dev
```
The app listens on `http://localhost:5173`. The console prints the effective API base URL at startup to confirm connectivity.

## Scripts
- `npm run dev` – start Vite dev server with hot reload
- `npm run build` – type-check (`tsc -b`) and build production bundle
- `npm run preview` – serve the build locally
- `npm run lint` – ESLint with TypeScript + React rules
- `npm test` – Vitest in watch mode
- `npm run test:ui` – Vitest UI runner
- `npm run test:coverage` – Generate coverage report (V8)

## Testing & Quality
- 19 test suites / 46 assertions covering contexts, utilities, API client, and core components (`frontend/test-results.json`)
- Context providers assert correct behavior when used outside a provider, guarding against misuse
- Coverage and lint tasks run quickly (~seconds) thanks to Vite and Vitest integration

## Build & Deployment
- Production build:
  ```bash
  npm run build
  npm run preview   # optional verification
  ```
- Docker image (used by Kubernetes deployment):
  ```bash
  docker build -t burger-builder-frontend \
    --build-arg VITE_API_BASE_URL=https://api.example.com \
    .
  ```
- Nginx configuration (`nginx.conf`) supports SPA routing and static asset caching

## API Integration
The Axios client in `src/services/api.ts` targets the backend REST API and surfaces helper functions:
- Ingredients: `GET /api/ingredients`, `/api/ingredients/{category}`
- Cart: `POST /api/cart/items`, `GET /api/cart/{sessionId}`, `DELETE /api/cart/items/{itemId}`, totals and counts
- Orders: `POST /api/orders`, `GET /api/orders/{orderId}`, `/history`, `/customer/{email}`, `/session/{sessionId}`, status updates
- Health: `GET /api/health` (used for manual troubleshooting)

Missing or misconfigured APIs trigger a visible banner and switch to sample data so the UI remains demoable.

## State Management
- `BurgerBuilderContext` stores selected layers and pricing logic
- `CartContext` persists cart items to `localStorage`, exposing helpers for totals, counts, quantity adjustments, and clearing

## Styling & UX
- CSS Modules keep component styles scoped
- Responsive layouts ensure a consistent experience across desktop/tablet/mobile
- Animations and notifications provide feedback for actions like adding to cart or handling errors

## Troubleshooting
- Check the browser console for the logged `API_BASE_URL` – it should match your backend endpoint
- If ingredient loading fails, the banner indicates the fallback to sample data; verify CORS and API health
- Ensure the backend exposes CORS origins that include the frontend host (configured via `CORS_ALLOWED_ORIGINS`)

## License

MIT
