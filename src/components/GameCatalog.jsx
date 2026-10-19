import games from '../data/games.json';
import GameCard from './GameCard';

export default function GameCatalog() {
  return (
    <section className='catalog-section'>
      <h2 className='section-title'>🎮 Catálogo Destacado</h2>
      <div className='games-grid'>
        {games.map(game => (
          <GameCard key={game.id} game={game} />
        ))}
      </div>
    </section>
  );
}
