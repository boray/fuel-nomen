import styled from "styled-components";
import css from "styled-jsx/css";
import {
  inputColors,
  mainGreenColor,
  mainRedColor,
} from "../../styles/variables";

export const SearchSectionStyled = styled.div`
  margin-top: 200px;
  width: 100%;
  max-width: 100%;
  padding: 0 16px;

  .title {
    font-size: 72px;
    color: #fff;
    text-align: center;
    font-weight: 600;
    margin-bottom: 80px;

    &.title_available {
    }

    &.title_unavailable {
      font-size: 32px;
      margin-bottom: 60px;
    }
  }

  .availability {
    text-align: center;
    font-size: 24px;
    margin-top: 30px;

    .text_unavailable {
      color: ${mainRedColor};
    }

    .text_available {
      color: ${mainGreenColor};
    }
  }

  @media only screen and (max-height: 900px) {
    margin-top: 130px;
  }

  @media only screen and (max-height: 850px) {
    margin-top: 80px;
  }

  @media only screen and (max-height: 700px) {
    margin-top: 32px;
  }

  @media only screen and (max-width: 700px) {
    .title {
      margin-top: 50px;
      font-size: 52px;
    }
  }

  @media only screen and (max-width: 500px) {
    .title {
      margin-top: 20px;
      margin-bottom: 45px;
      font-size: 42px;
    }

    .availability {
      margin-bottom: 50px;
    }

    .title,
    .title.title_available,
    .title.title_unavailable {
      margin-bottom: 40px;
    }
  }
`;

export const SearchInputStyled = styled.div`
  position: relative;
  display: flex;
  align-items: center;
  margin: 0 auto;
  border-radius: 10px;
  max-width: calc(100%);
  width: 511px;
  height: 64px;
  background-color: ${inputColors.bgColor};

  transition: box-shadow 0.5s ease;

  animation-name: pulseAnimColorful;
  animation-duration: 3s;
  animation-timing-function: ease;
  animation-direction: alternate;
  animation-iteration-count: infinite;
  animation-play-state: running;

  &:focus-within {
    animation-name: pulseAnimColorfulSmall;
  }

  &.writing {
    animation-name: pulseAnimColorfulSmall;
  }

  .search-input {
    overflow: hidden;
    width: calc(100% - 55px);
    padding: 17px 30px 17px 20px;
    font-size: 22px;
    border-radius: 10px;
    border: none;
    font-family: inherit;
    background: transparent;
    outline: none;
    white-space: nowrap;
    color: transparent;
    border: 1px solid transparent;

    &:focus + .input-placeholder {
      display: none;
    }

    &:after {
      content: attr(data-suffix);
      color: #fff;
    }

    &:focus:after {
      content: ".fuel";
    }
  }

  .search-input-text {
    width: calc(100% - 55px);
    position: absolute;
    background: transparent;
    border: 1px solid transparent;
    font-size: 22px;
    font-weight: 400;
    padding: 17px 30px 17px 20px;
    outline: none;
    color: #9c9ea6;
    font-family: inherit;
  }

  .search-icon {
    position: absolute;
    right: 0;
    width: 24px;
    height: 24px;
    margin-right: 22px;
    cursor: pointer;
    font-size: 22px;

    &:hover svg {
      color: red;
    }
  }

  .input-placeholder {
    font-size: 22px;
    pointer-events: none;
    position: absolute;
    left: 20px;
    top: 50%;
    transform: translateY(-50%);
    color: #9c9ea6;
  }

  .input-suffix {
    color: #fff;
  }

  @keyframes pulseAnimColorful {
    0% {
      box-shadow: 20px 5px 40px #a23b58, 0px 5px 40px #009bff,
        -20px 5px 40px #0945ff;
    }
    100% {
      box-shadow: 8px 0px 20px #a23b58, 0px 0px 20px #009bff,
        -8px 0px 20px #0945ff;
    }
  }

  @keyframes pulseAnimColorfulSmall {
    0% {     
      box-shadow: 8px 0px 20px #a23b58, 0px 0px 20px #009bff,
      -8px 0px 20px #0945ff;
    }
    100% {
      box-shadow: 8px 0px 20px #a23b58, 0px 0px 20px #009bff,
        -8px 0px 20px #0945ff;
    }
  }
  
  @keyframes pulseAnimBlue {
    0% {
      box-shadow: 0px 0px 40px #61aeff90;
    }
    100% {
      box-shadow: 0px 0px 20px #61aeff90;
    }
  }
`;
