import Image from "next/image";
import React, { useContext } from "react";
import { MainContext } from "../../context/main_provider";
import { RegisterDomainStyled } from "./style";

const RegisterDomain = () => {
  const [state, dispatch] = useContext(MainContext);

  const handleGoNextStage = () => {
    dispatch({
      type: "SET_STAGE",
      payload: {
        stage: "congrats_page",
      },
    });
  };

  const handleCancelClick = () => {
    dispatch({
      type: "DOMAIN_SEARCH_RESET",
    });
    dispatch({
      type: "SET_STAGE",
      payload: {
        stage: "domain_search",
      },
    });
  };

  return (
    <>
      <RegisterDomainStyled>
        <div className="title">
          <span className="text">Register the Domain in 2 Steps</span>
          <span className="cancel-button" onClick={handleCancelClick}>
            <span className="cancel_text">Cancel </span>
            <span className="cancel_icon">
              <Image src={"/icons/baseline-cancel.svg"} layout="fill" />
            </span>
          </span>
        </div>
        <div className="steps">
          <div className="step_item active">
            <div className="circle">
              <div className="circle_wrapper green"></div>
            </div>
            <div className="step_content">
              <div className="step_title">Commit</div>
              <div className="step_desc">
                Your Fuel wallet will be opened. Please sign this tx.
              </div>
            </div>
          </div>
          <div className="step_item active">
            <div className="circle">
              <div className="circle_wrapper blue"></div>
            </div>
            <div className="step_content">
              <div className="step_title">Register</div>
              <div className="step_desc">
                Your Fuel wallet will be opened. Please sign this tx.
              </div>
            </div>
          </div>
          <div className="step_item">
            <div className="circle">
              <div className="circle_wrapper"></div>
            </div>
            <div className="step_content">
              <div className="step_title">Congrats!</div>
              <div className="step_desc">You owned the name!</div>
            </div>
          </div>
        </div>
      </RegisterDomainStyled>
      <div
        style={{ textAlign: "center", cursor: "pointer" }}
        onClick={handleGoNextStage}
      >
        tmp next button
      </div>
    </>
  );
};

export default RegisterDomain;
