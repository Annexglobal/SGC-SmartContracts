pragma solidity ^0.4.24;

import "./ERC20Mintable.sol";
import "../../access/roles/CapperRole.sol";

/**
 * @title Capped Coin
 * @dev Mintable Coin with a coin cap.
 */
contract ERC20Capped is ERC20Mintable, CapperRole {

  uint256 internal _latestCap;

  constructor(uint256 cap)
    public
  {
    require(cap > 0);
    _latestCap = cap;
  }

  /**
   * @return the cap for the coin minting.
   */
  function cap() public view returns(uint256) {
    return _latestCap;
  }

  function _updateCap (uint256 addCap) public onlyCapper {
    addCap = SafeMath.mul(addCap, 1 ether);   
    _latestCap = addCap; 
  }

  function _mint(address account, uint256 value) internal {
    value = SafeMath.mul(value, 1 ether);
    require(totalSupply().add(value) <= _latestCap);
    super._mint(account, value);
  }
}
