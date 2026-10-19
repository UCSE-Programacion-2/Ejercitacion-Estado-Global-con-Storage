import { useGameContext } from '../context/GameContext';

/**
 * Componente: GameCard
 * TODO [Issue #6]:
 * 1. Consumir 'library' y 'addToLibrary' desde useGameContext().
 * 2. Determinar si el juego ya fue agregado a la biblioteca (isAdded).
 * 3. Si ya está agregado: botón con texto '✔️ En Biblioteca' y atributo disabled.
 * 4. Si no está agregado: botón con texto '+ Añadir a Backlog' que ejecute addToLibrary(game).
 */
export default function GameCard({ game }) {
  // TODO [Issue #6]: Consumir useGameContext y determinar isAdded
  const isAdded = false;

  return (
    <article className='game-card'>
      <img className='game-card-image' src={game.image} alt={game.title} />
      <div className='game-card-content'>
        <h3 className='game-card-title'>{game.title}</h3>
        <p className='game-card-meta'>
          {game.genre} • {game.developer}
        </p>
        <p className='game-card-desc'>{game.description}</p>
        <button type='button' className='add-to-backlog-btn' onClick={() => {}} disabled={isAdded}>
          {isAdded ? '✔️ En Biblioteca' : '+ Añadir a Backlog'}
        </button>
      </div>
    </article>
  );
}
