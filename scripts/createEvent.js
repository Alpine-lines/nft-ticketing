const Web3 = require("web3");

const web3 = new Web3(new Web3.providers.WebsocketProvider("wss://mainnet.aurora.dev/"));

const abi = [
  {
    constant: true,
    inputs: [
      {
        name: "_interfaceId",
        type: "bytes4",
      },
    ],
    name: "supportsInterface",
    outputs: [
      {
        name: "",
        type: "bool",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [],
    name: "name",
    outputs: [
      {
        name: "",
        type: "string",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "getApproved",
    outputs: [
      {
        name: "",
        type: "address",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_to",
        type: "address",
      },
      {
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "approve",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "",
        type: "address",
      },
      {
        name: "",
        type: "uint256",
      },
    ],
    name: "ownedEventTickets",
    outputs: [
      {
        name: "",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [],
    name: "totalSupply",
    outputs: [
      {
        name: "",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [],
    name: "InterfaceId_ERC165",
    outputs: [
      {
        name: "",
        type: "bytes4",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_eventId",
        type: "uint256",
      },
      {
        name: "_qty",
        type: "uint256",
      },
    ],
    name: "vipRemaining",
    outputs: [
      {
        name: "",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_from",
        type: "address",
      },
      {
        name: "_to",
        type: "address",
      },
      {
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "transferFrom",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_eventId",
        type: "uint256",
      },
    ],
    name: "getEventVIP",
    outputs: [
      {
        name: "vipAvailable",
        type: "bool",
      },
      {
        name: "vipPrice",
        type: "uint256",
      },
      {
        name: "vipTicketSupply",
        type: "uint256",
      },
      {
        name: "vipSold",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_owner",
        type: "address",
      },
      {
        name: "_index",
        type: "uint256",
      },
    ],
    name: "tokenOfOwnerByIndex",
    outputs: [
      {
        name: "",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_ticketId",
        type: "uint256",
      },
      {
        name: "_eventId",
        type: "uint256",
      },
      {
        name: "_vip",
        type: "bool",
      },
    ],
    name: "redeemTicket",
    outputs: [
      {
        name: "",
        type: "bool",
      },
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [],
    name: "getEventsCount",
    outputs: [
      {
        name: "",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_owner",
        type: "address",
      },
    ],
    name: "ticketsOf",
    outputs: [
      {
        name: "",
        type: "uint256[]",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [],
    name: "unpause",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_from",
        type: "address",
      },
      {
        name: "_to",
        type: "address",
      },
      {
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "safeTransferFrom",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_name",
        type: "string",
      },
      {
        name: "_time",
        type: "uint256",
      },
      {
        name: "_token",
        type: "bool",
      },
      {
        name: "_limited",
        type: "bool",
      },
      {
        name: "_price",
        type: "uint256",
      },
      {
        name: "_seats",
        type: "uint256",
      },
      {
        name: "_vipAvailable",
        type: "bool",
      },
      {
        name: "_vipPrice",
        type: "uint256",
      },
      {
        name: "_vipTicketSupply",
        type: "uint256",
      },
      {
        name: "_ipfs",
        type: "string",
      },
    ],
    name: "createEvent",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "exists",
    outputs: [
      {
        name: "",
        type: "bool",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_index",
        type: "uint256",
      },
    ],
    name: "tokenByIndex",
    outputs: [
      {
        name: "",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_eventId",
        type: "uint256",
      },
      {
        name: "_vip",
        type: "bool",
      },
      {
        name: "_qty",
        type: "uint256",
      },
    ],
    name: "buyTicket",
    outputs: [],
    payable: true,
    stateMutability: "payable",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_promoter",
        type: "address",
      },
      {
        name: "_eventId",
        type: "uint256",
      },
      {
        name: "_comps",
        type: "uint256",
      },
    ],
    name: "setEventPromoterComps",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [],
    name: "paused",
    outputs: [
      {
        name: "",
        type: "bool",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "ownerOf",
    outputs: [
      {
        name: "",
        type: "address",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_owner",
        type: "address",
      },
    ],
    name: "eventsOf",
    outputs: [
      {
        name: "",
        type: "uint256[]",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_eventId",
        type: "uint256",
      },
    ],
    name: "getEvent",
    outputs: [
      {
        name: "name",
        type: "string",
      },
      {
        name: "time",
        type: "uint256",
      },
      {
        name: "token",
        type: "bool",
      },
      {
        name: "limited",
        type: "bool",
      },
      {
        name: "price",
        type: "uint256",
      },
      {
        name: "seats",
        type: "uint256",
      },
      {
        name: "sold",
        type: "uint256",
      },
      {
        name: "ipfs",
        type: "string",
      },
      {
        name: "owner",
        type: "address",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_owner",
        type: "address",
      },
    ],
    name: "balanceOf",
    outputs: [
      {
        name: "",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_promoter",
        type: "address",
      },
      {
        name: "_eventId",
        type: "uint256",
      },
    ],
    name: "getEventPromoterComps",
    outputs: [
      {
        name: "comps",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_id",
        type: "uint256",
      },
    ],
    name: "getTicket",
    outputs: [
      {
        name: "",
        type: "uint256",
      },
      {
        name: "",
        type: "uint256",
      },
      {
        name: "",
        type: "bool",
      },
      {
        name: "",
        type: "string",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [],
    name: "pause",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [],
    name: "owner",
    outputs: [
      {
        name: "",
        type: "address",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [],
    name: "symbol",
    outputs: [
      {
        name: "",
        type: "string",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_owner",
        type: "address",
      },
      {
        name: "event_id",
        type: "uint256",
      },
    ],
    name: "eventTicketBalanceOf",
    outputs: [
      {
        name: "",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_to",
        type: "address",
      },
      {
        name: "_approved",
        type: "bool",
      },
    ],
    name: "setApprovalForAll",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_from",
        type: "address",
      },
      {
        name: "_to",
        type: "address",
      },
      {
        name: "_tokenId",
        type: "uint256",
      },
      {
        name: "_data",
        type: "bytes",
      },
    ],
    name: "safeTransferFrom",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_admin",
        type: "address",
      },
    ],
    name: "getAdminEvent",
    outputs: [
      {
        name: "",
        type: "uint256",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "tokenURI",
    outputs: [
      {
        name: "",
        type: "string",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_guest",
        type: "address",
      },
      {
        name: "_eventId",
        type: "uint256",
      },
      {
        name: "_vip",
        type: "bool",
      },
      {
        name: "_qty",
        type: "uint256",
      },
    ],
    name: "grantTicket",
    outputs: [],
    payable: true,
    stateMutability: "payable",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      {
        name: "_owner",
        type: "address",
      },
      {
        name: "_operator",
        type: "address",
      },
    ],
    name: "isApprovedForAll",
    outputs: [
      {
        name: "",
        type: "bool",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_newOwner",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      {
        name: "_admin",
        type: "address",
      },
      {
        name: "_eventId",
        type: "uint256",
      },
    ],
    name: "setEventAdmin",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        name: "owner",
        type: "address",
      },
      {
        indexed: false,
        name: "eventId",
        type: "uint256",
      },
    ],
    name: "CreatedEvent",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        name: "buyer",
        type: "address",
      },
      {
        indexed: true,
        name: "eventId",
        type: "uint256",
      },
      {
        indexed: false,
        name: "ticketId",
        type: "uint256",
      },
      {
        indexed: false,
        name: "vip",
        type: "bool",
      },
    ],
    name: "SoldTicket",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        name: "eventId",
        type: "uint256",
      },
      {
        indexed: false,
        name: "ticketId",
        type: "uint256",
      },
      {
        indexed: false,
        name: "vip",
        type: "bool",
      },
    ],
    name: "RedeemedTicket",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [],
    name: "Pause",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [],
    name: "Unpause",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        name: "previousOwner",
        type: "address",
      },
    ],
    name: "OwnershipRenounced",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        name: "_from",
        type: "address",
      },
      {
        indexed: true,
        name: "_to",
        type: "address",
      },
      {
        indexed: true,
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        name: "_owner",
        type: "address",
      },
      {
        indexed: true,
        name: "_approved",
        type: "address",
      },
      {
        indexed: true,
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        name: "_owner",
        type: "address",
      },
      {
        indexed: true,
        name: "_operator",
        type: "address",
      },
      {
        indexed: false,
        name: "_approved",
        type: "bool",
      },
    ],
    name: "ApprovalForAll",
    type: "event",
  },
];

// const eventDetails = {
//   name: "Jet Gang NFT Benefit Concert Series | ETHDenver",
//   description: `Cheers to another great year @ ETHDenver. Come celebrate the tremendous growth of
//                 one of the world's premier cryptocurrency events. 10% of All revenue will be
//                 donated to NFTrees, helping to adress the world's climate crisis. The most
//                 amazing thing about this community is how much we care about people and the world.
//                 Let's get together and show our love!`,
//   file: null,
//   time: Date.parse("20 Feb 2022 00:7:30 MDT"),
//   currency: "eth",
//   price: web3.utils.toWei("0.05"),
//   limited: true,
//   seats: 400,
// };

// const createEvent = async () => {
//   const contract = await new web3.eth.Contract(abi, "0x602689C01E8EB52e6f4939c164848a75EAbcC63c");

//   const account = web3.eth.accounts.wallet.add(
//     "06b2ca722441fc7ce6bb61c66aae0f928eb4012f9c03d89100e19396349510dc"
//   );

//   const gasEstimate = await contract.methods
//     .createEvent(
//       "Jet Gang NFT Benefit Concert Series | ETHDenver",
//       Date.parse("20 Feb 2022 00:07:30 MDT"),
//       false,
//       true,
//       web3.utils.toWei("0.0175"),
//       400,
//       true,
//       web3.utils.toWei("0.45"),
//       50,
//       "ipfs://QmYZwj6SK5nyJfzNxs6i29uFCkF7yCsdTnKunz7MF7uDmi"
//     )
//     .estimateGas();

//   const id = await contract.methods
//     .createEvent(
//       "Jet Gang NFT Benefit Concert Series | ETHDenver",
//       Date.parse("20 Feb 2022 00:07:30 MDT"),
//       false,
//       true,
//       web3.utils.toWei("0.0175"),
//       400,
//       true,
//       web3.utils.toWei("0.45"),
//       50,
//       "ipfs://QmYZwj6SK5nyJfzNxs6i29uFCkF7yCsdTnKunz7MF7uDmi"
//     )
//     .send({ from: account.address, gas: gasEstimate });
// };

const buyTicket = async () => {
  const contract = await new web3.eth.Contract(abi, "0x602689C01E8EB52e6f4939c164848a75EAbcC63c");

  const account = web3.eth.accounts.wallet.add(
    "06b2ca722441fc7ce6bb61c66aae0f928eb4012f9c03d89100e19396349510dc"
  );

  const gasEstimate = await contract.methods
    .buyTicket(0, false, 1)
    .estimateGas({ from: account.address });
  const receipt = await contract.methods
    .buyTicket(0, false, 1)
    .send({ from: account.address, gas: gasEstimate });

  console.log({ receipt });
};

// createEvent();

buyTicket();
