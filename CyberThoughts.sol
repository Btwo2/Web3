/**
 *Submitted for verification at BscScan.com on 2023-08-22
*/

// SPDX-License-Identifier: MIT

// define solidity version
pragma solidity 0.8.18;

struct CyberThought {
    address author;
    string text;
    uint time;
    string name;
    string photo;
}

// define contract
contract CyberThoughts {
    address private owner;

    // define IDs index variable
    uint public nextID = 0;

    // define page publish number
    uint internal PAGE_SIZE = 5;

    // define contract owner
    constructor() {
        owner = msg.sender;
    }
    
    // change page publish number
    function changeSize(uint newSize) public notOwner {
        PAGE_SIZE = newSize;
    }
 
    modifier notOwner() {
        require(owner == msg.sender, "You do not have permission");
        _;
    }

    mapping(uint => CyberThought) public cyber_thoughts;

    mapping(address => string) public user;

    mapping(address => string) public image;

    // calldata make a variable temporary to avoid unnecessary memory saving
    function addCyberThought(string calldata text) public {
        CyberThought memory newCyberThought;
        newCyberThought.text = text;
        newCyberThought.author = msg.sender;    // pega o registro de quem enviou a mensagem
        newCyberThought.time = block.timestamp;

        nextID++;
        cyber_thoughts[nextID] = newCyberThought;
    }

    // delete thought
    function deleteCyberThought(uint delete_Cyber_Thought) public notOwner{
        if(delete_Cyber_Thought > 0){
            for (uint i = delete_Cyber_Thought; i < nextID + 1; i++)
                cyber_thoughts[i] = cyber_thoughts[i+1];
                nextID--;
        }
    }

    function changeName(string calldata newName) public {
        user[msg.sender] = newName;
    }

    function addPhoto(string calldata newPhoto) public {
        image[msg.sender] = newPhoto;
    }

    //10 cyber_thoughts
    //5 most recentes 

    function getLastCyberThought(uint pagina) public view returns (CyberThought[] memory){
        if(pagina < 1) pagina = 1;
        
        uint total_messages =  nextID - (PAGE_SIZE * (pagina - 1));
        
        uint index_end =  PAGE_SIZE;

        if(total_messages< 5) 
            index_end = total_messages;

        CyberThought[] memory LastCyberThoughts = new CyberThought[](index_end);
        
        for(uint i = 0; i < index_end; i++){
            LastCyberThoughts[i] = cyber_thoughts[total_messages- i];
            LastCyberThoughts[i].name = user[LastCyberThoughts[i].author];
            LastCyberThoughts[i].photo = image[LastCyberThoughts[i].author];
        }

        return LastCyberThoughts;
    }

    function getUserCyberThoughts(address UsuarioEspecifico) public view returns (CyberThought[] memory){
        
        CyberThought[] memory UserCyberThoughts = new CyberThought[](PAGE_SIZE);
        uint aux = 0;
        for(uint i = 0; i < nextID + 1; i++){
            if(cyber_thoughts[i].author == UsuarioEspecifico){
                UserCyberThoughts[aux] = cyber_thoughts[i];
                UserCyberThoughts[aux].name = user[UserCyberThoughts[i].author];
                UserCyberThoughts[aux].photo = image[UserCyberThoughts[i].author];
                aux++;
            }
            
        }

        return UserCyberThoughts;
    }
}