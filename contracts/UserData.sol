// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserData {
    enum Role {
        None,
        Student,
        Admin
    }

    struct User {
        string name;
        string email;
        Role role;
    }

    mapping(address => User) public users;
    mapping(address => bool) public isRegistered;

    function registerUser(
        string memory _name,
        string memory _email,
        Role _role
    ) public {
        require(!isRegistered[msg.sender], "User already registered");
        users[msg.sender] = User(_name, _email, _role);
        isRegistered[msg.sender] = true;
    }

    function getUser(
        address _userAddress
    ) public view returns (string memory, string memory, Role) {
        User memory user = users[_userAddress];
        return (user.name, user.email, user.role);
    }

    function checkRegistration() public view returns (bool) {
        return isRegistered[msg.sender];
    }

    event RegistrationFailed(address user, string reason);
}
