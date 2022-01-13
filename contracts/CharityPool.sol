//SPDX-License-Identifier: Sablockchain0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./GivPaymentSplitter.sol";

/**
 * @dev Contract module which acts as a simple pool for collecting an ERC20 token.
 * in a real project there would most likely be more logic in this depending on
 * the complexity of the system. This is only an example contract for the
 * GivPaymentSplitter tutorial.
 *
 */
contract CharityPool is Ownable, GivPaymentSplitter {
    using SafeERC20 for IERC20;

    constructor(
        address[] memory _payees,
        uint256[] memory _shares,
        address _paymentToken
    ) GivPaymentSplitter(_payees, _shares, _paymentToken) {}

    function drainTo(address _transferTo, address _token) public onlyOwner {
        require(
            _token != paymentToken,
            "CharityPool: Token to drain is PaymentToken"
        );
        uint256 balance = IERC20(_token).balanceOf(address(this));
        require(balance > 0, "CharityPool: Token to drain balance is 0");
        IERC20(_token).safeTransfer(_transferTo, balance);
    }

}
