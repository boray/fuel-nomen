import { MyDomainsListStyled } from "./style";

const MyDomainsList = () => {
  return (
    <MyDomainsListStyled>
      <div className="title">Your Fuel Nomens</div>
      <div className="domains">
        <div className="domain_item">
          <span>boray</span>
          <span className="gray">.fuel</span>
        </div>
        <div className="domain_item">
          <span>boray</span>
          <span className="gray">.fuel</span>
        </div>
        <div className="domain_item">
          <span>boray</span>
          <span className="gray">.fuel</span>
        </div>
        <div className="domain_item">
          <span>boray</span>
          <span className="gray">.fuel</span>
        </div>
      </div>
      <div className="note">
        Note: Currently, Fuel Nomen is beta and on the testnet. After the
        mainnet, you can modify your domains resolver.
      </div>
    </MyDomainsListStyled>
  );
};

export default MyDomainsList;
