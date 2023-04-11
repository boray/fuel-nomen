import styled from "styled-components";

export const MyDomainsListStyled = styled.div`
  margin-top: 200px;

  .title {
    font-size: 32px;
    text-align: center;
    font-weight: 700;
    margin-bottom: 60px;
  }

  .domains {
    display: flex;
    flex-direction: column;
    width: 511px;
    max-width: 100%;
    margin: 0 auto;
    gap: 16px 0;
  }

  .domain_item {
    max-width: 100%;
    width: 511px;
    height: 64px;
    border-radius: 10px;
    opacity: 1;
    background-color: #2c3142;
    font-size: 22px;
    display: flex;
    align-items: center;
    padding-left: 44px;
    transition: box-shadow 0.4s ease;
    cursor: pointer;

    &:hover {
      box-shadow: 0px 0px 10px 8px #5d6481 inset;
    }

    .gray {
      color: #8d98bf;
    }
  }

  .note {
    width: 500px;
    max-width: 100%;
    margin: auto;
    font-size: 16px;
    font-weight: 500;
    color: #7c86ab;
    text-align: center;
    margin-top: 20px;
  }

  @media only screen and (max-height: 1100px) {
    margin-top: 100px;
  }

  @media only screen and (max-height: 900px) {
    margin-top: 30px;
  }
`;
