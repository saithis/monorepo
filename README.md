# .NET Monorepo

A monorepo containing multiple .NET microservices with isolated dependencies and centralized package management.

## Structure

```
monorepo/
├── .github/                    # GitHub Actions workflows
├── global/                     # Global configuration
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
```

## CI/CD

GitHub Actions automatically:
- Detects changed services
- Builds only affected services
- Runs unit tests for changed services
- Executes global e2e tests

## Architecture Principles

- **Service Isolation**: No cross-service dependencies
- **Centralized Package Management**: Directory.Build.props per service
- **Incremental Building**: Only build what changed
- **Comprehensive Testing**: Unit tests per service + global e2e tests