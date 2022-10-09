import Image from "next/image";
import { useEffect, useState } from "react";
import { ConnectButtonStyled } from "./style";

type StatusType = "connect" | "connected" | "disconnect";

export type ConnectButtonType = {
  buttonStatus: StatusType;
};

type ConnectButtonProps = {
  handleConnect: () => void;
  handleDisconnect: () => void;
  isConnected: boolean;
  connectedId?: string;
};

const ConnectButton = ({
  handleConnect,
  handleDisconnect,
  isConnected,
  connectedId,
}: ConnectButtonProps) => {
  const [buttonStatus, setButtonStatus] = useState<StatusType>("connect");

  useEffect(() => {
    if (isConnected) {
      setButtonStatus("connected");
    } else {
      setButtonStatus("connect");
    }
  }, [isConnected]);

  const handleConnectClick = async () => {
    if (isConnected) {
      await handleDisconnect();
    } else {
      await handleConnect();
    }
  };

  const handleConnectMouseHover = (over: boolean) => {
    if (isConnected) {
      setButtonStatus(over ? "disconnect" : "connected");
    }
  };

  return (
    <ConnectButtonStyled
      buttonStatus={buttonStatus}
      onClick={handleConnectClick}
      onMouseOver={() => handleConnectMouseHover(true)}
      onMouseOut={() => handleConnectMouseHover(false)}
    >
      {buttonStatus === "connect" ? (
        "Connect"
      ) : (
        <>
          {buttonStatus === "connected" ? "Connected" : "Disconnect"}{" "}
          <span className="connected-id">{connectedId}</span>
          <span className="disconnect-icon">
            <Image src={"/icons/cancel.svg"} width={20} height={20} />
          </span>
        </>
      )}
    </ConnectButtonStyled>
  );
};

export default ConnectButton;
