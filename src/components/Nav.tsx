import React from "react";

const Nav = () => {
  return (
    <div className="flex flex-row justify-between items-center bg-white px-3 py-1">
      <div className="flex text-black">
        <div>Links 1</div>
        <div>Links 2</div>
        <div>Links 3</div>
      </div>

      <div>
        <button className="flex text-black"> Connect Wallet</button>
      </div>
    </div>
  );
};

export default Nav;
