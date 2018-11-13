pragma solidity ^0.4.24;

import "./ERC20.sol";
import "../../access/roles/MinterRole.sol";



/**
 * @title ERC20Mintable
 * @dev ERC20 minting logic
 */
contract ERC20Mintable is ERC20 {
  /**
   * @dev Function to mint tokens
   * @param to The address that will receive the minted tokens.
   * @param value The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(
    address to,
    uint256 value
  )
    public
    onlyMinter
    returns (bool)
  {
    _mint(to, value);
    return true;
  }

    function addMastercardUser(
    address user
  ) 
    public 
    onlyMinter 
  {
    mastercardUsers[user] = true;
  }

  function removeMastercardUser(
    address user
  ) 
    public 
    onlyMinter  
  {
    mastercardUsers[user] = false;
  }

  function updateWalletLock(
  ) 
    public 
    onlyMinter  
  {
    if(walletLock){
      walletLock = false;
    }
    else{
      walletLock = true;
    }

  }

    function updatePublicCheck(
  ) 
    public 
    onlyMinter  
  {
    if(publicLock){
      publicLock = false;
    }
    else{
      publicLock = true;
    }

  }
}
