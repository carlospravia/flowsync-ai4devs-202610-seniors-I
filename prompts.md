# Prompts

Aquí van **todos los prompts que lanzaste** para hacer el ejercicio, en el orden en que los
lanzaste, con el modelo y la herramienta de cada uno.

Esto no es papeleo. Lo que se revisa es **cómo pediste las cosas**, no solo lo que salió: un
resultado flojo con un prompt bueno y un resultado flojo con un prompt vago necesitan feedback
distinto, y sin este archivo no se distinguen.

## Cómo rellenarlo

- Un apartado `## Prompt N` por cada prompt.
- **Pega el prompt tal cual lo lanzaste**, dentro del bloque de código, aunque ocupe diez líneas
  y aunque tenga faltas. No lo reescribas para que quede bien: el que arreglaste mentalmente
  después no es el que lanzaste.
- Incluye también los que **no funcionaron**. Suelen ser los más útiles de leer.
- `Modelo` y `Herramienta` en todos. Si cambiaste de una a otra a mitad, se nota aquí.

Borra el ejemplo de abajo cuando escribas el primero.

---

## Prompt 1

**Modelo:** Sonnet 5.5 1M xHigh
**Herramienta:** Claude Code

```
Crea una skill /priority-ticket: trae el ticket de Jira, usando el MCP de Atlassian, de mayor prioridad asignado a Carlos
  Pravia, en «To Do», resume sus criterios de aceptación, entra en plan mode y propone cómo implementarlo; al aprobar el plan,
  lo mueve a «In Progress».
```

**Qué salió:** Funcionó a la primera, me indicó que tomó dos decisiones: usar currentUser(), que es más robusto que usar mi nombre de usuario como lo puse en el prompt, que puso disable-model-invocation: true, para se ejecute sólo con una invocación intencional y prevenir que se dispare solo. Dice que no probó el skill porque dice que falta el MCP de Atlassian a nivel de proyecto y el nombre exacto de las transiciones (esas sí las puse en el prompt)

## Prompt 2

**Modelo:** Sonnet 5.5 1M xHigh
**Herramienta:** Claude Code

```
Crea Una skill /commit: un commit convencional (tipo(scope): descripción) a partir de los cambios preparados.
```

**Qué salió:** Funcionó a la primera, me indica el cómo funciona: lee el git diff -staged y arma un único commit tipo(scope): descripción. También tomó decisiones como evitar el co-authored-by porque el CLAUDE.md lo prohíbe, mensaje en inglés, también el disable-model-invocation: true y la lista de allowed-tools para no pedir permisos en cada paso. Sigue sin probarlo.

## Prompt 3

**Modelo:** Sonnet 5.5 1M xHigh
**Herramienta:** Claude Code

```
Crea un subagente adversarial-reviewer: revisa un pull request intentando romperlo, no aprobarlo, y sin editar nada.
```

**Qué salió:** Funcionó a la primera, me indica que no tiene herramientas de edición, sólo lectura; pero, me indica que hay una limitación: Bash sigue pudiendo escribir, porque no se puede filtrar por comando desde el frontmatter. Que si queremos evitarlo de forma estricta, hay que ponerlo en permissions del settings.json. Sigue sin probarlo.

## Prompt 4

**Modelo:** Sonnet 5.5 1M xHigh
**Herramienta:** Claude Code

```
Bien, ahora necesito un hook que formatea el frontend cada vez que el agente edita un archivo. El frontend no trae formateador: instala Prettier en
  frontend/ y dispáralo sobre frontend/src/**.
```

**Qué salió:** Funcionó a la primera, hook montado y esta vez sí lo probó.

## Prompt 5

**Modelo:** Sonnet 5.5 1M xHigh
**Herramienta:** Claude Code

```
Ahora vamos con Las reglas de proceso, al final del CLAUDE.md: rama nueva antes de tocar código; al cerrar, /commit y el pull request con gh pr create; después, el subagente revisor sobre el pull request; y en el chat, solo la URL del pull request.
```

**Qué salió:** Funcionó a la primera, añadió las reglas del proceso al final de CLAUDE.md. También tomó un par de decisiones: agregó git push dentro del paso 2 porque gh pr create lo necesita, pero la skill commit prohibe el push, así que ese paso lo hace el agente poir fuera de la eskill. También prohibió commitear sobre main yu s1/start, dice que el README no lo pide, pero es lo que protege el flujo de fork y PR.

## Prompt 6

**Modelo:** Sonnet 5.5 1M xHigh
**Herramienta:** Claude Code

```
Ya llevé a cabo la última pieza, la de AGENTS.md como enlace a CLAUDE.md. Primero ayúdame con un commit para dejar todo el harness listo.
```

**Qué salió:** Me advierte que prompts.md es entregable aparte y lo estoy editando. También dice que aún falta la pieza 2, el MCP de Atlassian. Yo lo había hecho en Claude Code Desktop, pensé que lo heredaría de ahí la terminal, pero no.

## Prompt 7

**Modelo:** Sonnet 5.5 1M xHigh
**Herramienta:** Claude Code

```
Sí, configurá el MCP de Atlassian en el proyecto
```

**Qué salió:** Listo, el MCP de Atlassian quedó configurado a nivel de proyecto en .mcp.json, apuntando al servidor remoto oficial https://mcp.atlassian.com/v1/mcp. También actualicé /priority-ticket para que mencione mcp**atlassian**\*, que es el nombre que toman las herramientas con este servidor.
