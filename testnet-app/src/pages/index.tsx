import type { NextPage } from "next";
import { useContext } from "react";
import CongratsSection from "../components/CongratsSection";
import Header from "../components/Header";
import { Layout } from "../components/layout";
import RegisterDomain from "../components/RegisterDomain";
import SearchSection from "../components/SearchSection";
import Socials from "../components/Socials";
import { MainContext, MainProvider } from "../context/main_provider";

const Home: NextPage = () => {
  const [state, dispatch] = useContext(MainContext);

  return (
    <>
      {state?.stage === "domain_search" && (
        <>
          <SearchSection />
          <Socials />
        </>
      )}

      {state?.stage === "register_domain" && <RegisterDomain />}

      {state?.stage === "congrats_page" && (
        <>
          <CongratsSection />
        </>
      )}
    </>
  );
};

export default Home;
