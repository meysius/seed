export interface SessionSliceInterface {
  accessToken: string;
  timezone: string;
  user: any;
  getSession: (accessToken: string | undefined) => void;
  onboardUser: (params: {
    firstName: string;
    lastName: string;
  }) => Promise<void>;
}

// export interface XSliceInterface {
//   someNumber: number;
//   someFlag: boolean;
//   someString: string;
//   someAction: (lastUpdate: number, light: boolean) => void;
// }

export type StoreInterface = SessionSliceInterface; // & XSliceInterface;
