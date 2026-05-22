# ScrumTutor iOS — Estructura Real del Proyecto
> Generado el 02 de mayo de 2026 · Verificado contra el sistema de archivos

---

## Stack tecnológico

| Elemento | Tecnología |
|---|---|
| Lenguaje | Swift |
| UI Framework | SwiftUI |
| HTTP | URLSession nativo |
| Almacenamiento JWT | Keychain (Security.framework) |
| JSON | Codable nativo |
| Backend | Spring Boot + JWT (HMAC-SHA256) |
| URL base | `https://nonimplemental-frowningly-victor.ngrok-free.dev` |

---

## Estructura real de carpetas

```
ScrumTutor/
├── App/
│   ├── ScrumTutorApp.swift          ✅
│   ├── ContentView.swift            ✅
│   └── MainTabView.swift            ✅
│
├── Network/
│   ├── APIConstants.swift           ✅
│   ├── NetworkManager.swift         ✅
│   └── KeychainManager.swift        ✅
│
├── Models/
│   ├── AuthModels.swift             ✅
│   ├── UserModels.swift             ✅
│   ├── ProjectModels.swift          ✅
│   ├── MemberModels.swift           ✅
│   ├── SprintModels.swift           ✅
│   ├── HistoriaModels.swift         ✅
│   ├── TareaModels.swift            ✅
│   ├── ComentarioModels.swift       ✅
│   ├── NotificacionModels.swift     ✅
│   ├── QuizModels.swift             ✅
│   └── TipModels.swift              ✅
│
├── ViewModels/
│   ├── AuthViewModel.swift          ✅
│   ├── ProyectosViewModel.swift     ✅
│   ├── BacklogViewModel.swift       ✅
│   ├── SprintViewModel.swift        ✅
│   ├── TareaViewModel.swift         ✅
│   ├── ComentarioViewModel.swift    ✅
│   ├── MiembrosViewModel.swift      ✅
│   ├── NotificacionViewModel.swift  ✅
│   ├── PerfilViewModel.swift        ❌ PENDIENTE
│   └── QuizViewModel.swift          ❌ PENDIENTE
│
├── Views/
│   ├── PlaceholderViews.swift       ⚠️ TEMPORAL (contiene PerfilView + LearningView vacíos)
│   │
│   ├── Auth/
│   │   ├── LoginView.swift          ✅
│   │   └── RegisterView.swift       ✅
│   │
│   ├── Proyetos/                    ⚠️ TYPO en nombre (falta 'c' → debería ser "Proyectos")
│   │   ├── ProyectosView.swift      ✅
│   │   ├── ProyectoDetailView.swift ✅
│   │   ├── CreateProjectView.swift  ✅
│   │   └── EditProjectView.swift    ✅
│   │
│   ├── Backlog/
│   │   ├── BacklogView.swift        ✅
│   │   ├── CreateHistoriaView.swift ✅
│   │   ├── EditHistoriaView.swift   ✅
│   │   └── HistoriaDetailView.swift ✅
│   │
│   ├── Sprints/
│   │   ├── SprintsView.swift        ✅
│   │   ├── SprintDetailView.swift   ✅
│   │   ├── CreateSprintView.swift   ✅
│   │   ├── EditSprintView.swift     ✅
│   │   ├── BacklogSprintView.swift  ✅
│   │   └── CalendarioView.swift     ✅
│   │
│   ├── Kanban/
│   │   ├── KanbanView.swift         ✅ (incluye KanbanColumnaView internamente)
│   │   ├── TareaCardView.swift      ✅
│   │   ├── TareaDetailView.swift    ✅
│   │   ├── CreateTareaView.swift    ✅
│   │   └── EditTareaView.swift      ✅
│   │
│   ├── Comentarios/
│   │   └── ComentariosView.swift    ✅
│   │
│   ├── Miembros/
│   │   ├── MiembrosView.swift       ✅
│   │   └── InvitarMiembroView.swift ✅
│   │
│   ├── Notificaciones/
│   │   ├── NotificacionesView.swift ✅
│   │   └── ModalInvitacionView.swift ✅
│   │
│   ├── Perfil/                      ⚠️ CARPETA VACÍA (sin archivos Swift)
│   └── Learning/                    ⚠️ CARPETA VACÍA (sin archivos Swift)
│
└── Utilities/
    ├── JWTDecoder.swift              ✅
    └── Extensions.swift             ⚠️ nombre con espacio inicial (" Extensions.swift")
```

---

## Resumen de estado

| Módulo | Estado |
|---|---|
| Capa Network | ✅ Completo |
| Models (11 archivos) | ✅ Completo |
| Auth (Login + Register) | ✅ Completo |
| Proyectos | ✅ Completo |
| Backlog (Historias) | ✅ Completo |
| Sprints | ✅ Completo |
| Kanban + Tareas | ✅ Completo |
| Comentarios | ✅ Completo |
| Miembros | ✅ Completo |
| Notificaciones | ✅ Completo |
| **Perfil** | ❌ Pendiente — carpeta vacía, ViewModel faltante |
| **Learning (Tips + Quizzes)** | ❌ Pendiente — carpeta vacía, QuizViewModel faltante |
| Documentación formato MMS | ❌ Pendiente |

---

## Discrepancias vs documento de progreso original

| Problema | Detalle |
|---|---|
| Typo en carpeta | `Views/Proyetos/` — le falta la 'c' (debería ser `Proyectos`) |
| `Extensions.swift` | El nombre del archivo tiene un espacio al inicio: `" Extensions.swift"` |
| Carpetas `Perfil/` y `Learning/` | Existen en el sistema de archivos pero están vacías |
| `PlaceholderViews.swift` | Sigue en `Views/` raíz con las vistas temporales de Perfil y Learning |
| `PerfilViewModel.swift` | No existe en `ViewModels/` |
| `QuizViewModel.swift` | No existe en `ViewModels/` |

---

## Orden de trabajo pendiente

```
1. PerfilViewModel.swift          → ViewModels/
2. PerfilView.swift               → Views/Perfil/
3. QuizViewModel.swift            → ViewModels/
4. LearningView.swift             → Views/Learning/
5. DetalleTemaView.swift          → Views/Learning/
6. QuizView.swift                 → Views/Learning/
7. Navegación final               → limpiar TabViews, eliminar PlaceholderViews.swift
8. Renombrar carpeta Proyetos     → Proyectos (corregir typo)
9. Renombrar Extensions.swift     → quitar espacio del nombre
10. Documentación formato MMS     → comentarios en todas las funciones principales
```

---

## Archivos temporales a eliminar al finalizar

- `Views/PlaceholderViews.swift` — reemplazado cuando `PerfilView` y `LearningView` estén implementados
