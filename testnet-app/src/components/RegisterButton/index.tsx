import Image from "next/image";
import React, { useContext } from "react";
import { MainContext } from "../../context/main_provider";
import MainButton from "../main_button";
import { ValueAvilabilityType } from "../SearchSection";
import { RegisterButtonStyled } from "./style";

type RegisterButtonProps = ValueAvilabilityType & {
  yearlyPrice?: string;
  totalPrice?: string;
};

const RegisterButton = ({ value, available }: RegisterButtonProps) => {
  const [state, dispatch] = useContext(MainContext);

  const handleButtonClick = () => {
    //buy actions, then

    dispatch({
      type: "SET_STAGE",
      payload: {
        stage: "register_domain",
      },
    });
  };

  return (
    <RegisterButtonStyled>
      <MainButton onClick={handleButtonClick}>
        <div className="button_wrapper">
          <span className="main-button-icon">
            <Image src={"/icons/ic-baseline-done.svg"} width={24} height={24} />
          </span>
          <span className="register_text">register</span>
          <span
            className={
              "domain_text" +
              (value?.length > 25
                ? " shrink-2"
                : value?.length > 10
                ? " shrink-1"
                : "")
            }
          >
            <span className="address">{value} </span>.fuel is available
          </span>
        </div>
      </MainButton>
    </RegisterButtonStyled>
  );
};

export default RegisterButton;
