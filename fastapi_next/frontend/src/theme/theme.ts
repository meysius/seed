import { createTheme, Input } from '@mantine/core';
import inputClasses from './Input.module.css';

export const theme = createTheme({
  colors: {
    customBlue: [
      '#EDF2FF',
      '#DBE4FF',
      '#BAC8FF',
      '#91A7FF',
      '#748FFC',
      '#5C7CFA',
      '#4C6EF5',
      '#4263EB',
      '#3B5BDB',
      '#364FC7',
    ],
  },

  primaryColor: 'customBlue',

  components: {
    Input: Input.extend({
      classNames: {
        input: inputClasses.input,
      },
    }),
  },
});
