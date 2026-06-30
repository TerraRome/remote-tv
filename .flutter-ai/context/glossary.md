# Glossary

| Term                   | Definition                                                                                   |
| ---------------------- | -------------------------------------------------------------------------------------------- |
| **Bloc**               | Business Logic Component. Pattern separating presentation from business logic using Streams. |
| **Cubit**              | Simplified Bloc variant using functions instead of events.                                   |
| **Clean Architecture** | Layered architecture enforcing dependency inversion. Outer layers depend on inner layers.    |
| **DTO**                | Data Transfer Object. Model class for serialization boundary (API ↔ app).                    |
| **Entity**             | Domain object with business meaning. Independent of frameworks.                              |
| **FAW**                | Flutter AI Workspace. This knowledge base.                                                   |
| **Failure**            | Sealed class representing error states in Result/Either types.                               |
| **Feature**            | Self-contained module with data, domain, and presentation layers.                            |
| **Flavor**             | Build configuration variant (dev/staging/prod) with separate settings.                       |
| **Injectable**         | Code-generation library for automatic DI registration with GetIt.                            |
| **MethodChannel**      | Flutter's native communication bridge to platform code.                                      |
| **Repository**         | Abstraction over data sources providing a clean domain API.                                  |
| **Result**             | Union type (Success/Failure) for explicit error handling.                                    |
| **UseCase**            | Single-responsibility class encapsulating one business operation.                            |
| **Widget**             | Flutter's fundamental UI building block.                                                     |
