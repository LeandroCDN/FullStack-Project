// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SeedSale is Ownable {
    struct userPoints {
        uint256 points;
        uint256 amount;
    }

    bool public seedStatus;
    bool public secondPhase;
    uint public totalVolume;
    uint public totalPoints;
    uint public initialPrice;
    uint public startDate;
    uint public minAmount;
    IERC20 public currency;

    mapping(address user => userPoints points) public points;

    constructor(
        uint _initialPrice,
        address token,
        uint minAmount_
    ) Ownable(msg.sender) {
        initialPrice = _initialPrice;
        currency = IERC20(token);
        minAmount = minAmount_;
    }

    function buyPoints(uint amount) public {
        require(amount > minAmount, "no enought amount");
        require(seedStatus, "no seedStatus");
        currency.tranferFrom(msg.sender, address(this), amount);
        userPoints memory userData = userPoints({
            points: amount / getPrice(),
            amount: amount
        });
        points[msg.sender] = userData;
        totalPoints += userData.points;
        totalVolume += amount;
        // emit
    }
    function shellPoints() public {
        require(seedStatus, "No sale");
        require(!secondPhase, "No shellPoints in seconPhase");
        userPoints memory userData = points[msg.sender];
        totalPoints -= userData.points;
        points[msg.sender] = userPoints({points: 0, amount: 0});
        currency.transfer(msg.sender, userData.amount);
        totalVolumen += userData.amount;
        // emit
    }
    function setCurrency(address newCurrency) public onlyOwner {
        require(!seedStatus, "The Seed was started");
        currency = IERC20(newCurrency);
        // emit SetCurrency(newCurrency);
    }
    function setSeedStatus(bool status_) public onlyOwner {
        require(startDate > 0, "start Date error");
        seedStatus = status_;
    }
    function withdrawSeed() public onlyOwner {
        require(secondPhase, "seconPhase dont start");
        require(!seedStatus, "stop seedSale");
        currency.transfer(msg.sender, currency.balanceOf(address(this)));
    }
    function start() public onlyOwner {
        startDate = block.timestamp;
        seedStatus = true;
        // emit Start(startDate);
    }

    function setSecondPhase(bool secondPhase_) public onlyOwner {
        require(seedStatus, "seet status Error");
        require(startDate > 0, "start Date error");
        require(block.timestamp > startDate + 30 days, "start Date error");
        secondPhase = secondPhase_;
        // emit
    }
    function getUserData(address from) public view returns (uint, uint) {
        return (points[from].points, points[from].amount);
    }
    function getAllData()
        public
        view
        returns (bool, bool, uint, uint, uint, uint, uint)
    {
        return (
            seedStatus,
            secondPhase,
            totalVolumen,
            totalPoints,
            initialPrice,
            startDate,
            minAmount
        );
    }
    function getPrice() public view returns (uint) {
        uint difTimeInSeconds = block.timestamp - startDate;
        uint toWeeks = difTimeInSeconds / 1 weeks;
        return (initialPrice * (100 + toWeeks)) / 100;
    }
}
