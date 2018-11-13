pragma solidity ^0.4.24;

import "./ERC20.sol";
import "../../lifecycle/Pausable.sol";

/**
 * @title Burnable coin
 * @dev Coin that can be irreversibly burned (destroyed).
 */
contract ERC20Burnable is ERC20, Pausable {

  /**
   * @dev Burns a specific amount of coins.
   * @param value The amount of coin to be burned.
   */
  function burn(uint256 value) public whenNotPaused{
    _burn(msg.sender, value);
  }

  /**
   * @dev Burns a specific amount of coins from the target address and decrements allowance
   * @param from address The address which you want to send coins from
   * @param value uint256 The amount of coin to be burned
   */
  function burnFrom(address from, uint256 value) public whenNotPaused {
    _burnFrom(from, value);
  }
}
