import styled, { css } from "styled-components";
import { blueButtonColors, connectButtonColors } from "../../styles/variables";
import { ConnectButtonType } from ".";

export const ConnectButtonStyled = styled.button<ConnectButtonType>`
  border-radius: 10px;
  border: none;
  display: flex;
  align-items: center;
  font-size: 16px;
  font-family: inherit;
  cursor: pointer;
  height: 48px;
  transition: background-color 0.4s ease, box-shadow 0.4s ease, color 0.6s ease,
    width 0.5s ease;
  outline: none;
  overflow: hidden;

  ${(props) =>
    props.buttonStatus === "connect" &&
    css`
      background-color: ${blueButtonColors.bgColor};
      color: #fff;
      box-shadow: 0px 1px 9px 3px ${blueButtonColors.innerShadowColor} inset;
      width: 126px;
      justify-content: center;

      &:hover {
        background-color: ${blueButtonColors.hoverBgColor};
        box-shadow: 0px 1px 9px ${blueButtonColors.hoverInnerShadowColor} inset;
      }

      &:active {
        background-color: ${blueButtonColors.activeBgColor};
        box-shadow: 0px 1px 9px 6px ${blueButtonColors.activeInnerShadowColor}
          inset;
      }
    `}

  ${(props) =>
    (props.buttonStatus === "connected" ||
      props.buttonStatus === "disconnect") &&
    css`
      width: 258px;
      text-align: left;
      padding-left: 19px;
      padding-right: 14px;
    `}

  ${(props) =>
    props.buttonStatus === "connected" &&
    css`
      background-color: ${connectButtonColors.connectedBgColor};
      box-shadow: 2px 3px 9px ${connectButtonColors.connectedInnerShadowColor}
        inset;
      color: ${connectButtonColors.connectedTextColor};
    `}
  
  ${(props) =>
    props.buttonStatus === "disconnect" &&
    css`
      background-color: ${connectButtonColors.disconnectBgColor};
      box-shadow: 2px 3px 9px ${connectButtonColors.disconnectInnerShadowColor}
        inset;
      color: ${connectButtonColors.disconnectTextColor};
    `}

  .connected-id {
    font-size: 12px;
    padding-left: 34px;
  }

  .disconnect-icon {
    width: 20px;
    height: 20px;
    margin-left: auto;
  }
`;
