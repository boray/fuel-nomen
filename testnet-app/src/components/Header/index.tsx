import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/router";
import { useContext, useState } from "react";
import { MainContext } from "../../context/main_provider";
import ConnectButton from "../ConnectButton";
import { HeaderStyled } from "./style";

const Header = () => {
  // temporary
  const [connect, setConnect] = useState(false);
  const [state, dispatch] = useContext(MainContext);
  const router = useRouter();

  const handleLogoClick = () => {
    dispatch({
      type: "RESET",
    });
  };

  return (
    <HeaderStyled>
      <div className="wrapper">
        <div className="logo_container">
          <div className="logo">
            <Link href={"/"}>
              <a onClick={handleLogoClick}>
                <Image src={"/icons/logo.svg"} layout={"fill"} />
              </a>
            </Link>
          </div>
          <div className="side-text">TESTNET</div>
         
        </div>
        <div className="nav">
          <Link href={""}>
            <a className="nav-item">Docs</a>
          </Link>
          <Link href={""}>
            <a className="nav-item">Blog</a>
          </Link>
          <Link href={"/my-domains"}>
            <a
              className={
                "nav-item" +
                (router?.pathname === "/my-domains" ? " active" : "")
              }
            >
              My Domains
            </a>
          </Link>
          <ConnectButton
            isConnected={connect}
            connectedId={"0x924...6e0"}
            handleConnect={() => setConnect(true)}
            handleDisconnect={() => setConnect(false)}
            handleInstall={() => window.open("https://github.com/FuelLabs/fuels-wallet/blob/master/docs/INSTALL.md")}
          />
        </div>
      </div>
    </HeaderStyled>
  );
};

export default Header;
