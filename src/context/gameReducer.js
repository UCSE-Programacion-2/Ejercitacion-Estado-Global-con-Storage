/**
 * Constantes de Acción: GAME_ACTIONS
 * TODO [Issue #4]:
 * Definir y exportar los 6 tipos de acción inmutables:
 * - ADD_GAME: 'ADD_GAME'
 * - REMOVE_GAME: 'REMOVE_GAME'
 * - INCREMENT_HOURS: 'INCREMENT_HOURS'
 * - DECREMENT_HOURS: 'DECREMENT_HOURS'
 * - UPDATE_STATUS: 'UPDATE_STATUS'
 * - CLEAR_LIBRARY: 'CLEAR_LIBRARY'
 */
export const GAME_ACTIONS = {
  // TODO [Issue #4]: Definir los tipos de acción
};

/**
 * Función Reductora Pura: gameReducer
 * TODO [Issue #4]:
 * Implementar el switch(action.type) con operaciones inmutables:
 * 1. ADD_GAME: verificar si existe con .some(); si no existe, agregar con horasJugadas: 0 y estado: 'Pendiente'.
 * 2. REMOVE_GAME: filtrar con .filter() excluyendo el juego con ID === action.payload.
 * 3. INCREMENT_HOURS: mapear con .map() sumando 1 a horasJugadas.
 * 4. DECREMENT_HOURS: mapear con .map() restando 1 a horasJugadas con cota inferior 0 (Math.max(0, ...)).
 * 5. UPDATE_STATUS: mapear con .map() actualizando estado con action.payload.newStatus.
 * 6. CLEAR_LIBRARY: retornar [].
 * 7. default: retornar state.
 */
export function gameReducer(state, action = {}) {
  // TODO [Issue #4]: Implementar switch(action.type) con operaciones inmutables
  switch (action.type) {
    default:
      return state;
  }
}
