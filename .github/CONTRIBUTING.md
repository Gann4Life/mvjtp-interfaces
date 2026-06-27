Este archivo es la **única fuente de verdad sobre cómo trabajamos en equipo**:
ramas, commits, pull requests y revisión. Las convenciones de código van al
final, en *"Reglas del código"*.

> **Herramientas:** no necesitás terminal. Todo lo de abajo se puede hacer desde
> **GitHub Desktop**.

---

## Modelo de ramas

Trabajamos con un **tronco único** (single-trunk): `main` es la única rama
permanente y siempre tiene que estar sana (que abra y corra en Godot). Todo lo
demás dura poco y sale de `main`.

```
⚙️ feature/* · fix/* · chore/*  ──PR──▶  🌳 main  ──tag al entregar──▶  🏷️ vX.Y.Z (entrega)
```

| Rama | Qué es | Cuánto vive |
|--------|---------|----------|
| 🌳 **main** | El tronco. Siempre verde y entregable. **Protegida por convención** — nada de push directo. | Permanente |
| ⚙️ **feature/\*** · **fix/\*** · **chore/\*** | Tu rama de trabajo con un cambio propuesto. | Días — se borra al mergear |
| 🚀 **release/\*** | Opcional, por si hace falta estabilizar antes de una entrega del TP. | Solo mientras se prepara la entrega |

### Nombre de las ramas — [Conventional Branch](https://conventionalbranch.org/) (obligatorio)

El formato es **`<tipo>/<descripcion>`**. `main` es el tronco y no lleva prefijo.

| Tipo | Para qué |
|------|---------|
| `feature/` | Funcionalidades nuevas (ej. `feature/healthbar`) |
| `fix/` | Arreglar bugs (ej. `fix/drag-del-puck`) |
| `chore/` | Cosas que no son código — docs, dependencias, tooling (ej. `chore/actualizar-gitignore`) |
| `release/` | Preparar una entrega, con la versión en la descripción (ej. `release/v0.2.0`) |

**Reglas** (según la spec):

- Solo minúsculas `a–z`, dígitos `0–9` y guiones. **Nada** de mayúsculas,
  guiones bajos, espacios, barras más allá del prefijo, ni paréntesis.
- Los puntos van **solo** en el número de versión de `release/` (ej.
  `release/v0.2.0`).
- Sin guiones ni puntos repetidos, ni al principio ni al final (ej.
  `feature/nueva--ui` ❌, `feature/-nueva-ui` ❌).
- Si querés, sumá el número de issue: `feature/issue-12-healthbar`.
- Un objetivo por rama, y la borrás después de mergear. No reutilices una rama
  personal de larga vida — siempre arrancá fresco desde `main`.

> **Ramas hechas por IA.** Lo que genera un agente de IA usa el prefijo de
> agente de la spec — ej. `claude/...` o el neutral `ai/...` — así se distinguen
> de un vistazo en la revisión.

> **Cómo se controla.** Estos nombres no son solo una sugerencia: CI los valida
> en cada PR con [`commit-check-action`](https://github.com/commit-check/commit-check-action)
> (revisa el nombre de la rama y los mensajes de commit), así que una rama mal
> nombrada hace fallar el check. Podés correr
> [`commit-check`](https://github.com/commit-check/commit-check) localmente para
> agarrar los errores antes de pushear.

## Pull requests, pruebas y merge

- 🤖 **A dónde va el PR:** todo PR sale **de tu rama `feature/*` · `fix/*` ·
  `chore/*` hacia `main`**. Como `main` está protegida, esta es la única forma de
  que el trabajo entre.
- 🧪 **No te quedes atrás:** cada tanto traé `main` *a* tu rama, así probás
  contra lo último que se integró y resolvés conflictos temprano.
- ✅ **Verde antes de mergear:** un PR entra cuando CI pasa (nombres de rama y de
  commit válidos) y alguien lo revisó. Probá el cambio en el editor de Godot
  antes de abrirlo. No mergees tu propio PR sin que lo revisen.
- 🙅 **No** pushees a `main` directo ni te saltees la prueba en el editor.
- 📲 **Pusheá** tu rama cuando quieras que te ayuden/revisen, o cuando esté listo.

### ¿A dónde pusheo? (la versión corta)

> **En el día a día solo se pushean ramas `feature/*` · `fix/*` · `chore/*` y se
> abren PR hacia `main`. A `main` nunca se le pushea directo.**

## Entregas y etiquetas (tags)

Versionamos con [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`.
Para un trabajo práctico alcanza con algo simple:

- Estamos **pre-1.0** (`0.x`) mientras el TP está en desarrollo.
- **MINOR** = algo nuevo (una interfaz, un sistema) · **PATCH** = arreglos.
- Marcá cada **entrega** con un tag **anotado** que empiece con `v` (ej.
  `v0.1.0`). Así cada entrega queda atada al código exacto que mostramos.
- Si una entrega necesita estabilizarse, podés cortar una rama `release/vX.Y`
  desde `main`, arreglar solo bugs ahí y después poner el tag.

## Commits

- 💬 **Mensajes:** usá [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `chore:`, …). Formato: `tipo(enfoque): descripción`. Poné `!`
  antes de los dos puntos si el cambio rompe compatibilidad (ej.
  `feat(persistencia)!: cambiar formato de guardado`).
- 🏷️ **Enfoque/scope (recomendado, no obligatorio):** nombrá entre paréntesis el
  sistema que tocaste — ej. `feat(ui): agregar healthbar`,
  `fix(input): corregir drag del puck`. Mantiene el historial fácil de leer por
  sistema. Un `chore: actualizar dependencias` sirve igual cuando no aplica un
  sistema puntual. Scopes sugeridos (nuestros sistemas en `Scripts/`): `ui`,
  `gui`, `hud`, `menu`, `options`, `gameplay`, `input`, `physics`, `project` —
  más `docs` y `build` cuando haga falta.
- 📖 **Contá el porqué** del cambio, no solo qué archivos se movieron.
- 🔨 **Amend** para arreglitos de seguimiento sobre el commit relacionado — **pero
  solo antes de pushear/compartir la rama.** Una vez pusheado, mejor un commit
  nuevo para no reescribir historia compartida.
- ⬆️ Commiteá local y evitá commits vacíos o sin sentido.

## Reglas del código

- 👲 **Idioma:**
  - **Código** (identificadores, tipos, nombres de nodos) → **inglés**. Siempre.
    Es la convención de GDScript y de la documentación de Godot.
  - **Prosa** (docs, mensajes de commit, descripciones de PR) → **español**.
  - Un idioma por archivo; no los mezcles. Los docs del proyecto (README, este
    archivo) van en español.
- 🧩 **Comentarios de doc:** documentá las APIs públicas con los comentarios de
  documentación de GDScript (`##`). Evitá narrar línea por línea salvo para marcar
  algo no obvio para el resto del equipo.
- 📊 **Código que se explica solo:** mejor un nombre descriptivo que un comentario.
- 📝 **Convenciones de GDScript:** seguí la
  [guía de estilo oficial](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
  — `snake_case` para variables y funciones, `PascalCase` para clases y nodos,
  `CONSTANT_CASE` para constantes. Usá type hints (`var hp: int = 100`) siempre
  que puedas.
