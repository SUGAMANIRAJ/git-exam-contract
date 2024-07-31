// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedExamSystem {

    // Struct to hold exam details
    struct Exam {
        uint256 id;
        string name;
        address creator;
        uint256 creationTime;
        bool isActive;
    }

    // Struct to hold student details
    struct Student {
        bool isRegistered;
    }

    // Struct to hold student exam submission
    struct Submission {
        uint256 examId;
        string answer;
        bool isSubmitted;
    }

    // Mapping from exam ID to Exam details
    mapping(uint256 => Exam) public exams;
    // Mapping from student address to Student details
    mapping(address => Student) public students;
    // Mapping from student address to mapping of exam ID to Submission
    mapping(address => mapping(uint256 => Submission)) public submissions;
    // Counter for exam IDs
    uint256 public examCount;
    // List of active exams
    uint256[] public activeExams;
    // Event for exam creation
    event ExamCreated(uint256 examId, string examName, address creator, uint256 creationTime);
    // Event for exam submission
    event AnswerSubmitted(address student, uint256 examId, string answer, uint256 submissionTime);
    // Event for exam activation
    event ExamActivated(uint256 examId);
    // Event for exam deactivation
    event ExamDeactivated(uint256 examId);

    // Modifier to check if the caller is a student
    modifier onlyStudent() {
        require(students[msg.sender].isRegistered, "Only registered students can perform this action");
        _;
    }

    // Modifier to check if the caller is a creator
    modifier onlyCreator() {
        require(isCreator(msg.sender), "Only creators can perform this action");
        _;
    }

    // Mapping to track registered creators
    mapping(address => bool) public creators;

    // Function to register as a creator
    function registerAsCreator() public {
        require(!creators[msg.sender], "Address is already a creator");
        creators[msg.sender] = true;
    }

    // Function to check if an address is a creator
    function isCreator(address _address) public view returns (bool) {
        return creators[_address];
    }

    // Function to create a new exam
    function createExam(string memory _examName) public onlyCreator {
        examCount++;
        exams[examCount] = Exam(examCount, _examName, msg.sender, block.timestamp, false);
        emit ExamCreated(examCount, _examName, msg.sender, block.timestamp);
    }

    // Function to activate an exam
    function activateExam(uint256 _examId) public onlyCreator {
        require(exams[_examId].creator == msg.sender, "Only the creator can activate this exam");
        require(!exams[_examId].isActive, "Exam is already active");
        exams[_examId].isActive = true;
        activeExams.push(_examId);
        emit ExamActivated(_examId);
    }

    // Function to deactivate an exam
    function deactivateExam(uint256 _examId) public onlyCreator {
        require(exams[_examId].creator == msg.sender, "Only the creator can deactivate this exam");
        require(exams[_examId].isActive, "Exam is already inactive");
        exams[_examId].isActive = false;
        // Remove exam from active exams
        for (uint256 i = 0; i < activeExams.length; i++) {
            if (activeExams[i] == _examId) {
                activeExams[i] = activeExams[activeExams.length - 1];
                activeExams.pop();
                break;
            }
        }
        emit ExamDeactivated(_examId);
    }

    // Function for students to register
    function registerStudent() public {
        require(!students[msg.sender].isRegistered, "Student already registered");
        students[msg.sender] = Student(true);
    }

    // Function to submit an answer
    function submitAnswer(uint256 _examId, string memory _answer) public onlyStudent {
        require(exams[_examId].isActive, "Exam is not active");
        require(!submissions[msg.sender][_examId].isSubmitted, "Answer already submitted");

        submissions[msg.sender][_examId] = Submission(_examId, _answer, true);
        emit AnswerSubmitted(msg.sender, _examId, _answer, block.timestamp);
    }

    // Function to retrieve details of an exam
    function getExam(uint256 _examId) public view returns (Exam memory) {
        return exams[_examId];
    }

    // Function to retrieve submission details of a student for a particular exam
    function getSubmission(address _student, uint256 _examId) public view returns (Submission memory) {
        return submissions[_student][_examId];
    }

    // Function to retrieve list of active exams
    function getActiveExams() public view returns (uint256[] memory) {
        return activeExams;
    }
}
