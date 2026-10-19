import { createContext, useContext } from 'react';
import useStorage from '../hook/useStorage';

/**
 * Contexto: ThemeContext
 * TODO [Issue #3]:
 * 1. Inicializar ThemeContext mediante createContext().
 */
export const ThemeContext = createContext();

/**
 * Proveedor: ThemeProvider
 * TODO [Issue #3]:
 * 2. Gestionar el estado 'isDark' con useStorage('gamevault_theme', false).
 * 3. Implementar la función 'toggleTheme' para alternar entre modo claro y oscuro.
 * 4. Proveer { isDark, toggleTheme } en la prop 'value' de ThemeContext.Provider.
 */
export function ThemeProvider({ children }) {
  // TODO [Issue #3]: Usar useStorage('gamevault_theme', false) e implementar toggleTheme
  const isDark = false;
  const toggleTheme = () => {};

  return <ThemeContext.Provider value={{ isDark, toggleTheme }}>{children}</ThemeContext.Provider>;
}

/**
 * Custom Hook: useTheme
 * TODO [Issue #3]:
 * 5. Consumir ThemeContext mediante useContext(ThemeContext).
 * 6. Validar que context !== undefined; de lo contrario arrojar:
 *    throw new Error('useTheme must be used within a ThemeProvider');
 */
export function useTheme() {
  const context = useContext(ThemeContext);
  // TODO [Issue #3]: Implementar salvaguarda de jerarquía con throw new Error
  return context || { isDark: false, toggleTheme: () => {} };
}
