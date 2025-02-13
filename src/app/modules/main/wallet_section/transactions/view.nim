import NimQml, tables, stint, json, strformat, sequtils, strutils, sugar

import ./item
import ./model
import ./io_interface

import ../../../../../app_service/common/conversion as common_conversion
import ../../../../../app_service/service/wallet_account/dto

QtObject:
  type
    View* = ref object of QObject
      delegate: io_interface.AccessInterface
      models: Table[string, Model]
      model: Model
      modelVariant: QVariant
      fetchingHistoryState: Table[string, bool]
      isNonArchivalNode: bool

  proc delete*(self: View) =
    self.model.delete
    self.modelVariant.delete
    self.QObject.delete

  proc newView*(delegate: io_interface.AccessInterface): View =
    new(result, delete)
    result.QObject.setup
    result.delegate = delegate
    result.model = newModel()
    result.modelVariant = newQVariant(result.model)

  proc load*(self: View) =
    self.delegate.viewDidLoad()

  proc modelChanged*(self: View) {.signal.}

  proc getModel(self: View): QVariant {.slot.} =
    return self.modelVariant

  QtProperty[QVariant] model:
    read = getModel
    notify = modelChanged

  proc setItems*(self: View, items: seq[Item]) =
    self.model.setItems(items)

  proc historyWasFetched*(self: View) {.signal.}

  proc loadingTrxHistoryChanged*(self: View, isLoading: bool, address: string) {.signal.}

  proc setHistoryFetchState*(self: View, address: string, isFetching: bool) =
    self.fetchingHistoryState[address] = isFetching
    self.loadingTrxHistoryChanged(isFetching, address)

  proc setHistoryFetchState*(self: View, accounts: seq[string], isFetching: bool) =
    for acc in accounts:
      self.fetchingHistoryState[acc] = isFetching
      self.loadingTrxHistoryChanged(isFetching, acc)

  proc isFetchingHistory*(self: View, address: string): bool {.slot.} =
    if self.fetchingHistoryState.hasKey(address):
      return self.fetchingHistoryState[address]
    return true

  proc isHistoryFetched*(self: View, address: string): bool {.slot.} =
    return self.model.getCount() > 0

  proc loadTransactionsForAccount*(self: View, address: string, toBlock: string = "0x0", limit: int = 20, loadMore: bool = false) {.slot.} =
    self.setHistoryFetchState(address, true)
    self.delegate.loadTransactions(address, toBlock, limit, loadMore)

  proc setTrxHistoryResult*(self: View, transactions: seq[TransactionDto], address: string, wasFetchMore: bool) =
    if not self.models.hasKey(address):
      self.models[address] = newModel()

    self.models[address].addNewTransactions(transactions, wasFetchMore)

    self.setHistoryFetchState(address, false)

  proc setHistoryFetchStateForAccounts*(self: View, addresses: seq[string], isFetching: bool) =
    for address in addresses:
      self.setHistoryFetchState(address, isFetching)

  proc setModel*(self: View, address: string) {.slot.} =
    if not self.models.hasKey(address):
      self.models[address] = newModel()

    self.model = self.models[address]
    self.modelVariant = newQVariant(self.model)
    self.modelChanged()

  proc switchAccount*(self: View, walletAccount: WalletAccountDto) =
    self.setModel(walletAccount.address)

  proc getIsNonArchivalNode(self: View): QVariant {.slot.} =
    return newQVariant(self.isNonArchivalNode)

  proc isNonArchivalNodeChanged(self: View) {.signal.}

  proc setIsNonArchivalNode*(self: View, isNonArchivalNode: bool) =
    self.isNonArchivalNode = isNonArchivalNode
    self.isNonArchivalNodeChanged()

  QtProperty[QVariant] isNonArchivalNode:
    read = getIsNonArchivalNode
    notify = isNonArchivalNodeChanged

  proc estimateGas*(self: View, from_addr: string, to: string, assetSymbol: string, value: string, data: string): string {.slot.} =
    result = self.delegate.estimateGas(from_addr, to, assetSymbol, value, data)

  proc transactionSent*(self: View, txResult: string) {.signal.}

  proc transactionWasSent*(self: View,txResult: string) {.slot} =
    self.transactionSent(txResult)

  proc authenticateAndTransfer*(self: View, from_addr: string, to_addr: string, tokenSymbol: string,
    value: string, uuid: string, selectedRoutes: string) {.slot.} =
      self.delegate.authenticateAndTransfer(from_addr, to_addr, tokenSymbol, value, uuid, selectedRoutes)

  proc suggestedFees*(self: View, chainId: int): string {.slot.} =
    return self.delegate.suggestedFees(chainId)

  proc suggestedRoutes*(self: View, account: string, amount: string, token: string, disabledFromChainIDs: string, disabledToChainIDs: string, preferredChainIDs: string, sendType: int, lockedInAmounts: string): string {.slot.} =
    var parsedAmount = stint.u256("0")
    var seqPreferredChainIDs = seq[uint64] : @[]
    var seqDisabledFromChainIDs = seq[uint64] : @[]
    var seqDisabledToChainIDs = seq[uint64] : @[]

    try:
      for chainID in disabledFromChainIDs.split(','):
        seqDisabledFromChainIDs.add(parseUInt(chainID))
    except:
      discard

    try:
      for chainID in disabledToChainIDs.split(','):
        seqDisabledToChainIDs.add(parseUInt(chainID))
    except:
      discard

    try:
      for chainID in preferredChainIDs.split(','):
        seqPreferredChainIDs.add(parseUInt(chainID))
    except:
      discard

    try:
      parsedAmount = fromHex(Stuint[256], amount)
    except Exception as e:
      discard

    return self.delegate.suggestedRoutes(account, parsedAmount, token, seqDisabledFromChainIDs, seqDisabledToChainIDs, seqPreferredChainIDs, sendType, lockedInAmounts)
  
  proc getChainIdForChat*(self: View): int {.slot.} =
    return self.delegate.getChainIdForChat()

  proc getChainIdForBrowser*(self: View): int {.slot.} =
    return self.delegate.getChainIdForBrowser()

  proc getEstimatedTime*(self: View, chainId: int, maxFeePerGas: string): int {.slot.} =
    return self.delegate.getEstimatedTime(chainId, maxFeePerGas)

  proc getLastTxBlockNumber*(self: View): string {.slot.} =
    return self.delegate.getLastTxBlockNumber()

  proc suggestedRoutesReady*(self: View, suggestedRoutes: string) {.signal.}

  proc setPendingTx*(self: View, pendingTx: seq[TransactionDto]) =
    for tx in pendingTx:
      if not self.models.hasKey(tx.fromAddress):
        self.models[tx.fromAddress] = newModel()
      self.models[tx.fromAddress].addNewTransactions(@[tx], false)
