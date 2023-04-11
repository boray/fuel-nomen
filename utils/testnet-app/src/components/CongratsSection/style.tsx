import styled from "styled-components";

export const CongratsSectionStyled = styled.div`
  margin-top: 200px;

  @media only screen and (max-height: 1000px) {
    margin-top: 100px;
  }

  @media only screen and (max-height: 672px) {
    margin-top: 32px;
  }

  .wrapper {
    text-align: center;
    margin-bottom: 50px;
  }

  .input_title {
    color: #535871;
    font-size: 16px;
    text-align: center;
    font-weight: 500;
    margin-bottom: 16px;
  }

  .title {
    font-size: 32px;
    font-weight: 600;
  }

  .check_circle {
    width: 76px;
    height: 76px;
    pointer-events: none;
    position: relative;
    margin: 17px auto 34px auto;
  }

  .success_text {
    font-size: 24px;
    color: #fff;

    .green {
      color: #11d147;
    }
  }
`;
