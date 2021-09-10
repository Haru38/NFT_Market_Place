// SPDX-License-Identifier: MIT

pragma solidity >= 0.4.0  < 0.9.0;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "hardhat/console.sol";

contract NFTMarket is ReentrancyGuard{
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemSold;

    address payable owner;
    uint256 listingPrice = 10 ether;

    constructor(){
        owner = payable(msg.sender);
    }

    function changeListingPrice(uint256 _price) public{
        require(msg.sender == owner,"only owner can change listing price");
        listingPrice = _price;
    }

    struct MarketItem{
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
    }

    //item id => struct MarketItem
    mapping(uint256=>MarketItem) private idToMarketItem;

    event MarketItemcreated(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price
    );

    //商品の作成
    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) public payable nonReentrant{
        require(price > 0,"price must be at least 1 wei");
        require(msg.value == listingPrice);

        _itemIds.increment();
        uint256 itemId = _itemIds.current();

        idToMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),//この段階では決まっていないためからのアドレスにする
            price
        );

        //NFTの所有権を移動
        IERC721(nftContract).transferFrom(msg.sender,address(this),tokenId);

        emit MarketItemcreated(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            price
        );
    }

    /** @dev 買い手(msg.sender)が送った値段が設定料金と同じだった場合に限り
    * (1)売り手にvalueをtransferし、(2)一時的なtokenの所有者であるこのコントラクトからmsg.senderに
    *権限を移動、(3)item情報のownerを更新することで、販売を完了させる。(イベント設定した方がいいかもね)    
    */
    function createMarketSale(
        address nftContract,
        uint256 itemId
    ) public payable nonReentrant{
        uint256 price = idToMarketItem[itemId].price;
        uint256 tokenId = idToMarketItem[itemId].tokenId;

        //買い手が送ったお金が値段と同じであることを必要とする制約
        require(msg.value == price);

        idToMarketItem[itemId].seller.transfer(msg.value);
        IERC721(nftContract).transferFrom(address(this),msg.sender,tokenId);
        idToMarketItem[itemId].owner = payable(msg.sender);
        _itemSold.increment();
        owner.transfer(listingPrice);

    }

    //売り切れていない商品をfetch
    function fetchMarketItems() public view returns(MarketItem[] memory){
        uint itemCount = _itemIds.current();
        uint unsoldItemCount = itemCount - _itemSold.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint i = 0; i < itemCount;i++){
            //売れていない(所有者のアドレスが空の商品の場合)
            if(idToMarketItem[i+1].owner == address(0)){
                uint currentId = idToMarketItem[i+1].itemId;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex++;
            }
        }
        return items;

    }

    //fetch my nft
    function MyNfts() public view returns(MarketItem[] memory){
        uint itemCount = _itemIds.current();
        uint itemCurrent = 0;
        uint currentIndex = 0;

        for(uint i = 0;i < itemCount;i++){
            if(msg.sender == idToMarketItem[i+1].owner){
                itemCurrent++;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCurrent);
        for (uint i = 0;i < itemCount;i++){
            if(msg.sender == idToMarketItem[i+1].owner){
                uint currentId = idToMarketItem[i+1].itemId;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex++;
            }
        }
        return items;
    }
}