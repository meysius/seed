import { createContext, useContext } from 'react';
import { createStore, useStore as useZustandStore } from 'zustand';
import { createSessionSlice } from './session';
import { StoreInterface } from './interface';

export type StoreType = ReturnType<typeof initializeStore>;
type StoreInteface = ReturnType<StoreType['getState']>;

const zustandContext = createContext<StoreType | null>(null);
export const { Provider } = zustandContext;

export const useStore = <T>(selector: (state: StoreInteface) => T) => {
  const store = useContext(zustandContext);
  if (!store) throw new Error('Store is missing the provider');
  return useZustandStore(store, selector);
};

export function initializeStore(preloadedState = {}) {
  return createStore<StoreInterface>((...a) => ({
    ...createSessionSlice(...a),
    // ...createXSlice(...a),
    ...preloadedState,
  }));
}
