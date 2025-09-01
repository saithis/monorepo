# Service Isolation Rules

This document defines the rules that must be followed to maintain service isolation in the monorepo.

## 🚫 What is NOT Allowed

### Project References
- **Violation**: Any `.csproj` file containing `ProjectReference` to another service
- **Example**: `UserService.API` referencing `OrderService.Core`
- **Why**: Creates direct compile-time dependencies between services, which is the primary concern for maintaining service boundaries

## ✅ What IS Allowed

### 1. Shared Global Configuration
- Global `.editorconfig`, `Directory.Build.props`, and `global.json`
- Common build properties and package versions
- Shared coding standards and analysis rules

### 2. Service-Specific Dependencies
- Each service can have its own `Directory.Build.props` and `Directory.Packages.props`
- Services can reference standard .NET packages (EF Core, ASP.NET Core, etc.)
- Services can have their own testing frameworks and tools

### 3. Infrastructure Sharing (Optional)
- Common Docker configurations
- Shared CI/CD scripts and templates
- Common deployment configurations

## 🔍 How Violations Are Detected

### Automated Checks
1. **GitHub Actions**: Separate workflow runs on every PR to detect violations
2. **Local Scripts**: `./tools/check-service-isolation.ps1` for manual verification

### What Gets Scanned
- All `.csproj` files for project references to other services

## 🚨 Violation Examples

### ❌ Bad - Project Reference Violation
```xml
<!-- In UserService.API.csproj -->
<ItemGroup>
  <ProjectReference Include="..\..\..\services\OrderService\src\OrderService.Core\OrderService.Core.csproj" />
</ItemGroup>
```

### ✅ Good - Proper Service Isolation
```xml
<!-- In UserService.API.csproj -->
<ItemGroup>
  <ProjectReference Include="..\UserService.Core\UserService.Core.csproj" />
  <PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.0.0" />
</ItemGroup>
```

## 🛠️ How to Fix Violations

### 1. Remove Direct References
- Delete any `ProjectReference` elements pointing to other services

### 2. Use Proper Communication Patterns
- **HTTP APIs**: Services communicate via REST/GraphQL APIs
- **Message Queues**: Use async messaging for service communication
- **Event Sourcing**: Share data through events, not direct references

### 3. Extract Shared Code (if needed)
- Move truly shared code to a separate `Shared` or `Common` library
- Use interfaces and contracts for service communication
- Implement proper API contracts and DTOs

## 📋 Compliance Checklist

Before submitting a PR, ensure:
- [ ] No `ProjectReference` elements point to other services
- [ ] Service isolation check passes locally: `./tools/check-service-isolation.ps1`
- [ ] All tests pass for the modified service

## 🎯 Benefits of Service Isolation

1. **Independent Development**: Teams can work on services without coordination
2. **Independent Deployment**: Services can be deployed separately
3. **Technology Freedom**: Each service can use different .NET versions or packages
4. **Scalability**: Services can be scaled independently
5. **Maintainability**: Changes in one service don't affect others
6. **Testing**: Services can be tested in isolation

## 🔗 Related Documentation

- [Monorepo Architecture Overview](README.md)
- [Build and Test Scripts](tools/README.md)
- [CI/CD Pipeline Configuration](.github/workflows/README.md)
