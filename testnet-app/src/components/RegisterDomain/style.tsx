import styled from "styled-components";
import { mainBgColor } from "../../styles/variables";

export const RegisterDomainStyled = styled.div`
  width: 600px;
  max-width: 100%;

  border-radius: 10px;
  box-shadow: 0px 0px 40px #61aeff50;
  margin: 100px auto 0 auto;
  padding: 8px 30px 50px 30px;
  background-color: ${mainBgColor};

  .title {
    padding: 15px 0;
    border-bottom: 1px solid #fff;
    margin-bottom: 30px;
    display: flex;
    justify-content: space-between;

    .text {
      font-weight: 600;
    }

    .cancel-button {
      display: flex;
      cursor: pointer;
      margin-left: 10px;

      &:hover {
        .cancel_text {
          color: #fff;
        }
      }
    }

    .cancel_text {
      color: #2c3142;
      margin-right: 8.5px;
      cursor: pointer;
      user-select: none;
      transition: color 0.4s ease;
    }

    .cancel_icon {
      width: 20px;
      height: 20px;
      position: relative;
    }
  }

  .steps {
    display: flex;
    flex-direction: column;
    margin-left: 6px;
  }

  .step_item {
    padding-bottom: 60px;
    display: flex;
    align-items: center;
    position: relative;

    &:last-child {
      padding-bottom: 0;

      .circle:after {
        display: none;
      }
    }

    & .step_content {
      opacity: 0.23;
    }

    &.active .step_content {
      opacity: 1;
    }

    &.active .circle_wrapper {
      box-shadow: 0px 1px 4px 5px rgba(43, 184, 255, 0.5) inset;
    }
  }

  .circle {
    width: 30px;
    height: 30px;
    border-radius: 50%;
    border: 2px solid #fff;
    margin-right: 40px;
    background-color: ${mainBgColor};
    display: flex;
    justify-content: center;
    align-items: center;
    flex-shrink: 0;

    &:after {
      content: "";
      width: 2px;
      height: calc(100% - 25px);
      background-color: #fff;
      position: absolute;
      top: 50%;
      left: 15px;
      transform: translate(-50%, -16px);
    }
  }

  .circle_wrapper {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    opacity: 1;

    &.green {
      background-color: #2dd95a;
    }

    &.blue {
      background-color: #2d56d9;
    }
  }

  .step_content {
    font-size: 16px;
  }

  .step_desc {
    margin-top: 6px;
    color: #8d92a2;
  }

  @media only screen and (max-width: 500px) {
    margin-top: 50px;
  }
`;
