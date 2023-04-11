import React, { createContext, useReducer } from "react";
import { main_reducer } from "./main_reducer";
import { MainActionType, MainType } from "./main_types";

export const initialState: MainType = {
  stage: "domain_search",
};

export const MainContext = createContext<
  [MainType, React.Dispatch<MainActionType>]
>([initialState, () => {}]);

export const MainProvider = (props: { children: React.ReactNode }) => {
  const [state, dispatch] = useReducer(main_reducer, initialState);

  return (
    <MainContext.Provider value={[state, dispatch]}>
      {props.children}
    </MainContext.Provider>
  );
};
