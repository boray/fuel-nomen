import Image from "next/image";
import React, { useContext, useRef, useState } from "react";
import { MainContext } from "../../context/main_provider";
import SearchInput from "../SearchSection/search_input";

import { CongratsSectionStyled } from "./style";

const CongratsSection = () => {
  const [state, dispatch] = useContext(MainContext);
  const [inputValue, setInputValue] = useState("");
  const inputRef = useRef<HTMLInputElement>(null);

  const handleSubmit = () => {
    dispatch({
      type: "SET_STAGE",
      payload: {
        stage: "domain_search",
        domain_search_init: {
          input_value: inputValue,
          search_button_clicked: true,
        },
      },
    });
  };

  return (
    <CongratsSectionStyled>
      <div className="wrapper">
        <div className="title">Congrats!</div>
        <div className="check_circle">
          <Image src={"/icons/done.svg"} layout="fill" />
        </div>
        <div className="success_text">
          <span>{state?.domain_search?.value}</span>
          <span className="green">.fuel is forwarding to your wallet</span>
        </div>
      </div>
      <SearchInput
        inputValue={inputValue}
        setInputValue={setInputValue}
        inputRef={inputRef}
        handleSubmit={handleSubmit}
        congratsPage={true}
      />
    </CongratsSectionStyled>
  );
};

export default CongratsSection;
