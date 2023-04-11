import styled from "styled-components";

export const RegisterButtonStyled = styled.div`
  width: 511px;
  max-width: 100%;
  margin: 0 auto;
  margin-top: 40px;

  .button_wrapper {
    display: flex;
    align-items: center;
    font-weight: 500;
    font-size: 22px;
    padding-left: 16px;
    height: 30px;
  }

  .main-button-icon {
    flex-shrink: 0;
    position: relative;
    width: 24px;
    height: 24px;
    display: block;
  }

  .register_text {
    padding-right: 24px;
    padding-left: 20px;
    font-weight: 400;
    vertical-align: middle;
    height: 28px;
    transition: color 0.33s ease;
  }

  .domain_text {
    color: #90db5b;
    font-weight: 500;
    padding-right: 18px;
    transition: color 0.33s ease;

    &.shrink-1 {
      font-size: 18px;
    }

    &.shrink-2 {
      font-size: 14px;
    }

    .address {
      transition: color 0.33s ease;
      color: #fff;
      font-weight: 400;
    }
  }

  @media only screen and (max-width: 500px) {
    .domain_text {
      font-size: 14px;

      &.shrink-1 {
        font-size: 12px;
      }

      &.shrink-2 {
        font-size: 9px;
      }
    }

    .register_text {
      font-size: 16px;
      height: 20px;
      padding-right: 18px;
      padding-left: 12px;
    }
  }
`;
