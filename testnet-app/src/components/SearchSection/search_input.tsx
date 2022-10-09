import React, { useRef, useState } from "react";
import { SearchInputStyled } from "./style";

type SearchInputProps = {
  inputValue: string;
  inputRef: React.RefObject<HTMLInputElement>;
  setInputValue: React.Dispatch<React.SetStateAction<string>>;
  handleSubmit: () => void;
  congratsPage?: boolean;
};

const SearchInput = ({
  inputValue,
  inputRef,
  setInputValue,
  handleSubmit,
  congratsPage,
}: SearchInputProps) => {
  const [isTyped, setTyped] = useState(false);

  const handleOnInputKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === " " || e.code === "Space" || e?.keyCode == 32) {
      e.preventDefault();
      return;
    }

    if (e?.key === "Enter" || e?.code === "Enter" || e?.keyCode === 13) {
      handleSubmit();
    }
  };

  const handleOnChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(e?.target?.value);
    if (!isTyped) setTyped(true);
  };

  return (
    <SearchInputStyled className={inputValue?.length > 0 ? "writing" : ""}>
      <input
        type="text"
        className="search-input-text"
        onKeyDown={handleOnInputKeyDown}
        onChange={handleOnChange}
        value={inputValue}
        ref={inputRef}
        maxLength={32}
      />
      <div
        className="search-input"
        id="search-input"
        data-suffix={inputValue?.length > 0 ? ".fuel" : ""}
      >
        {inputValue}
      </div>
      <span
        className={
          "input-placeholder" + (inputValue?.length > 0 ? " hidden" : "")
        }
      >
        {!isTyped && "newdomain"}
        <span className="input-suffix">.fuel</span>
      </span>

      <span className="search-icon" onClick={handleSubmit}>
        <svg
          width="24px"
          height="24px"
          viewBox="0 0 25 24"
          version="1.1"
          xmlns="http://www.w3.org/2000/svg"
        >
          <g
            id="Symbols"
            stroke="none"
            strokeWidth="1"
            fill="none"
            fillRule="evenodd"
          >
            <g id="search/hover" transform="translate(-484.000000, -21.000000)">
              <g
                id="akar-icons:search"
                transform="translate(484.593810, 21.000000)"
              >
                <rect id="ViewBox" x="0" y="0" width="24" height="24"></rect>
                <path
                  d="M21,21 L16.514,16.506 M19,10.5 C19,15.1944204 15.1944204,19 10.5,19 C5.80557963,19 2,15.1944204 2,10.5 C2,5.80557963 5.80557963,2 10.5,2 C15.1944204,2 19,5.80557963 19,10.5 Z"
                  id="Shape"
                  stroke="#FFFFFF"
                  strokeWidth="2"
                  strokeLinecap="round"
                ></path>
              </g>
            </g>
          </g>
        </svg>
      </span>
    </SearchInputStyled>
  );
};

export default SearchInput;
