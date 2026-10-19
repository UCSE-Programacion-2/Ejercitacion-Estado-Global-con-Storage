import { createContext, useContext, useReducer, useEffect } from 'react';
import { gameReducer, GAME_ACTIONS } from './gameReducer';

/**
 * Contexto: GameContext
 * TODO [Issue #5]:
 * 1. Inicializar GameContext mediante createContext().
 */
export const GameContext = createContext();

const STORAGE_KEY = 'gamevault_library';

/**
 * Proveedor: GameProvider
 * TODO [Issue #5]:
 * 2. Inicializar useReducer(gameReducer, [], initLibrary) donde initLibrary recupera los
 *    datos de localStorage.getItem('gamevault_library') deserializados con JSON.parse.
 * 3. Persistir en localStorage.setItem('gamevault_library', JSON.stringify(library)) mediante useEffect.
 * 4. Implementar las funciones despachadoras semánticas que ejecutan dispatch({ type, payload }):
 *    - addToLibrary(game)
 *    - removeFromLibrary(gameId)
 *    - incrementHours(gameId)
 *    - decrementHours(gameId)
 *    - updateStatus(gameId, newStatus)
 *    - clearLibrary()
 */
export function GameProvider({ children }) {
  // TODO [Issue #5]: Vincular useReducer con gameReducer y sincronizar con localStorage
  const library = [];

  const addToLibrary = () => {};
  const removeFromLibrary = () => {};
  const incrementHours = () => {};
  const decrementHours = () => {};
  const updateStatus = () => {};
  const clearLibrary = () => {};

  return (
    <GameContext.Provider
      value={{
        library,
        addToLibrary,
        removeFromLibrary,
        incrementHours,
        decrementHours,
        updateStatus,
        clearLibrary,
      }}
    >
      {children}
    </GameContext.Provider>
  );
}

/**
 * Custom Hook: useGameContext
 * TODO [Issue #5]:
 * 5. Consumir GameContext mediante useContext(GameContext).
 * 6. Validar salvaguarda de jerarquía: si context === undefined, arrojar:
 *    throw new Error('useGameContext must be used within a GameProvider');
 */
export function useGameContext() {
  const context = useContext(GameContext);
  // TODO [Issue #5]: Implementar salvaguarda de jerarquía con throw new Error
  return (
    context || {
      library: [],
      addToLibrary: () => {},
      removeFromLibrary: () => {},
      incrementHours: () => {},
      decrementHours: () => {},
      updateStatus: () => {},
      clearLibrary: () => {},
    }
  );
}
