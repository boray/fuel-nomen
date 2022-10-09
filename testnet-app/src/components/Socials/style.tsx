import styled from "styled-components";

export const SocialsStyled = styled.div`
  display: flex;
  gap: 0 14px;
  position: absolute;
  bottom: 60px;
  left: 50%;
  transform: translateX(-50%);

  .social-link {
    position: relative;
    width: 54px;
    height: 54px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 50%;
    transition: background-color 0.4s ease, box-shadow 0.3s ease;

    &:hover {
      background-color: #242732;
      box-shadow: 0px 1px 7px 2px #7871a250 inset;
    }
  }

  .social-icon {
    position: relative;
    width: 24px;
    height: 24px;
  }

  @media only screen and (max-width: 500px) {
    bottom: 30px;
  }
`;
