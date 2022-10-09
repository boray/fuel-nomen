import React, { useContext, useEffect, useRef, useState } from "react";
import { MainContext } from "../../context/main_provider";
import RegisterButton from "../RegisterButton";
import Availability from "./availability";
import SearchInput from "./search_input";
import { SearchInputStyled, SearchSectionStyled } from "./style";
import Title from "./title";

export type ValueAvilabilityType = { value: string; available: boolean };

const SearchSection = () => {
  const [state, dispatch] = useContext(MainContext);

  const [inputValue, setInputValue] = useState("");
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    setInputValue("");
    if (inputRef?.current?.value) {
      inputRef.current.value = "";
    }
  }, []);

  useEffect(() => {
    if (state?.domain_search_init?.input_value) {
      //Came here from entering input on Congrats page
      setInputValue(state?.domain_search_init?.input_value);
      if (inputRef?.current?.value) {
        inputRef.current.value = state?.domain_search_init?.input_value;
      }

      handleSubmit(state?.domain_search_init?.input_value);
    }
  }, [state?.domain_search_init]);

  const handleSubmit = async (settedInputValue?: string) => {
    const newInputValue =
      settedInputValue && settedInputValue?.length > 0
        ? settedInputValue
        : inputValue;
    if (newInputValue?.trim()?.length > 0) {
      //check if domain is available
      if (true) {
        dispatch({
          type: "DOMAIN_SEARCH_RESULT",
          payload: {
            value: newInputValue,
            available: true,
          },
        });
      } else {
        dispatch({
          type: "DOMAIN_SEARCH_RESULT",
          payload: {
            value: newInputValue,
            available: false,
          },
        });
      }
      //console.log("final value", newInputValue);
    }
  };

  return (
    <SearchSectionStyled>
      {state?.domain_search?.available !== true && (
        <Title
          value={state?.domain_search?.value || ""}
          available={state?.domain_search?.available || false}
        />
      )}

      {state?.domain_search?.available === true && (
        <Title
          value={state?.domain_search?.value || ""}
          available={state?.domain_search?.available || false}
        />
      )}
      <SearchInput
        inputValue={inputValue}
        setInputValue={setInputValue}
        inputRef={inputRef}
        handleSubmit={handleSubmit}
      />
      {state?.domain_search?.value &&
        state?.domain_search?.available !== true && (
          <Availability
            value={state?.domain_search?.value || ""}
            available={state?.domain_search?.available || false}
          />
        )}
      {state?.domain_search?.value &&
        state?.domain_search?.available === true && (
          <RegisterButton
            value={state?.domain_search?.value || ""}
            available={state?.domain_search?.available || false}
          />
        )}
    </SearchSectionStyled>
  );
};

export default SearchSection;
