# ScrumTutor iOS — Progreso de Desarrollo
> Documento de continuidad — Estado al 14 de abril 2026

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

## Estructura de carpetas del proyecto

```
ScrumTutor/
├── App/
│   ├── ScrumTutorApp.swift
│   ├── ContentView.swift
│   └── MainTabView.swift
│
├── Network/
│   ├── APIConstants.swift
│   ├── NetworkManager.swift
│   └── KeychainManager.swift
│
├── Models/
│   ├── AuthModels.swift
│   ├── UserModels.swift
│   ├── ProjectModels.swift
│   ├── MemberModels.swift
│   ├── SprintModels.swift
│   ├── HistoriaModels.swift
│   ├── TareaModels.swift
│   ├── ComentarioModels.swift
│   ├── NotificacionModels.swift
│   ├── QuizModels.swift
│   └── TipModels.swift
│
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── ProyectosViewModel.swift
│   ├── BacklogViewModel.swift
│   ├── SprintViewModel.swift
│   ├── TareaViewModel.swift
│   ├── ComentarioViewModel.swift
│   ├── MiembrosViewModel.swift
│   └── NotificacionViewModel.swift
│
├── Views/
│   ├── Auth/
│   │   ├── LoginView.swift
│   │   └── RegisterView.swift
│   ├── Proyectos/
│   │   ├── ProyectosView.swift
│   │   ├── ProyectoDetailView.swift
│   │   ├── CreateProjectView.swift
│   │   └── EditProjectView.swift
│   ├── Backlog/
│   │   ├── BacklogView.swift
│   │   ├── CreateHistoriaView.swift
│   │   ├── EditHistoriaView.swift
│   │   └── HistoriaDetailView.swift
│   ├── Sprints/
│   │   ├── SprintsView.swift
│   │   ├── SprintDetailView.swift
│   │   ├── CreateSprintView.swift
│   │   ├── EditSprintView.swift
│   │   ├── BacklogSprintView.swift
│   │   └── CalendarioView.swift
│   ├── Kanban/
│   │   ├── KanbanView.swift
│   │   ├── KanbanColumnaView.swift (dentro de KanbanView.swift)
│   │   ├── TareaCardView.swift
│   │   ├── TareaDetailView.swift
│   │   ├── CreateTareaView.swift
│   │   └── EditTareaView.swift
│   ├── Comentarios/
│   │   └── ComentariosView.swift
│   ├── Miembros/
│   │   ├── MiembrosView.swift
│   │   └── InvitarMiembroView.swift
│   ├── Notificaciones/
│   │   ├── NotificacionesView.swift
│   │   ├── NotificacionRowView.swift (dentro de NotificacionesView.swift)
│   │   └── ModalInvitacionView.swift
│   ├── Perfil/         ← PENDIENTE
│   └── Learning/       ← PENDIENTE
│
└── Utilities/
    ├── JWTDecoder.swift
    └── Extensions.swift
```

---

## Archivos especiales

### `PlaceholderViews.swift`
Archivo temporal con vistas vacías para que compile mientras se implementan los módulos reales. Al finalizar todos los módulos se elimina. Actualmente contiene:

```swift
struct PerfilView: View { ... }    // ← pendiente implementar
struct LearningView: View { ... }  // ← pendiente implementar
```

### `Extensions.swift`
```swift
extension Notification.Name {
    static let proyectosDidChange = Notification.Name("proyectosDidChange")
    static let miembrosDidChange  = Notification.Name("miembrosDidChange")
}
```

---

## Módulos completados

### ✅ Capa base (Network)

**`APIConstants.swift`** — Centraliza todas las rutas del backend con enums anidados. Métodos estáticos para rutas con parámetros dinámicos.

**`KeychainManager.swift`** — Singleton. Guarda/lee/borra el JWT en Keychain usando `kSecClassGenericPassword`. Métodos: `saveToken`, `getToken`, `deleteToken`, `hasToken`.

**`JWTDecoder.swift`** — Decodifica el payload Base64url del JWT sin librerías externas. Métodos: `decode`, `getEmail`, `getUserId`, `getNombre`, `getRol`, `isExpired`, `isValid`.

**`NetworkManager.swift`** — Singleton con tres métodos:
- `request<T: Decodable>` — GET/POST/PUT con respuesta decodificable
- `requestEmpty` — DELETE/PUT sin respuesta esperada
- `requestIgnoringResponse` — Acepta cualquier 2xx ignorando el body

Todas las peticiones inyectan automáticamente `Authorization: Bearer <token>`. Incluye print de debug: `📦 Response [path]: json`.

---

### ✅ Models (todos los structs Codable)

| Archivo | Structs |
|---|---|
| AuthModels | `LoginRequest`, `RegisterRequest`, `GoogleAuthRequest`, `AuthResponse` |
| UserModels | `Usuario`, `RolSistema`, `UpdateUserRequest` |
| ProjectModels | `Proyecto`, `CreateProjectRequest`, `UpdateProjectRequest` |
| MemberModels | `Miembro`, `RolProyecto`, `AddMemberRequest`, `InvitacionRequest` |
| SprintModels | `Sprint`, `CreateSprintRequest`, `UpdateSprintRequest` |
| HistoriaModels | `Historia`, `CreateHistoriaRequest`, `UpdateHistoriaRequest` |
| TareaModels | `Tarea`, `CreateTareaRequest`, `UpdateTareaRequest`, `AsignarTareaRequest` |
| ComentarioModels | `Comentario`, `CreateComentarioRequest` |
| NotificacionModels | `Notificacion`, `CreateNotificacionRequest` |
| QuizModels | `Quiz`, `QuizPregunta`, `ProgresoRequest` |
| TipModels | `Tip` |

**Nota importante — `Miembro`:** El backend devuelve `idMiembro` (no `id`) y `usuarioNombre` (no `nombreUsuario`). El struct usa `var id: Int { idMiembro }` para conformar `Identifiable`.

---

### ✅ Auth

**`AuthViewModel`** — `@MainActor ObservableObject`. Métodos: `checkSession`, `login`, `register`, `logout`. El JWT se guarda en Keychain al hacer login/registro exitoso.

**`LoginView`** — Campos `etEmail` + `etPassword`, botón login, enlace a registro. Navegación con `NavigationStack` + `navigationDestination`.

**`RegisterView`** — Campos nombre, correo, contraseña. Validación local de campos vacíos.

**`ContentView`** — Punto de entrada. Muestra `LoginView` o `MainTabView` según `authVM.isLoggedIn`. Llama `checkSession()` en `onAppear`.

**`ScrumTutorApp`** — `@StateObject` de `AuthViewModel` inyectado como `environmentObject`.

**`MainTabView`** — 4 tabs: Proyectos, Notificaciones, Perfil (temporal con logout), Learning.

---

### ✅ Proyectos

**`ProyectosViewModel`** — Métodos: `cargarProyectos`, `crearProyecto`, `editarProyecto`, `eliminarProyecto`, `esCreador`. Usa `NotificationCenter` para escuchar `proyectosDidChange`.

**`ProyectosView`** — Lista de proyectos con `NavigationStack`. Swipe para editar/eliminar (solo si es creador). Botón `+` en toolbar. Escucha `proyectosDidChange` con `.onReceive`.

**`ProyectoRowView`** — Fila con nombre, descripción, fechas. Swipe actions condicionales según `esCreador`.

**`CreateProjectView`** — Form con `DatePicker` para fechas. Formato `yyyy-MM-dd`.

**`EditProjectView`** — Precarga datos del proyecto. Mismo form que crear.

**`ProyectoDetailView`** — `TabView` con 3 tabs: Backlog, Sprints, Miembros. Sin `NavigationStack` interno (hereda del padre de `ProyectosView`).

---

### ✅ Backlog (Historias de usuario)

**`BacklogViewModel`** — Computed vars: `sinSprint` (idSprint == nil), `conSprint` (idSprint != nil). Métodos: `cargarHistorias`, `crearHistoria`, `editarHistoria`, `eliminarHistoria`.

**`BacklogView`** — `ZStack` con botón flotante `+` (56x56, azul, círculo). Sin `NavigationStack` propio. Dos secciones: "Sin sprint asignado" y "Asignadas a sprint". Swipe para eliminar.

**`HistoriaRowView`** — Badges de prioridad (rojo/naranja/verde) y estado (gris). Badge de sprint si tiene asignado.

**`CreateHistoriaView`** — Form con Pickers de prioridad y estado (posición + 1 = idPrioridad/idEstado).

**`EditHistoriaView`** — Dividido en subvistas (`seccionInfo`, `seccionConfiguracion`, `seccionSprint`, `seccionError`) para evitar error de type-check del compilador. Carga sprints del proyecto al aparecer. Filtra sprints cerrados (idEstado == 3). Permite asignar/desasignar sprint. Footer informativo según selección.

**`HistoriaDetailView`** — Muestra todos los campos. Botón editar en toolbar.

**`SprintOpcionRow`** — Subvista separada para cada opción de sprint en el selector.

---

### ✅ Sprints

**`SprintViewModel`** — Métodos: `cargarSprints`, `crearSprint`, `editarSprint`, `eliminarSprint`. Al crear siempre envía `idEstado: 1`.

**`SprintsView`** — `ZStack` con botón flotante `+`. Lista con swipe para eliminar. Navega a `SprintDetailView`.

**`SprintRowView`** — Badge de estado con color (gris=Planeación, azul=Activo, verde=Completado).

**`CreateSprintView`** — Form con `DatePicker`. Siempre crea con estado PLANIFICADO.

**`EditSprintView`** — Precarga datos. Permite cambiar estado con Picker.

**`SprintDetailView`** — `TabView` con 3 tabs: Backlog del sprint, Kanban, Calendario. Botón editar en toolbar.

**`BacklogSprintView`** — Lista historias del sprint via `GET /api/sprints/{id}/historias`.

**`CalendarioView`** — Muestra fechas inicio/fin, duración en días, estado del sprint.

---

### ✅ Kanban + Tareas

**`TareaViewModel`** — Computed vars: `porHacer` (idEstado==1), `enProgreso` (idEstado==2), `completadas` (idEstado==3). Métodos: `cargarTareas`, `crearTarea`, `editarTarea`, `cambiarEstado`, `eliminarTarea`.

**`KanbanView`** — `ScrollView` horizontal con 3 columnas. Botón flotante `+`. Las columnas tienen header con color y contador.

**`KanbanColumnaView`** — Columna individual con header y tarjetas. Ancho fijo 260pt.

**`TareaCardView`** — Tarjeta con título, descripción (2 líneas), responsable, fecha límite. Botones `<` y `>` para mover entre estados. Botón info para ver detalle.

**`TareaDetailView`** — Sheet con NavigationStack propio. Link a comentarios. Botón editar.

**`CreateTareaView`** — Toggle para activar/desactivar fecha límite. Estado inicial con Picker.

**`EditTareaView`** — Precarga todos los campos. Mantiene `idAsignadoA` existente.

---

### ✅ Comentarios

**`ComentarioViewModel`** — Métodos: `cargarComentarios`, `agregarComentario`.

**`ComentariosView`** — Estilo chat. `ScrollViewReader` con scroll automático al último comentario. Input con `@FocusState`. Botón enviar deshabilitado si texto vacío.

**`ComentarioRowView`** — Avatar con inicial del nombre (círculo azul). Nombre + fecha formateada. Fondo gris redondeado.

---

### ✅ Miembros

**`MiembrosViewModel`** — Métodos: `cargarMiembros`, `cargarRoles`, `buscarUsuario`, `invitarMiembro`, `enviarNotificacionInvitacion` (privado), `eliminarMiembro`, `esProductOwner`. Filtra `idRolProyecto == 1` (Product Owner) de los roles disponibles para invitar.

**`MiembrosView`** — Lista con swipe eliminar (solo si es Product Owner). Botón flotante `+` visible solo si es Product Owner. Escucha `miembrosDidChange`.

**`MiembroRowView`** — Avatar con inicial. Badge de rol. Badge "Pendiente" si `invitacion == false`.

**`InvitarMiembroView`** — Busca usuario por correo. Muestra preview del usuario encontrado. Picker de rol con `.segmented`. Botón "Invitar" aparece solo después de encontrar usuario.

**Nota backend:** `invitacion = false` significa pendiente, `invitacion = true` significa aceptado. El backend devuelve solo miembros con `invitacion = true` en `GET /miembros`. Los pendientes están en `GET /miembros/pendientes`.

---

### ✅ Notificaciones

**`NotificacionViewModel`** — Métodos: `cargarNotificaciones`, `marcarLeida`, `eliminarNotificacion`, `buscarMiembroPendiente` (privado), `aceptarInvitacion`, `rechazarInvitacion`. Solo muestra notificaciones con `leido == false`.

**`NotificacionesView`** — Lista de notificaciones. Icono diferente según tipo (idTipo == 5 = invitación).

**`NotificacionRowView`** — Abre `ModalInvitacionView` si es invitación (idTipo == 5).

**`ModalInvitacionView`** — Carga nombre del proyecto. Botones Aceptar (PUT invitacion=true + marcar leída) y Rechazar (DELETE miembro + eliminar notificación). Al aceptar lanza `proyectosDidChange` y `miembrosDidChange`.

**Flujo de aceptar invitación:**
1. GET `/miembros/pendientes` → encontrar `idMiembro` del usuario actual
2. PUT `/miembros/{idMiembro}/invitacion` con `{ invitacion: true }`
3. PUT `/notificaciones/{id}/leer`
4. Post `proyectosDidChange` → recarga lista de proyectos
5. Post `miembrosDidChange` → recarga lista de miembros

---

## Módulos pendientes

### ⏭ Perfil
- ViewModel: `PerfilViewModel`
- Vistas: `PerfilView`
- Flujo:
  1. Decodificar JWT → extraer `sub` (correo)
  2. `GET /api/usuarios/buscar?correo={correo}` → mostrar nombre, correo, rol
  3. `GET /api/roles` → poblar Picker de roles para editar
  4. `PUT /api/usuarios/{id}` con `{ nombre, idRol }`
  5. Botón cerrar sesión → `KeychainManager.deleteToken()` + `authVM.logout()`

### ⏭ Learning
- ViewModel: `QuizViewModel` (falta), tips sin ViewModel propio
- Vistas: `LearningView`, `DetalleTemaView`, `QuizView`
- Flujo tips:
  1. `GET /api/tips` → lista de tarjetas (seccion = título, mensaje = contenido)
  2. Al tocar → `DetalleTemaView` con título y contenido
- Flujo quizzes:
  1. `GET /api/quizzes` → lista de quizzes
  2. Al tocar → `GET /api/quizzes/{id}` → lista de preguntas
  3. Mostrar pregunta con 3 opciones RadioButton
  4. Al terminar → `POST /api/quizzes/{id}/progreso` con `{ puntaje: Double }`

### ⏭ Navegación final
- Revisar y limpiar toda la navegación
- Eliminar `PlaceholderViews.swift`
- Conectar `PerfilView` real en `MainTabView` con logout
- Revisar `TabView` anidados

### ⏭ Documentación de funciones (formato MMS)
La rúbrica exige documentar cada función con 8 parámetros:
- Entradas
- Salidas
- Retorno
- Función
- Variables
- Fecha
- Autor
- Rutinas

---

## Bugs conocidos y soluciones aplicadas

| Problema | Causa | Solución |
|---|---|---|
| Error decoding Miembro | Backend usa `idMiembro` no `id`, `usuarioNombre` no `nombreUsuario` | Actualizar struct con nombres correctos + `var id: Int { idMiembro }` |
| Botón `+` Backlog no aparece | `NavigationStack` anidados | Quitar `NavigationStack` de `BacklogView`, usar `ZStack` + botón flotante |
| Compiler type-check timeout | Form con demasiadas subexpresiones | Dividir en `@ViewBuilder` vars separadas |
| Invitación no acepta/rechaza | iOS mandaba `invitacion: false` al aceptar | Cambiar a `invitacion: true` para aceptar, DELETE para rechazar |
| Proyectos no aparecen al invitado | `GET /api/proyectos` filtraba solo por creador | Backend usa `findAllByUsuarioOrMiembroAceptado` — funciona cuando `invitacion = true` |
| `requestIgnoringResponse` en enum | Método pegado dentro de `NetworkError` en vez de `NetworkManager` | Mover al scope correcto de la clase |

---

## Notas importantes del backend

- **JWT claims:** `sub` = correo, `uid` = Long del usuario, `rol`, `nombre`, `exp`
- **Duración JWT:** 120 minutos — no hay refresh token, hay que re-login
- **Formato fechas:** `yyyy-MM-dd` para Date, `yyyy-MM-dd'T'HH:mm:ss` para DateTime
- **Estados Sprint:** 1=Planeación, 2=Activo, 3=Completado
- **Estados Historia/Tarea:** 1=Por hacer, 2=En progreso, 3=Completado
- **Prioridades:** 1=Alta, 2=Media, 3=Baja
- **Roles proyecto:** 1=Product Owner (excluir de selector), 2=Scrum Master, 3=Desarrollador, 4=QA, 5=Stakeholder
- **idTipo notificación:** 5 = Invitación a proyecto
- **ngrok:** El dominio estático es `nonimplemental-frowningly-victor.ngrok-free.dev` — debe estar corriendo localmente

---

## Estado del `PlaceholderViews.swift` actual

```swift
import SwiftUI

struct PerfilView: View {
    var body: some View { Text("Perfil") }
}
struct LearningView: View {
    var body: some View { Text("Learning") }
}
```

---

## Orden de trabajo para retomar

```
1. PerfilViewModel.swift        → ViewModels/
2. PerfilView.swift             → Views/Perfil/
3. QuizViewModel.swift          → ViewModels/
4. LearningView.swift           → Views/Learning/
5. DetalleTemaView.swift        → Views/Learning/
6. QuizView.swift               → Views/Learning/
7. Navegación final             → limpiar TabViews, eliminar PlaceholderViews
8. Documentación formato MMS    → comentarios en todas las funciones principales
```
