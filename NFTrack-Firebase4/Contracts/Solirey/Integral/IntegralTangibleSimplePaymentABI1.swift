////
////  IntegralTangibleSimplePaymentABI.swift
////  NFTrack-Firebase4
////
////  Created by J C on 2021-11-15.
////
//
//let integralTangibleSimplePaymentABI1 = """
//[
//    {
//        "anonymous": false,
//        "inputs": [
//            {
//                "indexed": true,
//                "internalType": "address",
//                "name": "owner",
//                "type": "address"
//            },
//            {
//                "indexed": true,
//                "internalType": "address",
//                "name": "approved",
//                "type": "address"
//            },
//            {
//                "indexed": true,
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            }
//        ],
//        "name": "Approval",
//        "type": "event"
//    },
//    {
//        "anonymous": false,
//        "inputs": [
//            {
//                "indexed": true,
//                "internalType": "address",
//                "name": "owner",
//                "type": "address"
//            },
//            {
//                "indexed": true,
//                "internalType": "address",
//                "name": "operator",
//                "type": "address"
//            },
//            {
//                "indexed": false,
//                "internalType": "bool",
//                "name": "approved",
//                "type": "bool"
//            }
//        ],
//        "name": "ApprovalForAll",
//        "type": "event"
//    },
//    {
//        "anonymous": false,
//        "inputs": [
//            {
//                "indexed": false,
//                "internalType": "uint256",
//                "name": "id",
//                "type": "uint256"
//            }
//        ],
//        "name": "CreatePayment",
//        "type": "event"
//    },
//    {
//        "anonymous": false,
//        "inputs": [
//            {
//                "indexed": false,
//                "internalType": "uint256",
//                "name": "id",
//                "type": "uint256"
//            }
//        ],
//        "name": "PaymentMade",
//        "type": "event"
//    },
//    {
//        "anonymous": false,
//        "inputs": [
//            {
//                "indexed": true,
//                "internalType": "address",
//                "name": "from",
//                "type": "address"
//            },
//            {
//                "indexed": true,
//                "internalType": "address",
//                "name": "to",
//                "type": "address"
//            },
//            {
//                "indexed": true,
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            }
//        ],
//        "name": "Transfer",
//        "type": "event"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "id",
//                "type": "uint256"
//            }
//        ],
//        "name": "abort",
//        "outputs": [],
//        "stateMutability": "nonpayable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "address",
//                "name": "to",
//                "type": "address"
//            },
//            {
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            }
//        ],
//        "name": "approve",
//        "outputs": [],
//        "stateMutability": "nonpayable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "price",
//                "type": "uint256"
//            }
//        ],
//        "name": "createPayment",
//        "outputs": [],
//        "stateMutability": "nonpayable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "id",
//                "type": "uint256"
//            }
//        ],
//        "name": "pay",
//        "outputs": [],
//        "stateMutability": "payable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "price",
//                "type": "uint256"
//            },
//            {
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            }
//        ],
//        "name": "resell",
//        "outputs": [],
//        "stateMutability": "nonpayable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "address",
//                "name": "from",
//                "type": "address"
//            },
//            {
//                "internalType": "address",
//                "name": "to",
//                "type": "address"
//            },
//            {
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            }
//        ],
//        "name": "safeTransferFrom",
//        "outputs": [],
//        "stateMutability": "nonpayable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "address",
//                "name": "from",
//                "type": "address"
//            },
//            {
//                "internalType": "address",
//                "name": "to",
//                "type": "address"
//            },
//            {
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            },
//            {
//                "internalType": "bytes",
//                "name": "_data",
//                "type": "bytes"
//            }
//        ],
//        "name": "safeTransferFrom",
//        "outputs": [],
//        "stateMutability": "nonpayable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "address",
//                "name": "operator",
//                "type": "address"
//            },
//            {
//                "internalType": "bool",
//                "name": "approved",
//                "type": "bool"
//            }
//        ],
//        "name": "setApprovalForAll",
//        "outputs": [],
//        "stateMutability": "nonpayable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "address",
//                "name": "from",
//                "type": "address"
//            },
//            {
//                "internalType": "address",
//                "name": "to",
//                "type": "address"
//            },
//            {
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            }
//        ],
//        "name": "transferFrom",
//        "outputs": [],
//        "stateMutability": "nonpayable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "id",
//                "type": "uint256"
//            }
//        ],
//        "name": "withdraw",
//        "outputs": [],
//        "stateMutability": "nonpayable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "id",
//                "type": "uint256"
//            }
//        ],
//        "name": "withdrawFee",
//        "outputs": [],
//        "stateMutability": "nonpayable",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "",
//                "type": "uint256"
//            }
//        ],
//        "name": "_artist",
//        "outputs": [
//            {
//                "internalType": "address",
//                "name": "",
//                "type": "address"
//            }
//        ],
//        "stateMutability": "view",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "",
//                "type": "uint256"
//            }
//        ],
//        "name": "_simplePayment",
//        "outputs": [
//            {
//                "internalType": "uint256",
//                "name": "payment",
//                "type": "uint256"
//            },
//            {
//                "internalType": "uint256",
//                "name": "price",
//                "type": "uint256"
//            },
//            {
//                "internalType": "uint256",
//                "name": "fee",
//                "type": "uint256"
//            },
//            {
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            },
//            {
//                "internalType": "address",
//                "name": "seller",
//                "type": "address"
//            }
//        ],
//        "stateMutability": "view",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "address",
//                "name": "owner",
//                "type": "address"
//            }
//        ],
//        "name": "balanceOf",
//        "outputs": [
//            {
//                "internalType": "uint256",
//                "name": "",
//                "type": "uint256"
//            }
//        ],
//        "stateMutability": "view",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            }
//        ],
//        "name": "getApproved",
//        "outputs": [
//            {
//                "internalType": "address",
//                "name": "",
//                "type": "address"
//            }
//        ],
//        "stateMutability": "view",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "address",
//                "name": "owner",
//                "type": "address"
//            },
//            {
//                "internalType": "address",
//                "name": "operator",
//                "type": "address"
//            }
//        ],
//        "name": "isApprovedForAll",
//        "outputs": [
//            {
//                "internalType": "bool",
//                "name": "",
//                "type": "bool"
//            }
//        ],
//        "stateMutability": "view",
//        "type": "function"
//    },
//    {
//        "inputs": [],
//        "name": "name",
//        "outputs": [
//            {
//                "internalType": "string",
//                "name": "",
//                "type": "string"
//            }
//        ],
//        "stateMutability": "view",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            }
//        ],
//        "name": "ownerOf",
//        "outputs": [
//            {
//                "internalType": "address",
//                "name": "",
//                "type": "address"
//            }
//        ],
//        "stateMutability": "view",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "bytes4",
//                "name": "interfaceId",
//                "type": "bytes4"
//            }
//        ],
//        "name": "supportsInterface",
//        "outputs": [
//            {
//                "internalType": "bool",
//                "name": "",
//                "type": "bool"
//            }
//        ],
//        "stateMutability": "view",
//        "type": "function"
//    },
//    {
//        "inputs": [],
//        "name": "symbol",
//        "outputs": [
//            {
//                "internalType": "string",
//                "name": "",
//                "type": "string"
//            }
//        ],
//        "stateMutability": "view",
//        "type": "function"
//    },
//    {
//        "inputs": [
//            {
//                "internalType": "uint256",
//                "name": "tokenId",
//                "type": "uint256"
//            }
//        ],
//        "name": "tokenURI",
//        "outputs": [
//            {
//                "internalType": "string",
//                "name": "",
//                "type": "string"
//            }
//        ],
//        "stateMutability": "view",
//        "type": "function"
//    }
//]
//"""
//
