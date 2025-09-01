# .NET Monorepo

A monorepo containing multiple .NET microservices with isolated dependencies and centralized package management.

## Structure

```
monorepo/
├── .github/                    # GitHub Actions workflows
├── docs/                     # Global Documentation
├── services/                   # Microservices
│   ├── Bff/                   # Backend for Frontend (contains Angular)
│   ├── UserService/           # User management service
│   └── OrderService/          # Order management service
├── e2e/                       # Global end-to-end tests
└── tools/                      # Build and deployment tools
```

## Services

- **Bff**: Backend for Frontend service containing Angular frontend and .NET API
- **UserService**: User management microservice
- **OrderService**: Order management microservice

## Development

### Prerequisites
- .NET 8.0 SDK
- Node.js 18+ (for Angular and Playwright)
- PowerShell 7+ (for build scripts)

### Building
```powershell
# Build all services
./tools/build.ps1

# Build specific service
./tools/build.ps1 -Service Bff
```

### Testing
```powershell
# Run all unit tests
./tools/test.ps1

# Run e2e tests
cd e2e
npm run test:e2e

# Check service isolation
./tools/check-service-isolation.ps1
```

## CI/CD

GitHub Actions automatically:
- Detects changed services
- Builds only affected services
- Runs unit tests for changed services
- Executes global e2e tests
- **Enforces service isolation** via separate workflow (blocks PRs with project references between services)

## Architecture Principles

- **Service Isolation**: No project references between services (enforced by CI/CD)
- **Centralized Package Management**: Directory.Build.props per service
- **Incremental Building**: Only build what changed
- **Comprehensive Testing**: Unit tests per service + global e2e tests