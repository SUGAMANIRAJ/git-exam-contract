// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExamManagement {
    struct Exam {
        string examID;
        string name;
        string description;
        uint endDate;
        uint duration;
    }

    mapping(string => Exam) public exams;
    mapping(string => address[]) public examParticipants;
    mapping(string => uint) public examScores;

    function createExam(
        string memory _examID,
        string memory _name,
        string memory _description,
        uint _endDate,
        uint _duration
    ) public {
        exams[_examID] = Exam(_examID, _name, _description, _endDate, _duration);
    }

    function deleteExam(string memory _examID) public {
        delete exams[_examID];
    }

    function startExam(string memory _examID) public {
        examParticipants[_examID].push(msg.sender);
    }

    function submitScore(string memory _examID, uint _score) public {
        require(isParticipant(_examID, msg.sender), "Not a participant");
        examScores[_examID] = _score;
    }

    function isParticipant(string memory _examID, address _user) public view returns (bool) {
        address[] memory participants = examParticipants[_examID];
        for (uint i = 0; i < participants.length; i++) {
            if (participants[i] == _user) {
                return true;
            }
        }
        return false;
    }
}
