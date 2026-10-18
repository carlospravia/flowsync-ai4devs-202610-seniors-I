# Comparación: con harness y sin harness

Ticket FLOW-1 «Implementar login en el frontend». Mismo encargo en las dos copias (Prompts 8 y 9 de
`prompts.md`): en la con harness, `/priority-ticket` más el texto que pide los gaps ticket/backend y los
archivos a crear y modificar; en la pelada, ese mismo texto a mano precedido de la instrucción de la skill.
No se aplicó ningún plan. Constantes en ambas: `~/.claude/CLAUDE.md` global y el conector de Atlassian de
la cuenta de claude.ai, que dio Jira a la pelada aunque no tenga `.mcp.json`.

## Parte A

| | Con harness | Sin harness |
| --- | --- | --- |
| **1. Archivos a tocar** | 19: 6 modificados, 13 nuevos (el plan decía «14 new, 5 modified»). Backend: 0. | 23 o más: 8 modificados, 15 nuevos más tests sin contar. Entre los modificados, **`prompts.md`**. Backend: 0. |
| **2. Convenciones** | Respetó, de `CLAUDE.md`: rama primero; no tocar backend; leer el validador (detectó `fullName`, `passwordConfirmation`, 8–32, 254); desenvolver `data`; `Bearer oat_`; cierre con `/commit`, `gh pr create`, revisor y solo la URL; oxlint y sin test runner. Flojo: forma de los errores «a confirmar con curl»; conteo de archivos que no cuadra con su lista. | No había ninguna escrita. Acertó solo lo técnico (validador, `data`, `Bearer`, logout), empujado por el prompt que pedía los gaps. No cumplió ninguna regla de proceso: ni rama, ni commit, ni PR, ni revisor. Trató `prompts.md` como código. Agregó Vitest + Testing Library + MSW que nadie pidió. Errores también «a confirmar». |
| **3. Intervenciones** | 0. Plan de corrido; no aprobado, ticket sigue en «To Do». | 0. Llegó a Jira por el conector de cuenta; plan de corrido; no aprobado. |
| **4. Arreglar a mano** | Fijar la forma de los errores leyéndola del backend y escribirla en el harness. Token en `localStorage` aceptado sin colegiar: documentar la regla en el harness. Compatibilidad shadcn/Tailwind con Vite 8 marcada como riesgo sin resolver. Signup sin auto-login decidido sin preguntar. | Sacar `prompts.md` del plan. Quitar el test runner. Agregar todo el cierre: sin él, en un equipo cada uno cerraría los tickets a su manera, y un estándar en un documento que nadie ejecuta es frágil. Forma de los errores, igual que enfrente. |

## Parte B

1. **Hasta qué pieza llegué y cuál costó más:** a la 8. La que costó fue la 2, el MCP de Atlassian: lo
   configuré en Claude Desktop creyendo que la terminal lo heredaba, no lo hereda, y recién en el Prompt 7
   quedó en `.mcp.json`. Ironía: la pelada tuvo Jira igual por el conector de la cuenta. Lo que de verdad
   me falta no es montar piezas sino el criterio para decidir cuántas skills, hooks y subagentes bastan en
   una plataforma con varios flujos y roles sin que se pisen; y una skill de telemetría para medirlo.
2. **Primera diferencia y dónde miraba:** `prompts.md` en «Files to modify» del plan pelado, visto en la
   terminal sin abrir nada. Pensé que la copia estaba contaminada; no lo estaba. Las dos tienen el mismo
   `prompts.md` del curso, pero solo una tenía la línea de `CLAUDE.md` que dice que es un entregable.
3. **Escrito en el harness y no cumplido:** la skill `/priority-ticket` exige listar los archivos a crear y
   modificar «(counted)». El plan dijo «about 14 new, 5 modified» y su propia lista suma 13 y 6.
