import styled from "styled-components";
import { greenButtonColors, connectButtonColors } from "../styles/variables";

const MainButton = styled.button`
  background-color: ${greenButtonColors.bgColor};
  border-radius: 10px;
  border: none;
  font-size: 22px;
  font-family: inherit;
  color: #fff;
  text-align: center;
  color: #fff;
  box-shadow: 2px 3px 10px 8px ${greenButtonColors.innerShadowColor} inset,
    0px 2px 4px rgba(0, 0, 0, 0.5);
  max-width: 100%;
  width: 511px;
  height: 64px;
  cursor: pointer;
  transition: background-color 0.4s ease, box-shadow 0.4s ease;

  &:hover {
    background-color: ${greenButtonColors.hoverBgColor};
    box-shadow: 0px 3px 10px 8px ${greenButtonColors.hoverInnerShadowColor}
        inset,
      0px 2px 4px rgba(0, 0, 0, 0.5);

    .address,
    .register_text {
      color: #92ffb1;
    }

    .domain_text {
      color: #c5ff9d;
    }
  }

  &:active {
    background-color: ${greenButtonColors.activeBgColor};
    box-shadow: 0px 3px 10px 8px ${greenButtonColors.activeInnerShadowColor}
        inset,
      0px 2px 4px rgba(0, 0, 0, 0.5);

    .address,
    .register_text {
      color: #fff;
    }

    .domain_text {
      color: #90db5b;
    }
  }
`;

export default MainButton;
