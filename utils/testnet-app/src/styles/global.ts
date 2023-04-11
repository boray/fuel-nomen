import { createGlobalStyle } from "styled-components";
import { mainBgColor } from "./variables";

const GlobalStyles = createGlobalStyle`
  html,
  body {
    padding: 0;
    margin: 0;
    font-family: 'Public Sans', sans-serif;
  }

  #__next,
  html,
  body {
    position: relative;
    height: 100%;
  }

  body {
    background: ${mainBgColor};
    color:#fff;
  }

  a {
    color: inherit;
    text-decoration: none;
  }

  * {
    box-sizing: border-box;
  }

  .hidden{
    display:none;
  }
`;

export default GlobalStyles;
