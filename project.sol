// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SkillEndorsements {
    struct Skill {
        string skillName;
        uint256 endorsements;
    }

    struct User {
        string name;
        string profileURI;
        mapping(string => Skill) skills;
        string[] skillList;
    }

    mapping(address => User) public users;

    event SkillAdded(address indexed user, string skillName);
    event SkillEndorsed(address indexed endorser, address indexed user, string skillName);

    // Add or update user profile
    function setProfile(string memory name, string memory profileURI) external {
        User storage user = users[msg.sender];
        user.name = name;
        user.profileURI = profileURI;
    }

    // Add a new skill
    function addSkill(string memory skillName) external {
        User storage user = users[msg.sender];

        require(bytes(skillName).length > 0, "Skill name cannot be empty");
        require(user.skills[skillName].endorsements == 0, "Skill already exists");

        user.skills[skillName] = Skill({skillName: skillName, endorsements: 0});
        user.skillList.push(skillName);

        emit SkillAdded(msg.sender, skillName);
    }

    // Endorse a skill
    function endorseSkill(address userAddress, string memory skillName) external {
        User storage user = users[userAddress];

        require(bytes(skillName).length > 0, "Skill name cannot be empty");
        require(user.skills[skillName].endorsements >= 0, "Skill does not exist");

        user.skills[skillName].endorsements++;

        emit SkillEndorsed(msg.sender, userAddress, skillName);
    }

    // Get user profile
    function getProfile(address userAddress)
        external
        view
        returns (
            string memory name,
            string memory profileURI,
            string[] memory skills
        )
    {
        User storage user = users[userAddress];
        return (user.name, user.profileURI, user.skillList);
    }

    // Get skill endorsements
    function getSkillEndorsements(address userAddress, string memory skillName)
        external
        view
        returns (uint256)
    {
        User storage user = users[userAddress];
        return user.skills[skillName].endorsements;
    }
}
