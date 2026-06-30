# FAW Implementation Roadmap

## Priority Matrix

| Priority | Item                                    | Effort | Impact | Depends On |
| -------- | --------------------------------------- | ------ | ------ | ---------- |
| P0       | Standards & Rules                       | Low    | High   | —          |
| P0       | Agent Definitions                       | Low    | High   | —          |
| P1       | Context Documents                       | Medium | High   | P0         |
| P1       | Core Skills (Arch, Bloc, Repository)    | Medium | High   | P0         |
| P2       | Skills (Testing, Firebase, DI, Freezed) | Medium | Medium | P0         |
| P2       | Planning Documents                      | Medium | High   | P1         |
| P3       | Templates                               | Medium | Medium | P2         |
| P3       | Checklists                              | Low    | Medium | P2         |
| P3       | Playbooks                               | Medium | Medium | P1 + P2    |
| P4       | Memory System                           | High   | Medium | P3         |

## Phase 1: Foundation (P0)

| #   | Task                       | File                           | Owner     |
| --- | -------------------------- | ------------------------------ | --------- |
| 1   | Flutter code standards     | `standards/flutter.md`         | Architect |
| 2   | Architect agent definition | `agents/architect.md`          | Architect |
| 3   | Flutter Programmer agent   | `agents/flutter_programmer.md` | Architect |
| 4   | Tech stack reference       | `context/tech_stack.md`        | Architect |
| 5   | Package versions lock      | `context/package_versions.md`  | Architect |

**Status:** ✅ Complete

## Phase 2: Context & Core Skills (P1)

| #   | Task                     | File                              | Owner      |
| --- | ------------------------ | --------------------------------- | ---------- |
| 1   | Project context document | `context/project_context.md`      | Architect  |
| 2   | Architecture summary     | `context/architecture_summary.md` | Architect  |
| 3   | Business rules           | `context/business_rules.md`       | Programmer |
| 4   | Coding style guide       | `context/coding_style.md`         | Programmer |
| 5   | Clean Architecture skill | `skills/clean_architecture.md`    | Architect  |
| 6   | Bloc skill               | `skills/bloc.md`                  | Programmer |
| 7   | Repository skill         | `skills/repository.md`            | Programmer |
| 8   | Planner                  | `planning/planner.md`             | Architect  |

**Status:** ✅ Complete

## Phase 3: Advanced Skills & Planning (P2)

| #   | Task                          | File                     | Owner      |
| --- | ----------------------------- | ------------------------ | ---------- |
| 1   | Testing skill                 | `skills/testing.md`      | Programmer |
| 2   | Firebase skill                | `skills/firebase.md`     | Programmer |
| 3   | DI skill                      | `skills/di.md`           | Programmer |
| 4   | Freezed skill                 | `skills/freezed.md`      | Programmer |
| 5   | Glossary                      | `context/glossary.md`    | Architect  |
| 6   | Constraints                   | `context/constraints.md` | Architect  |
| 7   | Feature planning doc template | `planning/{feature}.md`  | Programmer |
| 8   | Roadmap                       | `planning/roadmap.md`    | Architect  |

**Status:** ✅ Complete

## Phase 4: Templates, Checklists & Playbooks (P3)

| #   | Task                          | File                         | Owner      |
| --- | ----------------------------- | ---------------------------- | ---------- |
| 1   | Bloc template                 | `templates/bloc.md`          | Programmer |
| 2   | Freezed model template        | `templates/freezed_model.md` | Programmer |
| 3   | Repository template           | `templates/repository.md`    | Programmer |
| 4   | UseCase template              | `templates/usecase.md`       | Programmer |
| 5   | Screen template               | `templates/screen.md`        | Programmer |
| 6   | Code review checklist         | `checklists/code_review.md`  | Architect  |
| 7   | QA checklist                  | `checklists/qa.md`           | QA         |
| 8   | Launch checklist              | `checklists/launch.md`       | PM         |
| 9   | New feature playbook          | `playbooks/new_feature.md`   | Programmer |
| 10  | CI/CD playbook                | `playbooks/ci_cd.md`         | DevOps     |
| 11  | Code review playbook          | `playbooks/code_review.md`   | Architect  |
| 12  | Bug fix playbook              | `playbooks/bug_fix.md`       | Programmer |
| 13  | Architecture Decision Records | `planning/adr.md`            | Architect  |

**Status:** ✅ Core complete (templates, checklists, 3 playbooks created)

## Phase 5: Memory System (P4)

| #   | Task                     | File                        | Owner     |
| --- | ------------------------ | --------------------------- | --------- |
| 1   | Session memory structure | `context/session_memory.md` | Architect |
| 2   | Decision log             | `context/decisions.md`      | Architect |
| 3   | Lessons learned          | `context/lessons.md`        | Team      |
| 4   | FAQ document             | `context/faq.md`            | Team      |
| 5   | Runbook                  | `playbooks/runbook.md`      | DevOps    |

**Status:** 🔲 Not started

## Phase 6: Automation (Future)

| #   | Task                                       | Effort | Notes                                                  |
| --- | ------------------------------------------ | ------ | ------------------------------------------------------ |
| 1   | GitHub Actions workflow for FAW validation | Medium | Lint markdown, check links                             |
| 2   | FAW CLI tool (faw init)                    | High   | Scaffold new project with all docs                     |
| 3   | AI context injection script                | Medium | Automatically inject relevant FAW docs into AI context |
| 4   | FAW VSCode extension                       | High   | Snippets, template insertion, navigation               |

**Status:** 🔲 Not started

## Recommendations

1. **Start every new project** by copying `.flutter-ai/` into the project root.
2. **Register `.flutter-ai/` in `.gitignore` exclusion** list — it belongs in the repo.
3. **Agent prompts** should reference these documents via relative paths.
4. **FAW is living** — update roadmap as gaps are discovered.
