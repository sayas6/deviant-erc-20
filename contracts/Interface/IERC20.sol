pragma solidity ^0.5.11;

interface IERC20 {

    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function balanceOf(address _target) external view returns (uint256);
    function allowance(address _target, address _spender) external view returns (uint256);

    function totalSupply() external view returns (uint256);

    // event
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}