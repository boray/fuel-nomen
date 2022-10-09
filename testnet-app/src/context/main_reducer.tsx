import { initialState } from "./main_provider";
import { MainActionType, MainType } from "./main_types";

export const main_reducer = (
  state: MainType,
  action: MainActionType
): MainType => {
  switch (action.type) {
    case "DOMAIN_SEARCH_RESULT": {
      return {
        ...state,
        domain_search: {
          ...state?.domain_search,
          ...action.payload,
        },
      };
    }

    case "DOMAIN_SEARCH_RESET": {
      if (state?.domain_search) {
        delete state.domain_search;
      }
      return state;
    }

    case "SET_STAGE": {
      return {
        ...state,
        stage: action?.payload?.stage,
        domain_search_init: action?.payload?.domain_search_init,
      };
    }

    case "RESET_DOMAIN_SEARCH_INIT": {
      if (state?.domain_search) {
        delete state.domain_search_init;
      }
      return state;
    }

    case "RESET": {
      return initialState;
    }
    default: {
      return state;
    }
  }
};
