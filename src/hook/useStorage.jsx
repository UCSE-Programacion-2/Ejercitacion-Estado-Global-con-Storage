import { useState, useEffect } from 'react';

/**
 * Custom Hook: useStorage
 * TODO [Issue #2]:
 * 1. Leer el valor inicial desde localStorage.getItem(key) y deserializarlo con JSON.parse
 *    dentro de un bloque try/catch.
 * 2. Si no existe o se produce un error, utilizar initialValue.
 * 3. Inicializar el estado local con useState(storedItem || initialValue).
 * 4. Utilizar useEffect([key, state]) para serializar con JSON.stringify y almacenar
 *    mediante localStorage.setItem(key, JSON.stringify(state)).
 * 5. Retornar la tupla [state, setState].
 */
export default function useStorage(key, initialValue) {
  // TODO [Issue #2]: Leer y deserializar con try/catch desde localStorage.getItem(key)
  const [state, setState] = useState(initialValue);

  // TODO [Issue #2]: Sincronizar reactivamente con useEffect y localStorage.setItem(key, JSON.stringify(state))
  useEffect(() => {}, [key, state]);

  return [state, setState];
}
