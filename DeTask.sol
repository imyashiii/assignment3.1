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
