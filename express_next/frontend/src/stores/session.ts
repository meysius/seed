import { StateCreator } from 'zustand';
import { StoreInterface, SessionSliceInterface } from './interface';
import { getSession } from '@/api/sessions';
import { updateUser } from '@/api/users';

export const createSessionSlice: StateCreator<StoreInterface, [], [], SessionSliceInterface> = (
  set, get
) => ({
  accessToken: '',
  timezone: '',
  user: null,
  getSession: async (accessToken?: string) => {
    if (!accessToken) return;
    const resp = await getSession(accessToken);
    set({
      accessToken,
      timezone: '',
      user: resp.user,
    });
  },
  onboardUser: async (params: {
    firstName: string;
    lastName: string;
  }) => {
    const { accessToken } = get();
    const resp = await updateUser(accessToken, params);
    return set({ user: resp.user });
  },
});
