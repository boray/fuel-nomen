import { ValueAvilabilityType } from ".";

const Title = ({ value, available }: ValueAvilabilityType) => (
  <div
    className={
      "title" +
      (value
        ? available === true
          ? " title_available"
          : " title_unavailable"
        : "")
    }
  >
    Get Your Fuel Nomen!
  </div>
);

export default Title;
