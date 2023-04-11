import { ValueAvilabilityType } from ".";

const Availability = ({ value, available }: ValueAvilabilityType) => (
  <div className="availability">
    <span>{value}</span>
    <span
      className={available === true ? "text_available" : "text_unavailable"}
    >
      .fuel is {available === true ? "available" : "unavailable"}
    </span>
  </div>
);

export default Availability;
