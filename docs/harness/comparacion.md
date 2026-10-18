# Comparación: con harness y sin harness

Ticket: FLOW-1 «Implementar login en el frontend». Misma instrucción en las dos copias: en la
con harness, `/priority-ticket` más el texto del Prompt 8 de `prompts.md` (pide explícitamente los gaps
entre el ticket y el backend y los archivos a crear y modificar); en la pelada, ese mismo texto a mano
precedido de la instrucción que lleva la skill (traer el ticket, resumir criterios, entrar en plan mode).
Solo se comparan los planes: no se aplicó ninguno. Constante en las dos copias: el `~/.claude/CLAUDE.md`
global del usuario, el MCP de engram a nivel usuario y el conector de Atlassian de la cuenta de claude.ai,
que dio acceso a Jira a la pelada aunque no tenga `.mcp.json` (la pieza 2 del harness resultó redundante
en esta máquina). La pelada no tiene `CLAUDE.md`, `.mcp.json` ni
skills del proyecto. El plan con harness está guardado tal cual en
`claude-plan-con-harness.txt`. El plan sin harness, en `claude-plan-sin-harness.txt`.

## Parte A: las cuatro casillas

### 1. Qué archivos propone tocar, contados

**Con harness:** 19 archivos. El plan dice «about 14 new, 5 modified», pero contando lo que lista
son 13 nuevos y 6 modificados.

- Modificados (6): `frontend/package.json`, `vite.config.ts`, `tsconfig.app.json`, `src/index.css`,
  `src/main.tsx`, `src/App.tsx`.
- Nuevos (13): `components.json`, 5 componentes shadcn en `src/components/ui/`, `src/lib/api.ts`,
  `src/lib/auth.tsx`, 3 páginas en `src/pages/`, `src/components/RequireAuth.tsx`,
  `frontend/.env.example`.
- Backend: 0.

**Sin harness:** 23 archivos como mínimo (8 modificados, 15 nuevos más un número sin
concretar de tests `*.test.tsx`).

- Modificados (8): `frontend/package.json`, `vite.config.ts`, `tsconfig.app.json`, `src/main.tsx`,
  `src/App.tsx`, `src/index.css`, `src/App.css` y **`prompts.md`**, que propone editar «per exercise
  convention» como parte de la implementación.
- Nuevos (15 + tests): `components.json`, `.env.example`, `src/lib/api.ts`, `src/lib/utils.ts`,
  `src/auth/AuthContext.tsx`, `src/auth/ProtectedRoute.tsx`, 3 páginas, 5 componentes shadcn,
  `src/test/setup.ts` y los tests (Vitest + Testing Library + MSW).
- Backend: 0.

### 2. Qué convenciones del proyecto respetó y cuáles no

**Con harness.** Respetó, una a una (todas vienen de `CLAUDE.md`):

- Rama nueva antes de tocar código (`feat/frontend-auth`).
- No modificar el backend: cero archivos de `backend/` en el plan.
- Leer el validador (`app/validators/user.ts`) antes de montar formularios: detectó `fullName`,
  `passwordConfirmation`, password de 8 a 32 y email de 254 como huecos entre el ticket y la API.
- Desenvolver `data` en todas las respuestas; login devuelve `{ data: { user, token } }`.
- Token como `Authorization: Bearer <token>` con prefijo `oat_`; logout llama a `POST /account/logout`.
- Cierre del trabajo: `/commit`, push, `gh pr create`, `adversarial-reviewer` y solo la URL del PR en
  el chat.
- Sabía que el lint es oxlint y que el frontend no tiene test runner, y lo asumió en la verificación.

No respetó, o quedó flojo:

- La forma de los errores (422 con `errors[]`, 400/401 para credenciales) la deja «a confirmar con
  curl» en vez de leerla del código del backend, que `CLAUDE.md` señala como fuente de verdad.
- El conteo de archivos del propio plan no cuadra con su lista (ver casilla 1).

**Sin harness:** No había ninguna convención escrita en esa copia (sin `CLAUDE.md`), así que lo que
sigue es lo que acertó o falló por su cuenta frente a las mismas convenciones:

- Acertó solo: no tocar el backend (0 archivos), leer el validador y detectar `fullName`,
  `passwordConfirmation`, 8–32 y 254, desenvolver `data`, `Authorization: Bearer`, logout por
  `POST /account/logout`. Ojo: el prompt le pedía explícitamente «los gaps entre el ticket y el
  backend», así que parte de esto lo dirigió el prompt, no el proyecto.
- No cumplió ninguna regla de proceso: ni rama nueva, ni `/commit`, ni `gh pr create`, ni revisor, ni
  «solo la URL del PR». No aparecen en el plan.
- Trata `prompts.md` como código a modificar; la copia con harness sabía que es un entregable aparte.
- Agrega test runner (Vitest, Testing Library, MSW) que el proyecto no tiene y el ticket no pide; la
  copia con harness respetó que el frontend no tiene tests y verificó con lint + build + manual.
- Igual que la copia con harness, deja la forma de los errores «a confirmar en runtime».

### 3. Cuántas veces tuve que intervenir

**Con harness:** 0. `/priority-ticket` trajo FLOW-1, resumió los criterios, entró en plan mode y presentó el plan de corrido, sin corregir, aclarar ni repetir nada. No aprobé el plan, así que el ticket siguió en «To Do».

**Sin harness:** 0. Llegó a Jira por el conector de la cuenta de claude.ai, leyó el backend y
presentó el plan sin pedir nada. Tampoco se aprobó.

### 4. Qué me tocaría arreglar a mano antes de enseñarlo

**Con harness:**

- La forma de los errores de la API: el plan la deja «a confirmar con curl». La leería del handler de
  excepciones del backend y la fijaría en `api.ts`. Además, debería estar descrita explícitamente en el
  harness (`CLAUDE.md`), porque hoy no lo está.
- Token en `localStorage`: el plan lo acepta como riesgo XSS «por el ejercicio» sin más. Un riesgo no se
  deja sin colegiar o documentar antes de probar; esa regla también debería formar parte del harness.
- Compatibilidad de shadcn y Tailwind con Vite 8 y TS 6: el plan lo marca como riesgo sin resolver.
  No se deja sin resolver antes de ejecutar; lo probaría antes de prometer el orden de trabajo.
- Signup sin auto-login: el backend devuelve token en el signup y el plan decide redirigir a `/login`.
  Es una decisión de producto tomada sin preguntar; habría que explicitarla y consultarla.

**Sin harness:**

- Sacar `prompts.md` de los archivos a modificar: es un entregable del ejercicio, no código. Lo trató
  como código porque nada escrito en esa copia le decía lo contrario.
- Quitar Vitest, Testing Library y MSW: el ticket no lo pide y el proyecto no lo tiene. Es tooling que
  nadie decidió, metido en el plan por iniciativa del agente.
- Agregarle todo el cierre: rama nueva, commit convencional, PR y revisión. No propone ninguno. En un
  proyecto con más colegas, sin ese cierre escrito en el harness cada uno cerraría los tickets a su
  manera y el resultado sería un desorden de formas distintas de terminar el mismo trabajo. La
  alternativa es un estándar en un documento, pero ya sabemos lo frágil que es un estándar que nadie
  ejecuta: el harness es lo que lo convierte en un paso que el agente da solo.
- La forma de los errores de la API, igual que en el otro lado: leída del backend y fijada en el
  cliente, no «a confirmar en runtime».

## Parte B: las tres líneas

1. **Hasta qué pieza llegué y cuál costó más:** llegué a la 8, las ocho, siguiendo el guión del
   ejercicio pieza por pieza, y ninguna costó más que otra. Lo que me costó no fue montar sino el
   criterio: en un repo con un solo proceso, un solo set de reglas alcanza y se ve a simple vista; lo
   que no tengo resuelto es cómo decidir cuántas skills, hooks y subagentes son suficientes en una
   plataforma con varios flujos, aplicativos y roles, y cómo organizarlos para que no se pisen ni se
   contradigan. Siento que ese rol, el de arquitecto de AI del equipo, hoy no existe y hace falta.
   También eché en falta dos piezas que el guión no trae: una skill de telemetría y una de log interno,
   para saber cómo nos fue en la recuperación del ticket y, si el plan se aprobara, en su ejecución.
2. **Primera diferencia que vi y dónde estaba mirando:** `prompts.md` en la lista de «Files to modify»
   del plan pelado. Lo vi directamente en el plan en la terminal, sin abrir ningún archivo, y mi primera
   reacción fue pensar que la copia estaba contaminada. No lo estaba: las dos copias tienen el mismo
   `prompts.md` del curso, pero solo la copia con harness tenía una línea en `CLAUDE.md` diciendo que
   es un entregable aparte.
3. **Algo escrito en el harness que el agente no cumplió igualmente:** `CLAUDE.md` dice que el backend
   es la fuente de verdad y que hay que leer el validador antes de montar formularios. El validador lo
   leyó, pero la forma de las respuestas de error la dejó «a confirmar con curl durante la
   implementación», exactamente igual que la copia pelada. La línea escrita subió la probabilidad de
   leer el validador; no alcanzó para que fuera también al handler de excepciones.
