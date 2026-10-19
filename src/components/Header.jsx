import { useTheme } from '../context/ThemeContext';
import { useGameContext } from '../context/GameContext';

export default function Header() {
  const { isDark, toggleTheme } = useTheme();
  const { library } = useGameContext();

  const totalJuegos = library.length;
  const totalHoras = library.reduce((acc, game) => acc + game.horasJugadas, 0);

  return (
    <header className='app-header'>
      <div className='header-content'>
        <h1 className='header-title'>🎮 GameVault</h1>

        <div className='header-actions'>
          <div className='header-badge'>
            <span>
              📚 {totalJuegos} {totalJuegos === 1 ? 'juego' : 'juegos'}
            </span>
            <span>•</span>
            <span>⏱️ {totalHoras}h</span>
          </div>

          <button
            type='button'
            className='theme-toggle'
            onClick={toggleTheme}
            aria-label='Alternar tema'
          >
            {isDark ? '☀️ Modo Claro' : '🌙 Modo Oscuro'}
          </button>
        </div>
      </div>
    </header>
  );
}
