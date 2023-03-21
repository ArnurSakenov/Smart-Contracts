// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    event SessionResult(address indexed sender, string message);
    struct VotingSession {
        string topic;
        mapping(uint => Option) options;
        mapping(address => bool) hasVoted;
        uint totalVotes;
    }
event VotingSessionResults(string topic, string[] optionNames, uint[] voteCounts);


    struct Option {
        string name;
        uint voteCount;
    }

    mapping(uint => VotingSession) public votingSessions;
    uint public nextVotingSessionId;

    function createVotingSession(string memory _topic, string[] memory _optionNames) public {
        VotingSession storage newVotingSession = votingSessions[nextVotingSessionId];
        newVotingSession.topic = _topic;

        for (uint i = 0; i < _optionNames.length; i++) {
            newVotingSession.options[i] = Option(_optionNames[i], 0);
        }

        nextVotingSessionId++;
    }

    function vote(uint _sessionId, uint _optionId) public {
        VotingSession storage session = votingSessions[_sessionId];
        require(!session.hasVoted[msg.sender], "You have already voted.");

        session.options[_optionId].voteCount++;
        session.hasVoted[msg.sender] = true;
        session.totalVotes++;
    }

    function getVoteCounts(uint _sessionId) public returns (string[] memory optionNames, uint[] memory voteCounts) {
        
        VotingSession storage session = votingSessions[_sessionId];
        uint optionsCount = 0;
        
        while (bytes(session.options[optionsCount].name).length > 0) {
            optionsCount++;
        }
        
        optionNames = new string[](optionsCount);
        voteCounts = new uint[](optionsCount);
        
        for (uint i = 0; i < optionsCount; i++) {
            optionNames[i] = session.options[i].name;
            voteCounts[i] = session.options[i].voteCount;
        }
        
        emit SessionResult(msg.sender, "");
    }

    function getSessionResults(uint _sessionId) public returns (string memory topic, string[] memory optionNames, uint[] memory voteCounts) {
    VotingSession storage session = votingSessions[_sessionId];
    topic = session.topic;
    (optionNames, voteCounts) = getVoteCounts(_sessionId);

    emit VotingSessionResults(topic, optionNames, voteCounts);
}

}
