// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./Layers.sol";

contract UnsafeWallet {
  using Layers for Layers.Layer;


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

  uint numTransfers;
  mapping (uint => Transfer) Transfers;




  function addLayerToMakeTransfer(
    uint256 _amountMin,
    uint256 _amountMax
  ) private {
    Layer storage layer = LayersToMakeTransfer[numLayersToMakeTransfer];

    AmountMinMax memory amount = AmountMinMax({
      min: _amountMin,
      max: _amountMax
    });

    layer.amount = amount;

    // TODO: not hard coded
    string [2] memory _tokens = [ "ETH", "USDC" ];

    for (uint i = 0; i < _tokens.length; i++) {
      string memory token = _tokens[i];

      layer.tokens[i] = token;

      layer.numTokens++;
    }

    // enums etc
    for (uint i = 0; i < 4; i++) {
      Layers.Layer memory layerFlowLayer = layer.layerFlow[i];

      if (i == 2) {
        layerFlowLayer.isSeqSep = true;
      }

      layer.numLayerFlowLayers++;
    }

    numLayersToMakeTransfer++;
  }


  function makeTransfer(
    address _receiver,
    uint256 _amount
  ) private {
    // temp with the return transfer num, improve later
    addTransferLayers();
    uint256 transferNum = addTransfer(_receiver, _amount);

    // Check that numTransferLayers equals numTransfers
    // Queue transfers until this one is done with the 2 funcs above
    // Lock parts of the code

    // Change arch of this next version, just do execute transfer layers now

    executeTransferLayers(transferNum);
  }

  function addTransferLayers() private {
    for (uint layerNum = 0; layerNum < numLayersToMakeTransfer; layerNum++) {
      Layer storage _layer = LayersToMakeTransfer[layerNum];

      Layer storage layer = TransferLayers[numTransfers][layerNum];

      AmountMinMax memory amount = AmountMinMax({
        min: _layer.amount.min,
        max: _layer.amount.max
      });

      layer.amount = amount;

      layer.numTokens = _layer.numTokens;

      for (uint tokenNum = 0; tokenNum < _layer.numTokens; tokenNum++) {
        string memory token = _layer.tokens[tokenNum];

        layer.tokens[tokenNum] = token;
      }

      uint numLayerFlowLayers = _layer.numLayerFlowLayers;

      for (uint layerFlowLayerNum = 0; layerFlowLayerNum < numLayerFlowLayers; layerFlowLayerNum++) {
        Layers.Layer memory layerFlowLayer = _layer.layerFlow[layerFlowLayerNum];

        layer.layerFlow[layerFlowLayerNum] = layerFlowLayer;

        layer.numLayerFlowLayers++;
      }
      
      numTransferLayers++;
    }
  }

  function addTransfer(
    address _receiver,
    uint256 _amount
  ) private returns (uint256 transferNum) {
    Transfer storage transfer = Transfers[numTransfers];

    transfer.transferNum = numTransfers;

    transfer.receiver = _receiver;
    transfer.amount = _amount;

    transfer.transferLayersIndex = numTransfers;

    transfer.executed = false;

    numTransfers++;

    return transfer.transferNum;
  }

  // [ EXEC Layers.Layer , EXEC Layers.Layer, EXEC Layers.Layer, DONT EXEC Layers.Layer isSeqSep , EXEC Layers.Layer ]
  function executeTransferLayers(uint256 _transferNum) private {
    executeTransferLayersForSeqNum(_transferNum, 0)
  }

  // Call this to execute each seq num... 0, 1, 2, etc
  function executeTransferLayersForSeqNum(
    uint256 _transferNum,
    uint256 _seqNum
  ) private {
  }




  function test(address _receiver) public virtual {
    // Init some layers to make transfer.
    addLayerToMakeTransfer(0, 100);
    addLayerToMakeTransfer(100, 150);
    addLayerToMakeTransfer(150, 200);

    // Make transfer.
    uint256 amount = 1000;
    makeTransfer(_receiver, amount);

    /*

    emit TestLogNumLayersToMakeTransfer(uint _num);
    emit TestLogNumTransfers(uint _num);

    for (uint i = 0; i < numTransfers; i++) {
      emit TestLogNumLayerFlowLayers(uint _num);
    }

    */
  }
}
