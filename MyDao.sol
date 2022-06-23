pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT


contract MyDAO {
    
    address public leader;

    struct Voter {
        uint memberId;
        string name;
        uint voteRights;
    }

    struct Proposition{
        string propositionNames;
        uint agree;
        uint disagree;
    }

    mapping(uint => Proposition) public offers;
  
    mapping(address => Voter) public members;
    
    constructor() {
        leader = msg.sender;
        members[leader].voteRights = 2;
    }
   
   //leaders are always able to change
   function changeLeader(address _newLeader) public {
       require(msg.sender == leader);
       leader = _newLeader;
   }
    //Only leader can add mamber
    function addMember(uint _memberId, address _newMember, string memory _name) public {
        require(msg.sender == leader);
        members[_newMember].name = _name;
        members[_newMember].voteRights = 1;
        members[_newMember].memberId = _memberId;
    }

    //The members who has voted 5 times, will have 2 rights to vote
    function inc5VotedRights(address _5VotedMember) public {
        members[_5VotedMember].voteRights = 2;
    }

    //The members who has voted 5 times, will have 3 rights to vote
     function inc15VotedRights(address _15VotedMember) public {
        members[_15VotedMember].voteRights = 3;
    }


    function createProposition(uint _PropositionId, string memory _propositionName) public{
        require(members[msg.sender].voteRights > 1, "New members cant create proposition");
        offers[_PropositionId].propositionNames = _propositionName;
    }

        // 1 => agree
        // 0 => disagree
    function vote(uint _PropositionId, uint agreeornot) public {
        if(agreeornot == 1){
            offers[_PropositionId].agree +=1;
            members[msg.sender].voteRights --;
        } else if(agreeornot == 0) {
            offers[_PropositionId].disagree +=1;
            members[msg.sender].voteRights --;
        } else{
             revert("You can only agree or disagree");
        }
    }
   
    function result(uint _PropositionId) public view returns(string memory) {
        if(offers[_PropositionId].agree > offers[_PropositionId].disagree) {
            return "Agreed on the Proposition";
        } else if(offers[_PropositionId].agree == offers[_PropositionId].disagree){
            return "Didnt agree on a Proposition";
        } else{
            return "Proposition rejected";
        }
    }
}