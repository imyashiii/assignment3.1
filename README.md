# Decentralized Task Management System
A Decentralized Task Management System is a blockchain-based application designed to manage tasks in a transparent, secure, and decentralized manner. The core idea is to leverage the properties of blockchain technology, such as immutability, transparency, and decentralization, to create a task management platform that is free from centralized control and manipulation.
## Description
The program is written in Solidity, a programming language used to build smart contracts on the Ethereum blockchain. This smart contract is named "DeTask," short for decentralized task management. The contract contains various events, modifiers, and functions designed to manage the lifecycle of tasks. A Task entity is created to hold the specifications of a task, such as the task ID, description, creator address, assignee address, creation time, deadline, and completion status.
## Getting Started

### Executing Program
To execute this program you can go to the Remix IDE which is open IDE for Solidity. For that you can click on this link https://remix.ethereum.org/

Once you successfully reached to the IDE create a new file by clicking on the '+' icon and saving that file with .sol extension (e.g. DeTask.sol). After this copy and paste the code in your file that is given below 

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract DeTask {
    struct Task {
        uint256 id;
        string description;
        address creator;
        address assignee;
        uint256 creationTime;
        uint256 deadline;
        bool completed;
    }

    uint256 public tasksCount = 0;
    mapping(uint256 => Task) public tasks;

    event TaskCreated(uint256 id, string description, address creator, uint256 creationTime, uint256 deadline);
    event TaskAssigned(uint256 taskId, address assignee);
    event TaskCompleted(uint256 taskId, address assignee);
    event TaskInvalidated(uint256 taskId);

    modifier onlyCreator(uint256 taskId) {
        require(tasks[taskId].creator == msg.sender, "Only the creator can perform this action");
        _;
    }

    modifier onlyAssignee(uint256 taskId) {
        require(tasks[taskId].assignee == msg.sender, "Only the assignee can perform this action");
        _;
    }

    modifier taskExists(uint256 taskId) {
        require(taskId > 0 && taskId <= tasksCount, "The task does not exist");
        _;
    }

    modifier taskNotCompleted(uint256 taskId) {
        require(!tasks[taskId].completed, "Task has already been completed");
        _;
    }

    function createTask(string memory description, uint256 duration) public {
        require(bytes(description).length > 0, "Task description cannot be empty");
        require(duration > 60, "Duration must be greater than 1 minute");

        tasksCount++;
        tasks[tasksCount] = Task({
            id: tasksCount,
            description: description,
            creator: msg.sender,
            assignee: address(0),
            creationTime: block.timestamp,
            deadline: block.timestamp + duration,
            completed: false
        });

        emit TaskCreated(tasksCount, description, msg.sender, block.timestamp, block.timestamp + duration);
    }

    function assignTask(uint256 taskId, address assignee) public taskExists(taskId) onlyCreator(taskId) {
        require(assignee != address(0), "Assignee address cannot be zero");

        tasks[taskId].assignee = assignee;

        emit TaskAssigned(taskId, assignee);
    }

    function completeTask(uint256 taskId) public taskExists(taskId) onlyAssignee(taskId) taskNotCompleted(taskId) {
        tasks[taskId].completed = true;

        emit TaskCompleted(taskId, msg.sender);
    }

    function checkTaskState(uint256 taskId) public view taskExists(taskId) returns (bool) {
        Task storage task = tasks[taskId];
        return task.completed;
    }

    function invalidateTask(uint256 taskId) public taskExists(taskId) onlyCreator(taskId) taskNotCompleted(taskId) {
        delete tasks[taskId];

        emit TaskInvalidated(taskId);
    }
}

```

After pasting this code you have to compile the code from the left hand sidebar. click on the 'Solidity Compiler' then click on the 'Compile DeTask.sol' button.

After the successful compilation of the code you have to deploy the program. For that you have again another option on the left sidebar that is 'Deploy & Run Transactions' and then you will see a deploy button; before clicking on it make sure that the file showing there is 'DeTask.sol'. Then you will be able to see the file in the 'Deployed/Unpinned Contracts' click on that now all the public variable and functions are visible to you now execute and fetch the values according to you.


## Authors
Yashika Swami

## License
This project is licensed under the MIT License.
