import './App.css';
import { useTheme } from './context/ThemeContext';
import Header from './components/Header';
import GameCatalog from './components/GameCatalog';
import LibraryPanel from './components/LibraryPanel';

export default function App() {
  const { isDark } = useTheme();

  return (
    <div className={`app-container ${isDark ? 'dark-mode' : ''}`}>
      <Header />
      <main className='main-content'>
        <GameCatalog />
        <hr className='divider' />
        <LibraryPanel />
      </main>
    </div>
  );
}
