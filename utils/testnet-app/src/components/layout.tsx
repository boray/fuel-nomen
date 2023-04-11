import styled from "styled-components";

export const Layout = styled.div`
  position: relative;
  min-height: 100%;
  padding: 0px 16px 50px 16px;
  margin-bottom: 50px;

  @media only screen and (max-height: 650px) {
    padding-bottom: 100px;
  }
`;
