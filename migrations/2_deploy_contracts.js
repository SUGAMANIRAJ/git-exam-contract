const DecentralizedExamSystem = artifacts.require("DecentralizedExamSystem");
const ExamManagement  = artifacts.require("ExamManagement");
const UserData = artifacts.require("UserData");

module.exports = function(deployer) {
  deployer.deploy(DecentralizedExamSystem);
  deployer.deploy(ExamManagement);
  deployer.deploy(UserData);
};
