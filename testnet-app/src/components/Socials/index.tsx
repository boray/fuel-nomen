import Image from "next/image";
import { SocialsStyled } from "./style";

const Socials = () => {
  return (
    <SocialsStyled>
      <a className="social-link" href="#" target="_blank" rel="noreferrer">
        <div className="social-icon">
          <Image
            src={"/icons/twitter-icon.svg"}
            layout={"fill"}
            objectFit={"cover"}
          />
        </div>
      </a>
      <a className="social-link" href="#" target="_blank" rel="noreferrer">
        <div className="social-icon">
          <Image
            src={"/icons/medium-icon.svg"}
            layout={"fill"}
            objectFit={"cover"}
          />
        </div>
      </a>
      <a className="social-link" href="#" target="_blank" rel="noreferrer">
        <div className="social-icon">
          <Image
            src={"/icons/github-icon.svg"}
            layout={"fill"}
            objectFit={"cover"}
          />
        </div>
      </a>
    </SocialsStyled>
  );
};

export default Socials;
