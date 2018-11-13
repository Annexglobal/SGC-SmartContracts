pragma solidity ^0.4.24;

import "./IERC20.sol";
import "../../math/SafeMath.sol";
import "../../access/roles/MinterRole.sol";

contract ERC20 is IERC20, MinterRole {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;

  mapping(address => bool) mastercardUsers;

  mapping(address => bool) SGCUsers;

  bool public walletLock;

  bool public publicLock;

  uint256 private _totalSupply;

  /**
  * @dev Total number of coins in existence
  */
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  /**
  * @dev Total number of coins in existence
  */
  function walletLock() public view returns (bool) {
    return walletLock;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param owner The address to query the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }

  /**
   * @dev Function to check the amount of coins that an owner allowed to a spender.
   * @param owner address The address which owns the funds.
   * @param spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of coins still available for the spender.
   */
  function allowance(
    address owner,
    address spender
   )
    public
    view
    returns (uint256)
  {
    return _allowed[owner][spender];
  }

  /**
  * @dev Transfer coin for a specified address
  * @param to The address to transfer to.
  * @param value The amount to be transferred.
  */
  function transfer(address to, uint256 value) public returns (bool) {
    _transfer(msg.sender, to, value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of coins on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param spender The address which will spend the funds.
   * @param value The amount of coins to be spent.
   */
  function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0));

    value = SafeMath.mul(value,1 ether);
    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  /**
   * @dev Transfer coins from one address to another
   * @param from address The address which you want to send coins from
   * @param to address The address which you want to transfer to
   * @param value uint256 the amount of coins to be transferred
   */
  function transferFrom(
    address from,
    address to,
    uint256 value
  )
    public
    returns (bool)
  {
    value = SafeMath.mul(value, 1 ether);
    
    require(value <= _allowed[from][msg.sender]);
    require(value <= _balances[from]);
    require(to != address(0));
    require(value > 0);
    require(!mastercardUsers[from]);
    require(!walletLock);
    
    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);

    if(publicLock){
        require(
            SGCUsers[from]
            && SGCUsers[to]
        );
        _balances[from] = _balances[from].sub(value); 
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }
    else{
        _balances[from] = _balances[from].sub(value); 
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    return true;
  }

  /**
   * @dev Increase the amount of coins that an owner allowed to a spender.
   * approve should be called when allowed_[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO coin.sol
   * @param spender The address which will spend the funds.
   * @param addedValue The amount of coins to increase the allowance by.
   */
  function increaseAllowance(
    address spender,
    uint256 addedValue
  )
    public
    returns (bool)
  {
    require(spender != address(0));
    addedValue = SafeMath.mul(addedValue, 1 ether);

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].add(addedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of coins that an owner allowed to a spender.
   * approve should be called when allowed_[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO coin.sol
   * @param spender The address which will spend the funds.
   * @param subtractedValue The amount of coins to decrease the allowance by.
   */
  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  )
    public
    returns (bool)
  {
    require(spender != address(0));
    subtractedValue = SafeMath.mul(subtractedValue, 1 ether);
    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].sub(subtractedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  /**
  * @dev Transfer coin for a specified addresses
  * @param from The address to transfer from.
  * @param to The address to transfer to.
  * @param value The amount to be transferred.
  */
  function _transfer(address from, address to, uint256 value) internal {
    require(value <= _balances[from]);
    require(to != address(0));
    require(value > 0);
    require(!mastercardUsers[from]);

    if(publicLock && !walletLock){
        require(
           SGCUsers[from]
            && SGCUsers[to]
        );
    }

    if(isMinter(from)){
          _addSGCUsers(to);
          _balances[from] = _balances[from].sub(value); 
          _balances[to] = _balances[to].add(value);
          emit Transfer(from, to, value);
    }
    else{
      require(!walletLock);
      _balances[from] = _balances[from].sub(value); 
      _balances[to] = _balances[to].add(value);
      emit Transfer(from, to, value);
    }

  }

  /**
   * @dev Internal function that mints an amount of the coin and assigns it to
   * an account. This encapsulates the modification of balances such that the
   * proper events are emitted.
   * @param account The account that will receive the created coins.
   * @param value The amount that will be created.
   */
  function _mint(address account, uint256 value) internal {
    require(account != 0);

    _totalSupply = _totalSupply.add(value);
    _balances[account] = _balances[account].add(value);
    emit Transfer(address(0), account, value);
  }

  /**
   * @dev Internal function that burns an amount of the coin of a given
   * account.
   * @param account The account whose coins will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burn(address account, uint256 value) internal {
    value = SafeMath.mul(value,1 ether);

    require(account != 0);
    require(value <= _balances[account]);
    
    _totalSupply = _totalSupply.sub(value);
    _balances[account] = _balances[account].sub(value);
    emit Transfer(account, address(0), value);
  }

  /**
   * @dev Internal function that burns an amount of the coin of a given
   * account, deducting from the sender's allowance for said account. Uses the
   * internal burn function.
   * @param account The account whose coins will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burnFrom(address account, uint256 value) internal {
    value = SafeMath.mul(value,1 ether);
    require(value <= _allowed[account][msg.sender]);
    require(account != 0);
    require(value <= _balances[account]);

    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
       
    _totalSupply = _totalSupply.sub(value);
    _balances[account] = _balances[account].sub(value);
    emit Transfer(account, address(0), value);
  }

  function _addSGCUsers(address newAddress) onlyMinter public {
      if(!SGCUsers[newAddress]){
        SGCUsers[newAddress] = true;
      }
  }

  function getSGCUsers(address userAddress) public view returns (bool) {
    return SGCUsers[userAddress];
  }

}
