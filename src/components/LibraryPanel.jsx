import { useGameContext } from '../context/GameContext';
import LibraryItem from './LibraryItem';

export default function LibraryPanel() {
  const { library, clearLibrary } = useGameContext();

  const totalJuegos = library.length;
  const totalHoras = library.reduce((acc, game) => acc + game.horasJugadas, 0);
  const completados = library.filter(game => game.estado === 'Completado').length;
  const porcentaje = totalJuegos > 0 ? Math.round((completados / totalJuegos) * 100) : 0;

  return (
    <section className='library-section'>
      <div className='library-header'>
        <h2 className='library-title'>Mi Biblioteca Personal (Backlog)</h2>
        {totalJuegos > 0 && (
          <button
            type='button'
            className='clear-library-btn'
            onClick={clearLibrary}
            aria-label='Vaciar biblioteca completa'
          >
            Vaciar Biblioteca 🗑️
          </button>
        )}
      </div>

      {totalJuegos === 0 ? (
        <div className='empty-library'>
          <div className='empty-library-icon'>🎮</div>
          <p>Tu biblioteca está vacía. ¡Explora el catálogo y añade tus próximos desafíos!</p>
        </div>
      ) : (
        <>
          <ul className='library-list'>
            {library.map(item => (
              <LibraryItem key={item.id} item={item} />
            ))}
          </ul>

          <div className='library-summary'>
            <div>
              <span>Resumen: </span>
              <span className='summary-pill'>
                {totalJuegos} {totalJuegos === 1 ? 'título guardado' : 'títulos guardados'}
              </span>
              <span> • </span>
              <span className='summary-pill'>{totalHoras} horas acumuladas</span>
              <span> • </span>
              <span className='summary-pill'>
                {completados} completados ({porcentaje}%)
              </span>
            </div>
            <div className='storage-badge'>
              <span>💾</span>
              <span>Guardado en localStorage</span>
            </div>
          </div>
        </>
      )}
    </section>
  );
}
