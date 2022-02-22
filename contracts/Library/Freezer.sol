pragma solidity ^0.5.11;

import "./Ownable.sol";

contract Freezer is Ownable {
    event Freezed(address dsc);
    event Unfreezed(address dsc);

    mapping(address => bool) public freezing;

    modifier isFreezed(address src) {
        require(freezing[src] == false, "Freeze/Fronzen-Account");
        _;
    }

    function freeze(address dsc) external onlyOwner {
        require(dsc != address(0), "Freeze/Zero-Address");
        require(freezing[dsc] == false, "Freeze/Already-Freezed");

        freezing[dsc] = true;

        emit Freezed(dsc);
    }

    function unFreeze(address dsc) external onlyOwner {
        require(freezing[dsc] == true, "Freeze/Already-Unfreezed");

        delete freezing[dsc];

        emit Unfreezed(dsc);
    }
}
