pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

// Creating a GIV token with ERC20, Using Openzeppelin standard interface. 

contract GIVToken is ERC20PresetMinterPauser {
    constructor() ERC20PresetMinterPauser("Giving Token", "GIV") {
    }
}


// Need to customize totally supply, Deposit token, Liqudity Pool consideration.
// Integrate with split payment transfer feature.