#!/usr/bin/env bash
# Verificaciones automáticas — Estado Global con Storage y useReducer (GameVault v2)
# Cada subcomando valida un criterio puntual sobre el código fuente y build.
set -u

SRC_DIR="src"
COMPONENTS_DIR="src/components"
CONTEXT_DIR="src/context"
HOOK_DIR="src/hook"
DATA_FILE="src/data/games.json"

USE_STORAGE_JSX="src/hook/useStorage.jsx"
THEME_CONTEXT_JSX="src/context/ThemeContext.jsx"
GAME_REDUCER_JS="src/context/gameReducer.js"
GAME_CONTEXT_JSX="src/context/GameContext.jsx"

HEADER_JSX="src/components/Header.jsx"
GAME_CATALOG_JSX="src/components/GameCatalog.jsx"
GAME_CARD_JSX="src/components/GameCard.jsx"
LIBRARY_PANEL_JSX="src/components/LibraryPanel.jsx"
LIBRARY_ITEM_JSX="src/components/LibraryItem.jsx"

APP_JSX="src/App.jsx"
APP_CSS="src/App.css"
INDEX_CSS="src/index.css"
MAIN_JSX="src/main.jsx"
INDEX_HTML="index.html"
VITE_CONFIG="vite.config.js"
PACKAGE_JSON="package.json"

fail() {
  echo "$1" >&2
  exit 1
}

ok() {
  echo CORRECTO
}

# Limpia comentarios multilínea JSX y comentarios JS de una sola línea
clean_file() {
  local target="$1"
  local NODE_BIN=""
  if command -v node >/dev/null 2>&1; then
    NODE_BIN="node"
  elif command -v node.exe >/dev/null 2>&1; then
    NODE_BIN="node.exe"
  fi

  if [[ -n "$NODE_BIN" ]]; then
    "$NODE_BIN" -e "
      const fs = require('fs');
      if (!fs.existsSync('$target')) process.exit(0);
      let code = fs.readFileSync('$target', 'utf8');
      code = code.replace(/\{\/\*[\s\S]*?\*\/\}/g, ' ');
      code = code.replace(/\/\*[\s\S]*?\*\//g, ' ');
      code = code.replace(/(^|[^:])\/\/.*$/gm, '\$1 ');
      code = code.replace(/\s+/g, ' ');
      process.stdout.write(code);
    "
  else
    tr '\n' ' ' < "$target" | sed -e 's|{/\*.*\*/}| |g' -e 's|\([^:]\)//.*$|\1 |g'
  fi
}

case "${1:-}" in
  structure-check)
    [[ -d "$CONTEXT_DIR" ]]        || fail "No se encontró la carpeta src/context/."
    [[ -d "$COMPONENTS_DIR" ]]     || fail "No se encontró la carpeta src/components/."
    [[ -d "$HOOK_DIR" ]]           || fail "No se encontró la carpeta src/hook/."
    [[ -f "$USE_STORAGE_JSX" ]]    || fail "No se encontró src/hook/useStorage.jsx."
    [[ -f "$THEME_CONTEXT_JSX" ]]  || fail "No se encontró src/context/ThemeContext.jsx."
    [[ -f "$GAME_REDUCER_JS" ]]    || fail "No se encontró src/context/gameReducer.js."
    [[ -f "$GAME_CONTEXT_JSX" ]]   || fail "No se encontró src/context/GameContext.jsx."
    [[ -f "$HEADER_JSX" ]]         || fail "No se encontró src/components/Header.jsx."
    [[ -f "$GAME_CATALOG_JSX" ]]   || fail "No se encontró src/components/GameCatalog.jsx."
    [[ -f "$GAME_CARD_JSX" ]]      || fail "No se encontró src/components/GameCard.jsx."
    [[ -f "$LIBRARY_PANEL_JSX" ]]  || fail "No se encontró src/components/LibraryPanel.jsx."
    [[ -f "$LIBRARY_ITEM_JSX" ]]   || fail "No se encontró src/components/LibraryItem.jsx."
    [[ -f "$DATA_FILE" ]]          || fail "No se encontró src/data/games.json."
    [[ -f "$APP_JSX" ]]            || fail "No se encontró src/App.jsx."
    [[ -f "$APP_CSS" ]]            || fail "No se encontró src/App.css."
    [[ -f "$INDEX_CSS" ]]          || fail "No se encontró src/index.css."
    [[ -f "$MAIN_JSX" ]]           || fail "No se encontró src/main.jsx."
    [[ -f "$INDEX_HTML" ]]         || fail "No se encontró index.html en la raíz del proyecto."
    [[ -f "$VITE_CONFIG" ]]        || fail "No se encontró vite.config.js."
    [[ -f "$PACKAGE_JSON" ]]       || fail "No se encontró package.json."
    ok
    ;;

  use-storage)
    [[ -f "$USE_STORAGE_JSX" ]] || fail "No se encontró src/hook/useStorage.jsx."

    clean_storage=$(clean_file "$USE_STORAGE_JSX")

    if ! echo "$clean_storage" | grep -qE 'localStorage\.getItem'; then
      fail "useStorage debe leer los datos iniciales mediante localStorage.getItem()."
    fi

    if ! echo "$clean_storage" | grep -qE 'JSON\.parse'; then
      fail "useStorage debe deserializar los datos recuperados utilizando JSON.parse()."
    fi

    if ! echo "$clean_storage" | grep -qE 'try\s*\{'; then
      fail "useStorage debe proteger la lectura y parseo con un bloque try/catch."
    fi

    if ! echo "$clean_storage" | grep -qE 'useState\s*\('; then
      fail "useStorage debe encapsular el valor reactivo con useState()."
    fi

    if ! echo "$clean_storage" | grep -qE 'useEffect\s*\('; then
      fail "useStorage debe sincronizar los cambios de estado en localStorage mediante useEffect()."
    fi

    if ! echo "$clean_storage" | grep -qE 'localStorage\.setItem'; then
      fail "useStorage debe almacenar los datos actualizados mediante localStorage.setItem()."
    fi

    if ! echo "$clean_storage" | grep -qE 'JSON\.stringify'; then
      fail "useStorage debe serializar los datos complejos con JSON.stringify()."
    fi

    ok
    ;;

  theme-context)
    [[ -f "$THEME_CONTEXT_JSX" ]] || fail "No se encontró src/context/ThemeContext.jsx."

    clean_theme=$(clean_file "$THEME_CONTEXT_JSX")

    if ! echo "$clean_theme" | grep -qE 'createContext\s*\('; then
      fail "ThemeContext.jsx debe inicializar el contexto mediante createContext()."
    fi

    if ! echo "$clean_theme" | grep -qE 'function\s+ThemeProvider|const\s+ThemeProvider'; then
      fail "ThemeContext.jsx debe declarar y exportar el componente ThemeProvider."
    fi

    if ! echo "$clean_theme" | grep -qE 'useStorage\s*\('; then
      fail "ThemeProvider debe utilizar el hook useStorage para persistir el tema en localStorage."
    fi

    if ! echo "$clean_theme" | grep -qE 'gamevault_theme'; then
      fail "ThemeProvider debe utilizar la clave 'gamevault_theme' en useStorage."
    fi

    if ! echo "$clean_theme" | grep -qE 'function\s+useTheme|const\s+useTheme'; then
      fail "ThemeContext.jsx debe declarar y exportar el custom hook useTheme()."
    fi

    if ! echo "$clean_theme" | grep -qE 'throw\s+new\s+Error'; then
      fail "useTheme debe implementar una salvaguarda arrojando un Error si se usa fuera de ThemeProvider."
    fi

    ok
    ;;

  game-reducer)
    [[ -f "$GAME_REDUCER_JS" ]] || fail "No se encontró src/context/gameReducer.js."

    clean_reducer=$(clean_file "$GAME_REDUCER_JS")

    if ! echo "$clean_reducer" | grep -qE 'GAME_ACTIONS'; then
      fail "gameReducer.js debe definir y exportar el objeto GAME_ACTIONS con los tipos de acción."
    fi

    for action in ADD_GAME REMOVE_GAME INCREMENT_HOURS DECREMENT_HOURS UPDATE_STATUS CLEAR_LIBRARY; do
      if ! echo "$clean_reducer" | grep -qE "$action"; then
        fail "GAME_ACTIONS debe incluir la acción $action."
      fi
    done

    if ! echo "$clean_reducer" | grep -qE 'function\s+gameReducer|const\s+gameReducer'; then
      fail "gameReducer.js debe declarar y exportar la función reductora gameReducer(state, action)."
    fi

    if ! echo "$clean_reducer" | grep -qE 'switch\s*\(\s*action\.type\s*\)'; then
      fail "gameReducer debe gestionar las transiciones de estado mediante switch(action.type)."
    fi

    ok
    ;;

  game-context)
    [[ -f "$GAME_CONTEXT_JSX" ]] || fail "No se encontró src/context/GameContext.jsx."

    clean_game=$(clean_file "$GAME_CONTEXT_JSX")

    if ! echo "$clean_game" | grep -qE 'createContext\s*\('; then
      fail "GameContext.jsx debe inicializar el contexto mediante createContext()."
    fi

    if ! echo "$clean_game" | grep -qE 'useReducer\s*\(\s*gameReducer'; then
      fail "GameProvider debe utilizar useReducer vinculado a gameReducer."
    fi

    if ! echo "$clean_game" | grep -qE 'localStorage\.(getItem|setItem)'; then
      fail "GameContext debe persistir la colección de la biblioteca en localStorage."
    fi

    if ! echo "$clean_game" | grep -qE 'gamevault_library'; then
      fail "GameContext debe utilizar la clave 'gamevault_library' para almacenar la biblioteca en localStorage."
    fi

    if ! echo "$clean_game" | grep -qE 'addToLibrary'; then
      fail "GameProvider debe exponer la función despachadora addToLibrary."
    fi

    if ! echo "$clean_game" | grep -qE 'removeFromLibrary'; then
      fail "GameProvider debe exponer la función despachadora removeFromLibrary."
    fi

    if ! echo "$clean_game" | grep -qE 'incrementHours'; then
      fail "GameProvider debe exponer la función despachadora incrementHours."
    fi

    if ! echo "$clean_game" | grep -qE 'decrementHours'; then
      fail "GameProvider debe exponer la función despachadora decrementHours."
    fi

    if ! echo "$clean_game" | grep -qE 'updateStatus'; then
      fail "GameProvider debe exponer la función despachadora updateStatus."
    fi

    if ! echo "$clean_game" | grep -qE 'clearLibrary'; then
      fail "GameProvider debe exponer la función despachadora clearLibrary."
    fi

    if ! echo "$clean_game" | grep -qE 'function\s+useGameContext|const\s+useGameContext'; then
      fail "GameContext.jsx debe declarar y exportar el custom hook useGameContext()."
    fi

    if ! echo "$clean_game" | grep -qE 'throw\s+new\s+Error'; then
      fail "useGameContext debe implementar una salvaguarda arrojando un Error si se usa fuera de GameProvider."
    fi

    ok
    ;;

  game-catalog)
    [[ -f "$GAME_CATALOG_JSX" ]] || fail "No se encontró src/components/GameCatalog.jsx."
    [[ -f "$GAME_CARD_JSX" ]]    || fail "No se encontró src/components/GameCard.jsx."

    clean_catalog=$(clean_file "$GAME_CATALOG_JSX")
    clean_card=$(clean_file "$GAME_CARD_JSX")

    if ! echo "$clean_catalog" | grep -qE 'games\.json'; then
      fail "GameCatalog.jsx debe importar la colección de juegos desde src/data/games.json."
    fi

    if ! echo "$clean_catalog" | grep -qE '<GameCard'; then
      fail "GameCatalog.jsx debe renderizar componentes GameCard para cada juego del catálogo."
    fi

    if ! echo "$clean_card" | grep -qE 'useGameContext\s*\('; then
      fail "GameCard.jsx debe consumir el estado global mediante useGameContext()."
    fi

    if ! echo "$clean_card" | grep -qE 'addToLibrary'; then
      fail "GameCard.jsx debe invocar addToLibrary al hacer clic en el botón de añadir."
    fi

    ok
    ;;

  library-panel)
    [[ -f "$LIBRARY_PANEL_JSX" ]] || fail "No se encontró src/components/LibraryPanel.jsx."
    [[ -f "$LIBRARY_ITEM_JSX" ]]  || fail "No se encontró src/components/LibraryItem.jsx."

    clean_panel=$(clean_file "$LIBRARY_PANEL_JSX")
    clean_item=$(clean_file "$LIBRARY_ITEM_JSX")

    if ! echo "$clean_panel" | grep -qE 'useGameContext\s*\('; then
      fail "LibraryPanel.jsx debe consumir useGameContext()."
    fi

    if ! echo "$clean_panel" | grep -qE 'clearLibrary'; then
      fail "LibraryPanel.jsx debe vincular la acción clearLibrary al botón de vaciado."
    fi

    if ! echo "$clean_panel" | grep -qE '<LibraryItem'; then
      fail "LibraryPanel.jsx debe renderizar componentes LibraryItem para cada juego guardado."
    fi

    if ! echo "$clean_item" | grep -qE 'incrementHours'; then
      fail "LibraryItem.jsx debe vincular incrementHours al botón '+' de horas."
    fi

    if ! echo "$clean_item" | grep -qE 'decrementHours'; then
      fail "LibraryItem.jsx debe vincular decrementHours al botón '-' de horas."
    fi

    if ! echo "$clean_item" | grep -qE 'updateStatus'; then
      fail "LibraryItem.jsx debe vincular updateStatus al cambio del selector de estado."
    fi

    if ! echo "$clean_item" | grep -qE 'removeFromLibrary'; then
      fail "LibraryItem.jsx debe vincular removeFromLibrary al botón de quitar."
    fi

    ok
    ;;

  app-composition)
    [[ -f "$MAIN_JSX" ]] || fail "No se encontró src/main.jsx."
    [[ -f "$APP_JSX" ]]  || fail "No se encontró src/App.jsx."

    clean_main=$(clean_file "$MAIN_JSX")
    clean_app=$(clean_file "$APP_JSX")

    if ! echo "$clean_main" | grep -qE '<ThemeProvider>'; then
      fail "main.jsx debe envolver la aplicación con <ThemeProvider>."
    fi

    if ! echo "$clean_main" | grep -qE '<GameProvider>'; then
      fail "main.jsx debe envolver la aplicación con <GameProvider>."
    fi

    if ! echo "$clean_app" | grep -qE 'useTheme\s*\('; then
      fail "App.jsx debe consumir useTheme() para obtener el modo visual."
    fi

    if ! echo "$clean_app" | grep -qE 'dark-mode'; then
      fail "App.jsx debe aplicar condicionalmente la clase 'dark-mode'."
    fi

    ok
    ;;

  build-check)
    if ! npm run build >/dev/null 2>&1; then
      if ! npm.cmd run build >/dev/null 2>&1; then
        fail "La compilación de producción con 'npm run build' falló. Revisa errores de sintaxis JSX o importaciones rotas."
      fi
    fi
    [[ -d "dist" ]] || fail "La compilación no generó el directorio de producción dist/."
    ok
    ;;

  all)
    bash "$0" structure-check || exit 1
    bash "$0" use-storage     || exit 1
    bash "$0" theme-context   || exit 1
    bash "$0" game-reducer    || exit 1
    bash "$0" game-context    || exit 1
    bash "$0" game-catalog    || exit 1
    bash "$0" library-panel   || exit 1
    bash "$0" app-composition || exit 1
    bash "$0" build-check     || exit 1
    echo CORRECTO
    ;;

  *)
    fail "Subcomando no reconocido: '${1:-}'. Subcomandos válidos: structure-check, use-storage, theme-context, game-reducer, game-context, game-catalog, library-panel, app-composition, build-check, all."
    ;;
esac
