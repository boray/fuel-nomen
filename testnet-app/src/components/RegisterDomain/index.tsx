import Image from "next/image";
import React, { useContext, useState } from "react";
import { MainContext } from "../../context/main_provider";
import { RegisterDomainStyled } from "./style";

const RegisterDomain = () => {
  const [state, dispatch] = useContext(MainContext);
  const [step, setStep] = useState(1);

  const handleGoNextStage = () => {
    if (step === 3) {
      dispatch({
        type: "SET_STAGE",
        payload: {
          stage: "congrats_page",
        },
      });
    } else {
      setStep(step + 1);
    }
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
          <div className={"step_item " + (step >= 1 ? "active" : "")}>
            <div className="circle">
              <div
                className={"circle_wrapper " + (step >= 1 ? "green" : "")}
              ></div>
            </div>
            <div className="step_content">
              <div className="step_title">Commit</div>
              <div className="step_desc">
                Your Fuel wallet will be opened. Please sign this tx.
              </div>
            </div>
          </div>
          <div className={"step_item " + (step >= 2 ? "active" : "")}>
            <div className="circle">
              <div
                className={"circle_wrapper " + (step >= 2 ? "blue" : "")}
              ></div>
            </div>
            <div className="step_content">
              <div className="step_title">Register</div>
              <div className="step_desc">
                Your Fuel wallet will be opened. Please sign this tx.
              </div>
            </div>
          </div>
          <div className={"step_item " + (step >= 3 ? "active" : "")}>
            <div className="circle">
              <div className={"circle_wrapper " + (step >= 3 ? "green" : "")}></div>
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