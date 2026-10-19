# 🎮 Ejercitación: Estado Global con Storage y useReducer en React (GameVault v2)

Bienvenidos a la ejercitación práctica sobre **Manejo de Estado Global Avanzado con Web Storage y useReducer en React** de la cátedra de **Programación II** (Ingeniería en Informática / Licenciatura en Sistemas).

En esta actividad continuaremos la evolución de **GameVault**, nuestra plataforma interactiva para amantes de los videojuegos. En la etapa anterior implementamos la Context API para compartir datos sin _prop drilling_, pero todo el estado residía en memoria volátil (se perdía al recargar con `F5`) y la lógica mutacional de la biblioteca estaba dispersa en múltiples handlers.

En esta versión v2, daremos un salto hacia una **arquitectura profesional y resiliente**:

1. Implementaremos el Custom Hook modular **`useStorage`** para sincronizar reactivamente el estado con **`localStorage`**.
2. Centralizaremos las transiciones de la biblioteca personal mediante una **función reductora pura (`gameReducer.js`)** gobernada por el hook **`useReducer`**.
3. Demostraremos que los componentes consumidores (`GameCard`, `LibraryItem`, `Header`) no necesitan alterar su comportamiento, evidenciando el verdadero poder del desacoplamiento arquitectónico en React.

---

## 🎯 Objetivos de Aprendizaje

1. **Dominar el hook `useReducer`:** Modelar las transiciones de estado de una colección mediante una función pura `(state, action) => newState`, despachando objetos `{ type, payload }` inmutables.
2. **Garantizar inmutabilidad y atomicidad:** Aplicar métodos no destructivos (`.map()`, `.filter()`, operador spread `{ ...item, ... }`) para altas, bajas, modificaciones de horas y estados.
3. **Persistir el estado en el navegador (`localStorage`):** Integrar la Web Storage API dentro del ciclo de vida de React, garantizando que el catálogo guardado y las preferencias de tema sobrevivan a recargas completas (`F5`) y reinicios del navegador.
4. **Construir el Custom Hook `useStorage`:** Diseñar una abstracción que encapsule la lectura segura (`try/catch` con `JSON.parse`) y la escritura reactiva en un `useEffect` con `JSON.stringify`.
5. **Componer `useReducer` con `useContext`:** Proporcionar en el Provider tanto el estado derivado del reducer como funciones despachadoras semánticas (`addToLibrary`, `removeFromLibrary`, etc.), manteniendo limpios los contratos de props de los consumidores.
6. **Preservar salvaguardas de jerarquía:** Mantener cláusulas de guarda en `useTheme` y `useGameContext` (`if (context === undefined) throw new Error(...)`).
7. **Calcular valores derivados del estado en vivo:** Derivar en renderizado métricas globales (títulos guardados, horas acumuladas, porcentaje completado).
8. **Asegurar la calidad del código y build de producción:** Cumplir las reglas canónicas de linters (**ESLint Airbnb**, **Stylelint 16**, **Prettier**) y asegurar empaquetado sin advertencias en **Vite** (`npm run build`).

---

## 🧠 Fundamentos Teóricos de la Clase

### 1. El Salto a `useReducer`: ¿Por qué una Función Reductora Pura?

Cuando un estado global maneja colecciones complejas con múltiples operaciones posibles (agregar, quitar, incrementar horas, decrementar con límite, cambiar estado de juego, vaciar), el uso de múltiples setters de `useState` genera código disperso y propenso a inconsistencias.

Con **`useReducer`**, desacoplamos el **"qué ocurrió"** (la acción) del **"cómo se transforma el estado"** (la lógica reductora):

```jsx
// 1. Objeto de Acción estandarizado
dispatch({ type: GAME_ACTIONS.INCREMENT_HOURS, payload: gameId });

// 2. Función Reductora Pura: idéntica entrada siempre produce idéntica salida
export function gameReducer(state, action) {
  switch (action.type) {
    case GAME_ACTIONS.INCREMENT_HOURS:
      return state.map(game =>
        game.id === action.payload ? { ...game, horasJugadas: game.horasJugadas + 1 } : game,
      );
    // ...
  }
}
```

---

### 2. Sincronización Reactiva con `localStorage` y `useStorage`

La **Web Storage API** almacena cadenas de texto en el cliente. Para sincronizarla de forma transparente con React, encapsulamos su lógica en el hook `useStorage`:

```jsx
// src/hook/useStorage.jsx
export default function useStorage(key, initialValue) {
  // 1. Lectura inicial segura
  let storedItem = null;
  try {
    const raw = localStorage.getItem(key);
    if (raw !== null) storedItem = JSON.parse(raw);
  } catch (error) {
    console.error(error);
  }

  // 2. Estado local
  const [state, setState] = useState(storedItem !== null ? storedItem : initialValue);

  // 3. Persistencia en cada cambio
  useEffect(() => {
    try {
      localStorage.setItem(key, JSON.stringify(state));
    } catch (error) {
      console.error(error);
    }
  }, [key, state]);

  return [state, setState];
}
```

---

### 3. Inicialización Diferida (`init`) en `useReducer`

Para evitar lecturas redundantes del disco en cada renderizado, `useReducer` permite pasar una función inicializadora como tercer argumento (`init`), que se ejecuta **únicamente en el montaje inicial**:

```jsx
// src/context/GameContext.jsx
function initLibrary() {
  try {
    const raw = localStorage.getItem('gamevault_library');
    return raw ? JSON.parse(raw) : [];
  } catch {
    return [];
  }
}

export function GameProvider({ children }) {
  const [library, dispatch] = useReducer(gameReducer, [], initLibrary);

  useEffect(() => {
    localStorage.setItem('gamevault_library', JSON.stringify(library));
  }, [library]);
  // ...
}
```

---

## 🏗️ Arquitectura de GameVault v2

```text
src/
├── components/
│   ├── GameCard.jsx         # Tarjeta individual con botón condicional (+ Añadir / ✔️ En Biblioteca)
│   ├── GameCatalog.jsx      # Catálogo en grid desde games.json
│   ├── Header.jsx           # Encabezado con branding, métricas en vivo y botón de tema
│   ├── LibraryItem.jsx      # Fila interactiva (horas con +/-, selector de estado, botón quitar)
│   └── LibraryPanel.jsx     # Panel de biblioteca con estado vacío (🎮) y resumen métrico
├── context/
│   ├── GameContext.jsx      # Proveedor de biblioteca con useReducer y sincronización en localStorage
│   ├── gameReducer.js       # Función reductora pura y constantes GAME_ACTIONS
│   └── ThemeContext.jsx     # Proveedor de tema visual persistido con useStorage('gamevault_theme')
├── data/
│   └── games.json           # Catálogo local de 8 videojuegos destacados
├── hook/
│   └── useStorage.jsx       # Custom Hook modular de sincronización reactiva con localStorage
├── App.css                  # Estilos visuales de GameVault y modo oscuro Arcade
├── App.jsx                  # Contenedor raíz con consumo de tema
├── index.css                # Estilos globales y reset
└── main.jsx                 # Composición anidada de Providers y render raíz
```

---

## 🚀 Puesta en Marcha

### 1. Clonar el repositorio e instalar dependencias

```bash
npm install
```

### 2. Iniciar el servidor de desarrollo con Vite

```bash
npm run dev
```

Abre [http://localhost:5173](http://localhost:5173) en tu navegador.

### 3. Validar calidad de código y compilación

```bash
# Validar linters (ESLint + Stylelint)
npm run lint

# Validar formateo con Prettier
npm run format:check

# Validar compilación de producción con Vite
npm run build
```

---

## 📋 Matriz de Entregas e Issues de GitHub Classroom

| Issue  | Título de la Tarea                                              | Criterios Técnicos de Aceptación                                                                                                                                                     | Subcomando de Verificación                        | Commit Sugerido                                                                   |
| :----: | :-------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------ | :-------------------------------------------------------------------------------- |
| **#1** | **Estructura base y configuración del entorno**                 | Verificar existencia de carpetas en `src/`, configs canónicas, dataset `games.json` y dependencias.                                                                                  | `bash scripts/classroom-check.sh structure-check` | `chore: configurar estructura inicial y herramientas (Closes #1)`                 |
| **#2** | **Custom Hook `useStorage`**                                    | Implementar `src/hook/useStorage.jsx` con lectura inicial segura (`try/catch`), `useState`, `useEffect` con `localStorage.setItem` y retorno `[state, setState]`.                    | `bash scripts/classroom-check.sh use-storage`     | `feat: implementar custom hook useStorage (Closes #2)`                            |
| **#3** | **`ThemeContext` persistido y Hook `useTheme`**                 | En `ThemeContext.jsx`, usar `createContext`, `useStorage('gamevault_theme', false)`, proveer `isDark` y `toggleTheme`, e implementar `useTheme` con salvaguarda `throw new Error`.   | `bash scripts/classroom-check.sh theme-context`   | `feat: implementar ThemeContext con persistencia y useTheme (Closes #3)`          |
| **#4** | **Función Reductora `gameReducer` y Constantes `GAME_ACTIONS`** | En `gameReducer.js`, exportar `GAME_ACTIONS` (6 acciones) y `gameReducer(state, action)` implementado con `switch` e inmutabilidad estricta.                                         | `bash scripts/classroom-check.sh game-reducer`    | `feat: definir gameReducer y tipos de accion GAME_ACTIONS (Closes #4)`            |
| **#5** | **`GameContext` con `useReducer` y Storage**                    | En `GameContext.jsx`, inicializar `useReducer(gameReducer, [], init)`, persistir en `'gamevault_library'`, exponer funciones despachadoras helper y el hook seguro `useGameContext`. | `bash scripts/classroom-check.sh game-context`    | `feat: implementar GameContext con useReducer y almacenamiento local (Closes #5)` |
| **#6** | **Catálogo de Juegos y Botón Dinámico en `GameCard`**           | `GameCatalog.jsx` mapea `games.json`. `GameCard.jsx` consume `useGameContext` y alterna botón entre `✔️ En Biblioteca` (deshabilitado) y `+ Añadir a Backlog`.                       | `bash scripts/classroom-check.sh game-catalog`    | `feat: integrar GameCatalog y GameCard con estado global (Closes #6)`             |
| **#7** | **Panel de Biblioteca, Controles y Métricas Derivadas**         | `LibraryPanel.jsx` y `LibraryItem.jsx` implementan estado vacío con `🎮`, controles `+`/`-`, selector de estado, botón `Quitar`, botón `Vaciar Biblioteca 🗑️` y métricas en vivo.    | `bash scripts/classroom-check.sh library-panel`   | `feat: implementar LibraryPanel con controles y metricas derivadas (Closes #7)`   |
| **#8** | **Composición en `main.jsx`, Integración en `App.jsx` y Build** | Anidar `<ThemeProvider>` y `<GameProvider>` en `main.jsx`. En `App.jsx` aplicar condicionalmente `.dark-mode`. Verificar build sin errores con `npm run build`.                      | `bash scripts/classroom-check.sh build-check`     | `feat: componer providers, integrar vistas y validar build (Closes #8)`           |

---

## 🧪 Estrategia de Autoevaluación

Puedes verificar tu progreso en cualquier momento ejecutando los subcomandos de prueba:

```bash
# Probar una tarea individual:
bash scripts/classroom-check.sh use-storage
bash scripts/classroom-check.sh theme-context
bash scripts/classroom-check.sh game-reducer
bash scripts/classroom-check.sh game-context

# Probar la suite completa de autograding:
bash scripts/classroom-check.sh all
```

Cada subcomando imprimirá **`CORRECTO`** y finalizará con código `0` si todos los requisitos se cumplen.

---

## 🔍 Guía de Pruebas de Persistencia en el Navegador

Una vez que tengas la aplicación en marcha con `npm run dev`:

1. **Abre las DevTools** (`F12` o `Ctrl+Shift+I`) y dirígete a la pestaña **Application** (Chrome/Edge) o **Almacenamiento** (Firefox).
2. En el panel izquierdo, despliega **Local Storage** y haz clic en `http://localhost:5173`.
3. Haz clic en **"+ Añadir a Backlog"** en varios juegos: verás aparecer la clave `'gamevault_library'` con el JSON actualizado.
4. Ajusta las horas y el estado de juego de tus títulos guardados.
5. Cambia el tema visual con el botón superior: la clave `'gamevault_theme'` alternará entre `true` y `false`.
6. **Presiona `F5` o cierra y vuelve a abrir la pestaña:** ¡comprobarás que todos tus juegos, horas acumuladas, estados y el tema visual se mantienen exactamente como los dejaste!

---

> 🎓 **Cátedra de Programación II**  
> _Universidad Católica de Santiago del Estero (UCSE)_  
> "Compartir estado con elegancia, persistir con resiliencia y programar con arquitectura limpia."
