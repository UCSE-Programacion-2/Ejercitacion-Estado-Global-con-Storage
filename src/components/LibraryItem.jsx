import { useGameContext } from '../context/GameContext';

/**
 * Componente: LibraryItem
 * TODO [Issue #7]:
 * 1. Consumir incrementHours, decrementHours, updateStatus y removeFromLibrary desde useGameContext().
 * 2. Conectar los botones '-' y '+' para despachar decrementHours e incrementHours.
 * 3. Conectar el <select> para despachar updateStatus(item.id, e.target.value).
 * 4. Conectar el botón 'Quitar' para despachar removeFromLibrary(item.id).
 */
export default function LibraryItem({ item }) {
  // TODO [Issue #7]: Consumir funciones de useGameContext
  const incrementHours = () => {};
  const decrementHours = () => {};
  const updateStatus = () => {};
  const removeFromLibrary = () => {};

  return (
    <li className='library-item'>
      <div className='library-item-left'>
        <img className='library-item-image' src={item.image} alt={item.title} />
        <div>
          <h4 className='library-item-name'>{item.title}</h4>
          <p className='library-item-genre'>{item.genre}</p>
        </div>
      </div>

      <div className='library-item-controls'>
        <div className='hours-control'>
          <button
            type='button'
            className='hours-btn'
            onClick={() => decrementHours(item.id)}
            aria-label={`Restar hora a ${item.title}`}
          >
            -
          </button>
          <span className='hours-display'>{item.horasJugadas}h</span>
          <button
            type='button'
            className='hours-btn'
            onClick={() => incrementHours(item.id)}
            aria-label={`Sumar hora a ${item.title}`}
          >
            +
          </button>
        </div>

        <select
          className='status-select'
          value={item.estado}
          onChange={e => updateStatus(item.id, e.target.value)}
          aria-label={`Estado de ${item.title}`}
        >
          <option value='Pendiente'>Pendiente</option>
          <option value='Jugando'>Jugando</option>
          <option value='Completado'>Completado</option>
        </select>

        <button
          type='button'
          className='remove-btn'
          onClick={() => removeFromLibrary(item.id)}
          aria-label={`Quitar ${item.title} de la biblioteca`}
        >
          Quitar
        </button>
      </div>
    </li>
  );
}
