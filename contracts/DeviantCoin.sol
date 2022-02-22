// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
// pragma solidity ^.0.5.11;

import "./Interface/IERC20.sol";
import "./Interface/IMint.sol";
import "./Interface/IBurn.sol";

import "./Library/Ownable.sol";
import "./Library/SafeMath.sol";
import "./Library/Freezer.sol";
import "./Library/Pauser.sol";
import "./Library/Locker.sol";
import "./Library/Minter.sol";

contract DeviantCoin is IERC20, IMint, IBurn, Ownable, Freezer, Pauser, Locker, Minter {

  using SafeMath for uint256;

  string public constant name = "DeviantCoin Token";
  string public constant symbol = "wDEV";
  uint8 public constant decimals = 18;

  uint256 public totalSupply_ = 1000000000;

  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
  event Transfer(address indexed from, address indexed to, uint tokens);

  event Bought(uint256 amount);
  event Sold(uint256 amount);

  mapping(address => uint256) private balances;

  mapping(address => mapping(address => uint256)) private approved;

  constructor() public Minter() {
    totalSupply_ = totalSupply_.mul(10 ** uint256(decimals));
    // mint(5000 * (10 ** uint256(decimals)));
    balances[msg.sender] = totalSupply_;
  }

  function totalSupply() external view returns (uint256) {
    return totalSupply_;
  }

  function transfer(address _to, uint256 _value) external isFreezed(msg.sender) isLockup(msg.sender, _value) isPause returns (bool) {
    require (_to != address(0), "DeviantCoin/Not-Allow-Zero-Address");
    require (_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);

    return true;
  }

  function transferWithLockup(address _to, uint256 _value) external onlyOwner isLockup(msg.sender, _value) isPause returns (bool) {
    require(_to != address(0), "DeviantCoin/Not-Allow-Zero-Address");

    // update sender and recipient balance
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);

    lock(_to, _value);

    emit Transfer(msg.sender, _to, _value);

    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) external isFreezed(_from) isLockup(_from, _value) isPause returns (bool) {
    require(_from != address(0), "DeviantCoin/Not-Allow-Zero-Address");
    require(_to != address(0), "DeviantCoin/Not-Allow-Zero-Address");

    // update sender and recipient balance
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);

    approved[_from][msg.sender] = approved[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);

    return true;
  }

  function mint(uint256 _value) public isMinting onlyOwner isPause returns (bool) {
    totalSupply_ = totalSupply_.add(_value);
    balances[msg.sender] = balances[msg.sender].add(_value);
    
    return true;
  }

  function burn(uint256 _value) external isPause returns (bool) {
    require(_value <= balances[msg.sender], "DeviantCoin/Not-Allow-Unvalued-Burn");

    balances[msg.sender] = balances[msg.sender].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);

    emit Transfer(msg.sender, address(0), _value);

    return true;
  }

  function buy() payable public {
      uint256 _amountTobuy = msg.value;
      // uint256 _balance = balanceOf(address(this));
  
      // require(_amountTobuy > 0, "You need to send some ether");
      // require(_amountTobuy <= _balance, "Not enough tokens in the reserve");
      
      // transfer(msg.sender, _amountTobuy);
      
      emit Bought(_amountTobuy);
  }

  function sell(uint256 _amount) public {
      require(_amount > 0, "You need to sell at least some tokens");
  
      // uint256 _allowances = allowance(msg.sender, address(this));
  //     require(_allowances >= _amount, "Check the token allowance");
  //     transferFrom(msg.sender, address(this), _amount);
  //     msg.sender.transfer(_amount);

      emit Sold(_amount);
  }

  function approve(address _spender, uint256 _value) external isPause returns (bool) {
    require(_spender != address(0), "DeviantCoin/Not-Allow-Zero-Address");
    approved[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);

    return true;
  }
 
  // function balanceOf(address _account) external view returns (uint256) {
  //   return balances[_account];
  // }

  function balanceOf(address _account) public view returns (uint256) {
        return balances[_account];
    }


  function allowance(address _target, address _spender) external view returns (uint256) {
    return approved[_target][_spender];
  }

}
