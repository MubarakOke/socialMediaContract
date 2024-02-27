// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./INFTFactory.sol";
import "./INFT.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract SocialMedia is Context, AccessControl {
  // Structure for user information
  struct User {
    string username;
    bool isActive;
    address userNFT;
  }

  // Structure for group/community information
  struct Group {
    string name;
    address creator;
  }

  // Structure for post information
  struct Post {
    uint postID;
    uint NFTID;
    address creator;
  }

  // Structure for comments on NFTs
  struct Comment {
    address commenter;
    string content;
  }

  // Roles for Access Control
  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
  bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");
  bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

  uint256 postID;

  // Factory contract for NFT creation
  INFTFactory public nftFactory;

  // store user information
  mapping(address => User) public users;
  User[] public userArray;

  // store groups
  mapping(string => Group) public groups;
  mapping(string => address) public groupmembers;
  Group[] public groupArray;

  // store comments on NFTs
  mapping(uint256 => Comment[]) public comments;

  // store posts on NFTs
  mapping(uint256 => Post) public posts;
  Post[] public postArray;

  // search (author)
  mapping(address => Post[]) private postsByAuthor;

  // Event for NFT creation
  event NFTCreated(address creator, uint256 tokenId, string uri);

  // Event for user registration
  event UserRegistered(address user, string username);

  // Event for group creation
  event GroupCreated(string name, address creator);

  // Event for adding a comment
  event CommentAdded(uint256 tokenId, address commenter, string content);


  // Constructor to set up roles
  constructor(address NFTFActoryAddress) {
    _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);
    
    _grantRole(ADMIN_ROLE, _msgSender());

    nftFactory= INFTFactory(NFTFActoryAddress);
  }

  // Register a new user
  function register(string memory username) public {
    require(!users[_msgSender()].isActive, "User already registered");
    address userNFTAddress = address(nftFactory.createNFT(username));
    User memory newUser = User(username, true, userNFTAddress);

    users[_msgSender()] = newUser;
    userArray.push(newUser);

    _grantRole(USER_ROLE, _msgSender());
    emit UserRegistered(_msgSender(), username);
  }

  // Create a new NFT text post
  function createTextPost(string memory uri) public onlyRole(USER_ROLE) {
    uint256 postNFTId = nftFactory.mintText(users[_msgSender()].userNFT, _msgSender(), uri);
    Post memory newPost = Post(postID, postNFTId, _msgSender());
    posts[postID] = newPost;
    postArray.push(newPost);

    postsByAuthor[_msgSender()].push(newPost);
    
    postID= postID + 1;
    emit NFTCreated(_msgSender(), postNFTId, uri);
  }

  // Create a new NFT multimedia post
  function createMultimediaPost(string memory imageURI) public onlyRole(USER_ROLE) {
    uint256 postNFTId = nftFactory.mintMultiMedia(users[_msgSender()].userNFT, _msgSender(), imageURI);
    Post memory newPost = Post(postID, postNFTId, _msgSender());
    posts[postID] = newPost;
    postArray.push(newPost);

    postID= postID + 1;
    emit NFTCreated(_msgSender(), postNFTId, imageURI);
  }

  // Create a new group/community
  function createGroup(string memory name) public onlyRole(USER_ROLE) {
    require(groups[name].creator == address(0), "Group already exists");
    Group memory newGroup= Group(name, _msgSender());
    groups[name] = newGroup;
    groupmembers[name]= _msgSender();
    groupArray.push(newGroup);

    emit GroupCreated(name, _msgSender());
  }

  // Join a group/community
  function joinGroup(string memory name) public {
    Group storage group = groups[name];
    require(group.creator != address(0), "Group does not exist");

    groupmembers[name]= _msgSender();
  }

  // Add a comment to an NFT post
  function addComment(uint256 postId, string memory content) public onlyRole(USER_ROLE) {
    Post storage post= posts[postId];
    require(post.creator != address(0), "post does not exist");

    comments[postId].push(Comment(_msgSender(), content));
    emit CommentAdded(postId, _msgSender(), content);
  }

  // Search by Author
  function searchPostsByAuthor(address _author) public view returns (Post[] memory) {
        return postsByAuthor[_author];
  }
}