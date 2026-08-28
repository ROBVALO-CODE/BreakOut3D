# BreakOut3D
Recreación del juego BreakOut en 3D como proyecto académico de la clase de Desarrollo de Videojuegos 2D y 3D

## ⚠️ SUPERMEGA IMPORTANTE
**Antes de empezar a trabajar en cualquier funcionalidad, cada integrante debe clonar el repositorio en su máquina local usando GitHub Desktop y la URL del proyecto.**  
De esta forma todos tendrán la misma base y podrán sincronizar sus cambios correctamente.

Pasos rápidos en GitHub Desktop:
1. Abrir **GitHub Desktop**
2. Ir a **File → Clone repository…**  
3. En la pestaña **URL**, pegar: https://github.com/ROBVALO-CODE/BreakOut3D
4. Elegir la carpeta local donde se guardará el proyecto
5. Hacer clic en **Clone**


## Cómo abrir el proyecto en Godot

Una vez que hayas clonado el repositorio en tu máquina local con GitHub Desktop:

1. Abre **Godot Engine** en tu PC
2. En la pantalla inicial, haz clic en **Importar proyecto**  
3. Navega hasta la carpeta donde clonaste el repositorio (ejemplo: `C:\GitHub\BreakOut3D`)
4. Selecciona el archivo `project.godot` dentro de esa carpeta
5. Haz clic en **Importar & Editar** para cargar el proyecto
6. Desde el editor de Godot, abre la **escena principal** y presiona **Play ▶ ** para ejecutar el juego

----> Con esto, cada integrante podrá abrir el proyecto en Godot sin problemas y empezar a trabajar en su parte


## Objetivo (según lo que debemos traer listo para la otra clase)
Implementar un juego estilo BreakOut en 3D con:
- Bloques en matriz 3x3 (9 bloques)
- Paddle que se mueve horizontalmente
- Bola disparada hacia adelante con la tecla ↑
- Assets y materiales personalizados


## Roles y Asignaciones del equipo
- **YUDY** → Paddle (barra, movimiento izquierda/derecha)
- **ISA** → Bola (lógica de disparo y rebote)
- **DANNA Y GABY** → Bloques (matriz 3x3 y destrucción)
- **DAVID** → Escenario (mapa, materiales, integración)
- **DANNA**→ HUD (mostrar vidas Y puntaje/score)
- **ISA** → Integración general y ajustes finales


## Nomenclatura de carpetas
- `/paddle` → scripts y escenas del paddle
- `/ball` → scripts y escenas de la bola
- `/blocks` → scripts y escenas de los bloques
- `/hud` → scripts y escenas del HUD (vidas, puntaje, tiempo)
- `/scenes` → escenas principales y de integración
- `/assets` y `/material` → materiales, texturas y modelos
- `/docs` → documentación del proyecto


## Flujo de trabajo
1. Cada integrante trabaja en SU **RAMA**:
   - `feature/paddle`
   - `feature/ball`
   - `feature/blocks`
   - `feature/hud`
   - `feature/scenes`
   - `feature/integration`
2. Al terminar una funcionalidad, hacen **commit y push**.
3. Crear un **Pull Request** hacia `main`.
4. ISA revisa y aprueba la integración

**SIEMPRE QUE AGREGUEN O VAYAN A CONSRUIR UNA NUEVA FUNCIONALIDAD, EJ: EMPEZAR A TRABAJAR EN EL ASSET DEL PADDLE Y EN SU SCRIPT. HACEN UNA NUEVA RAMA LLAMADA: `feature/paddle`**


## Convenciones de commits

Para mantener el historial del proyecto ordenado, cada integrante debe escribir mensajes de commit claros usando prefijos estándar:

- **feat:** cuando agregues una nueva funcionalidad
  Ejemplo:→ feat: implemente movimiento del paddle

- **fix:** cuando corrijas un error o bug
Ejemplo → fix: corregi rebote de la bola

- **docs:** cuando edites documentación (README, guías, etc...)
Ejemplo → docs: agrege instrucciones de flujo de trabajo al README

- **chore:** para cambios menores de mantenimiento (mover archivos etc..)
Ejemplo → chore: reorganize carpeta de assets

**REGLA GENERAL: el mensaje debe ser **breve pero específico**. No basta con poner “cambios” o “update”**


## Plantilla de Pull Request

Cuando termines tu funcionalidad y quieras integrarla al proyecto, crea un **Pull Request (PR)** siguiendo este formato:

### Título
Usa un prefijo claro según el tipo de cambio:
- `feat:` nueva funcionalidad
- `fix:` corrección de error
- `docs:` documentación
- `chore:` mantenimiento

Ejemplo: feat: se implemento el movimiento del paddle

### Descripción
Explica brevemente qué hiciste y por qué:
- ¿Qué funcionalidad agregaste o corregiste?
- ¿Qué archivos se modificaron?
- ¿Hay algo que el equipo deba revisar con atención?

Ejemplo: Se implementó el movimiento horizontal del paddle usando las teclas ← y →
Se creó el script en /paddle y se probó en la escena principal

### VERIFICACION FINAL
Antes de enviar el PR, verifica:
- [ ] El código compila y corre sin errores
- [ ] Probé mi funcionalidad en Godot
- [ ] Los archivos están en la carpeta correcta (`/paddle`, `/ball`, etc.)
- [ ] El commit tiene un mensaje claro con prefijo (`feat`, `fix`, `docs`, `chore`)
- [ ] No modifiqué archivos de otros integrantes sin permiso.  









