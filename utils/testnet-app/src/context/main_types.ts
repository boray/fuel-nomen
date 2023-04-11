type StageType = "domain_search" | "register_domain" | "congrats_page";

export type MainType = {
  domain_search?: {
    value: string;
    available: boolean;
  };
  stage: StageType;
  domain_search_init?: {
    input_value?: string;
    search_button_clicked?: boolean;
  };
};

export type MainActionType =
  | {
      type: "DOMAIN_SEARCH_RESULT";
      payload: {
        available: boolean;
        value: string;
      };
    }
  | {
      type: "SET_STAGE";
      payload: {
        stage: StageType;
        domain_search_init?: {
          input_value?: string;
          search_button_clicked?: boolean;
        };
      };
    }
  | {
      type: "RESET_DOMAIN_SEARCH_INIT";
      payload: {
        stage: StageType;
      };
    }
  | {
      type: "RESET";
    }
  | {
      type: "DOMAIN_SEARCH_RESET";
    };
