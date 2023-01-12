import { createTheme } from '@mui/material/styles';

interface AriaThemeColors{
  [key: string]: string
}

const themeColors:AriaThemeColors = {
  purple: "#8B00F8",
  green: "#00A03C",
  orange: "#FF8200",
  red: "#F41010",
  navyBlue: "#100E6A",
  trueBlack: "#000000",
  darkGrey: "#49454F",
  stoneGrey: "#79747E",
  trueWhite: "#FFFFFF"
}

declare module '@mui/material/styles' {
  interface Theme {
    primary: {
      main: AriaThemeColors;
    };
  }
  interface ThemeOptions {
    primary?: {
      main?: AriaThemeColors;
    };
  }
}

const ariaLightTheme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: themeColors.purple
    },
    secondary: {
      main: themeColors.green
    }
  },
});

export default ariaLightTheme;