// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DVoteHorizon {
    address public owner;
    uint256 public candidateCount;
    uint256 public voterCount;

    struct Voter {
        string name;
        address voterAddress;
        bool isRegistered;
    }

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    // Mapping of voter addresses to their details
    mapping(address => Voter) public voters;
    // Mapping to track if an address has voted
    mapping(address => bool) public hasVoted;
    // Mapping of candidate IDs to their details
    mapping(uint256 => Candidate) public candidates;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Register a new voter
    function registerVoter(string calldata name, address voterAddress) external onlyOwner {
        require(voterAddress != address(0), "Invalid voter address");
        require(!voters[voterAddress].isRegistered, "Voter already registered");
        voterCount++;
        voters[voterAddress] = Voter(name, voterAddress, true);
    }

    // Update an existing voter's address
    function updateVoterAddress(address oldAddress, address newAddress) external onlyOwner {
        require(newAddress != address(0), "Invalid new address");
        require(voters[oldAddress].isRegistered, "Old address not registered");
        require(!voters[newAddress].isRegistered, "New address already registered");

        // Transfer voter details to new address
        Voter memory voter = voters[oldAddress];
        voter.voterAddress = newAddress;
        voters[newAddress] = voter;

        // Transfer voting status if applicable
        if (hasVoted[oldAddress]) {
            hasVoted[newAddress] = true;
        }

        // Remove old address registration
        delete voters[oldAddress];
        delete hasVoted[oldAddress];
    }

    // Add a candidate
    function addCandidate(string calldata name) external onlyOwner {
        require(bytes(name).length > 0, "Candidate name cannot be empty");
        candidateCount++;
        candidates[candidateCount] = Candidate(name, 0);
    }

    // Cast a vote for a candidate
    function vote(uint256 candidateId) external {
        require(isVoterRegistered(msg.sender), "Voter not registered");
        require(!hasVoted[msg.sender], "Voter has already voted");
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate ID");

        hasVoted[msg.sender] = true;
        candidates[candidateId].voteCount++;
    }

    // Check if an address is registered
    function isVoterRegistered(address voter) public view returns (bool) {
        return voters[voter].isRegistered;
    }

    // Get voter details
    function getVoterDetails(address voter) public view returns (string memory name, address voterAddress, bool isRegistered) {
        Voter memory v = voters[voter];
        return (v.name, v.voterAddress, v.isRegistered);
    }

    // Get candidate details and vote count
    function getCandidateVotes(uint256 candidateId) public view returns (string memory name, uint256 voteCount) {
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate ID");
        Candidate memory c = candidates[candidateId];
        return (c.name, c.voteCount);
    }
}
