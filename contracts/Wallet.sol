// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./Layers.sol";

contract Wallet {
  using Layers for Layers.Layer;


  bool sendIncoming_Transfer_To_TransfersQueue;
  bool sendIncoming_Add_LayerToMakeTransfer_To_AddLayersToMakeTransferQueue;
  bool sendIncoming_Remove_LayerToMakeTransfer_To_RemoveLayersToMakeTransferQueue;


  struct AmountMinMax {
    uint256 min;
    uint256 max;
  }

  struct Layer {
    AmountMinMax amount;

    uint numTokens;
    mapping (uint => string) tokens;

    uint numLayerFlowLayers;
    mapping (uint => Layers.Layer) layerFlow;
  }

  uint numAddLayersToMakeTransfer;
  mapping (uint => Layer) AddLayersToMakeTransferQueue;
  uint numRemoveLayersToMakeTransfer;
  mapping (uint => Layer) RemoveLayersToMakeTransferQueue;
  uint numLayersToMakeTransfer;
  mapping (uint => Layer) LayersToMakeTransfer;

  uint numTransferLayers;
  mapping (uint => mapping (uint => Layer)) TransferLayers;

  struct Transfer {
    uint256 transferNum;

    address receiver;
    uint256 amount;

    uint256 transferLayersIndex;

    bool executed;
  }
  
  uint256 numTransfersInTransfersQueue;
  mapping(uint => Transfer) TransfersQueue;
  uint256 numTransfersInTransfers;
  mapping(uint256 => Transfer) Transfers;


  function addLayerToMakeTransfer(
    uint256 _amountMin,
    uint256 _amountMax
  ) private {
    if (sendIncoming_Add_LayerToMakeTransfer_To_AddLayersToMakeTransferQueue == false) {
      _addLayerToMakeTransfer(_amountMin, _amountMax);
    } else {
      _addLayerToMakeTransferToAddLayersMakeTransferQueue(_amountMin, _amountMax);
    }

    // here incoming transfers are going straight to transfers after _addLayer... above
    // because sendIncoming_Transfer_To_TransfersQueue is false
    // need to be true and while loop not for loop inside move
    // move needs deque

    if (numTransfersInTransferQueue > 0) {
      moveTransfersFromTransfersQueueToTransfers();
    }
  }

  function _addLayerToMakeTransfer(
    uint256 _amountMin,
    uint256 _amountMax
  ) private {
    sendIncoming_Transfer_To_TransfersQueue = true;
    sendIncoming_Remove_LayerToMakeTransfer_To_RemoveLayersToMakeTransferQueue = true;

    // ...

    sendIncoming_Transfer_To_TransfersQueue = false;
    sendIncoming_Remove_LayerToMakeTransfer_To_RemoveLayersToMakeTransferQueue = false;
  }

  function _addLayerToMakeTransferToAddLayersMakeTransferQueue(
    uint256 _amountMin,
    uint256 _amountMax
  ) private {
    // do nothing here just add it
  }

  function addLayerToMakeTransfer(
    uint256 _amountMin,
    uint256 _amountMax
  ) private {
    if (sendIncomingAddLayerToMakeTransferToAddLayerToMakeTransferQueue) {
      //
    }

    sendIncomingTransfersToTransfersQueue = true;

    // ...

    if (numTransfersInTransferQueue > 0) {
      moveTransfersFromTransfersQueueToTransfers();
    }
    
    sendIncomingTransfersToTransfersQueue = false;
  }

  function removeLayerToMakeTransfer(
    uint256 _amountMin,
    uint256 _amountMax
  ) private {
    if (sendIncomingRemoveLayerToMakeTransferToRemoveLayerToMakeTransferQueue) {
      //
    }

    sendIncomingTransfersToTransfersQueue = true;

    // ...

    if (numTransfersInTransferQueue > 0) {
      moveTransfersFromTransfersQueueToTransfers();
    }

    sendIncomingTransfersToTransfersQueue = false;
  }

  function makeTransfer(
    address _receiver,
    uint256 _amount
  ) private {
    if (sendIncomingTransfersToTransfersQueue == false) {
      addTransferToTransfers(_receiver, _amount);
    } else {
      addTransferToTransfersQueue(_receiver, _amount);
    }
  }

  function addTransferToTransfers(
    address _receiver,
    uint256 _amount
  ) private {
    require(numX, numXX); // TODO
    addTransferLayers();
    addTransfer(false, _receiver, _amount);
    require(numX, numXX); // TODO
  }

  function addTransferToTransfersQueue(
    address _receiver,
    uint256 _amount
  ) private {
    require(numX, numXX); // TODO
    addTransfer(true, _receiver, _amount);
    require(numX, numXX); // TODO
  }

  // transfer exists without layers in queue
  // need to take the first one from queue
  // add layers
  // add to transfers
  function moveTransferFromTransfersQueueToTransfers(
    // by id or index??
  ) private {
    sendIncoming_Transfer_To_TransfersQueue = true;

    // ...

    sendIncoming_Transfer_To_TransfersQueue = true;

    // ... ...



    sendIncomingAddLayerToMakeTransferToAddLayerToMakeTransferQueue = true;
    sendIncomingRemoveLayerToMakeTransferToRemoveLayerToMakeTransferQueue = true;

    addTransfer(false);
    deleteTransferFromTransfersQueue();

    sendIncomingAddLayerToMakeTransferToAddLayerToMakeTransferQueue = false;
    sendIncomingRemoveLayerToMakeTransferToRemoveLayerToMakeTransferQueue = false;
  }

  function deleteTransferFromTransfersQueue(
    // ...
  ) private {
    // ...
  }

  function addTransferLayers(
    // ????
  ) private {
    //
  }

  function addTransfer(
    bool _toTransfersQueue,

    // ???
    address _receiver,
    uint256 _amount
  ) private {
    if (_toTransfersQueue == false) {
      //
    } else {
      //
    }
  }


  function startExecuteTransferLayers(
    // ???
  ) private {
    //
  }

  function executeTransferLayersForSeqNum(
    // ???
  ) private {
    //
  }
}
