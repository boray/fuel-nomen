import { lighten } from "polished";
import styled from "styled-components";

export const HeaderStyled = styled.div`
  position: relative;
  width: 1524px;
  max-width: 100%;
  padding: 30px 16px;
  margin: 0 auto;

  .wrapper {
    display: flex;
    flex-wrap: wrap;
    gap: 20px 0;
    justify-content: space-between;
    align-items: center;
  }

  .nav {
    display: flex;
    flex-wrap: wrap;
    align-items: center;

    gap: 20px 14px;
  }

  .nav-item {
    font-size: 16px;
    color: #7a829d;
    padding: 4px 6px;
    transition: color 0.3s ease;
    outline: none;

    &:last-of-type {
      margin-right: 36px;
    }

    &:hover {
      color: ${lighten(0.3, "#7a829d")};
    }

    &.active {
      color: #fff;
    }
  }

  .logo_container {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
  }

  .logo {
    position: relative;
    width: 270px;
    height: 80px;
    cursor: pointer;
  }

  .side-text {
    width: 106px;
    height: 30px;
    background: #11d147;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    font-weight: 700;
    color: #000000;
    letter-spacing: 3.5px;
    margin-left: 14px;
    margin-bottom: 5px;
    user-select: none;
  }

  @media only screen and (max-width: 500px) {
    .logo {
      width: 170px;
      height: 50px;
    }

    .side-text {
      font-size: 10px;
      width: 84px;
      letter-spacing: 2.5px;
      height: 25px;
      border-radius: 10px;
    }

    .nav {
      padding-left: 14px;
    }
  }
`;
