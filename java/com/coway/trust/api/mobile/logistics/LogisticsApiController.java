package com.coway.trust.api.mobile.logistics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.logistics.alternativefilter.AlternativeFilterDListDto;
import com.coway.trust.api.mobile.logistics.alternativefilter.AlternativeFilterDListForm;
import com.coway.trust.api.mobile.logistics.alternativefilter.AlternativeFilterMListDto;
import com.coway.trust.api.mobile.logistics.alternativefilter.AlternativeFilterMListForm;
import com.coway.trust.api.mobile.logistics.audit.BarcodeCListDto;
import com.coway.trust.api.mobile.logistics.audit.BarcodeDListDto;
import com.coway.trust.api.mobile.logistics.audit.BarcodeListForm;
import com.coway.trust.api.mobile.logistics.audit.InputBarcodePartsForm;
import com.coway.trust.api.mobile.logistics.audit.InputNonBarcodeForm;
import com.coway.trust.api.mobile.logistics.audit.NonBarcodeDListDto;
import com.coway.trust.api.mobile.logistics.audit.NonBarcodeListForm;
import com.coway.trust.api.mobile.logistics.audit.StockAuditResultDetailDto;
import com.coway.trust.api.mobile.logistics.audit.StockAuditResultDetailForm;
import com.coway.trust.api.mobile.logistics.audit.StockAuditResultDto;
import com.coway.trust.api.mobile.logistics.audit.StockAuditResultForm;
import com.coway.trust.api.mobile.logistics.ctcodylist.DisplayCt_CodyListDto;
import com.coway.trust.api.mobile.logistics.ctcodylist.DisplayCt_CodyListForm;
import com.coway.trust.api.mobile.logistics.filterinventorydisplay.FilterChangeDListDto;
import com.coway.trust.api.mobile.logistics.filterinventorydisplay.FilterChangeListForm;
import com.coway.trust.api.mobile.logistics.filterinventorydisplay.FilterNotChangeDListDto;
import com.coway.trust.api.mobile.logistics.filterinventorydisplay.FilterNotChangeListForm;
import com.coway.trust.api.mobile.logistics.filterinventorydisplay.UserFilterDListDto;
import com.coway.trust.api.mobile.logistics.filterinventorydisplay.UserFilterListForm;
import com.coway.trust.api.mobile.logistics.hiCare.HiCareInventoryDto;
import com.coway.trust.api.mobile.logistics.hiCare.HiCareInventoryForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryAllListDto;
import com.coway.trust.api.mobile.logistics.inventory.InventoryAllListForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryCodyOnHandStockDto;
import com.coway.trust.api.mobile.logistics.inventory.InventoryCodyOnHandStockForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryOnHandStockDto;
import com.coway.trust.api.mobile.logistics.inventory.InventoryOnHandStockForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryOnHandStockSerialDto;
import com.coway.trust.api.mobile.logistics.inventory.InventoryOnHandStockSerialForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryOverallStockDto;
import com.coway.trust.api.mobile.logistics.inventory.InventoryOverallStockForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryReqTransferMForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryStockByHolderDto;
import com.coway.trust.api.mobile.logistics.inventory.InventoryStockByHolderForm;
import com.coway.trust.api.mobile.logistics.itembank.ItemBankItemListDto;
import com.coway.trust.api.mobile.logistics.itembank.ItemBankItemListForm;
import com.coway.trust.api.mobile.logistics.itembank.ItemBankLocationListDto;
import com.coway.trust.api.mobile.logistics.itembank.ItemBankLocationListForm;
import com.coway.trust.api.mobile.logistics.itembank.ItemBankResultListDto;
import com.coway.trust.api.mobile.logistics.itembank.ItemBankResultListForm;
import com.coway.trust.api.mobile.logistics.miscPart.MiscPartDto;
import com.coway.trust.api.mobile.logistics.miscPart.MiscPartListForm;
import com.coway.trust.api.mobile.logistics.mystock.MyStockListDto;
import com.coway.trust.api.mobile.logistics.mystock.MyStockListForm;
import com.coway.trust.api.mobile.logistics.rdcstock.RdcStockListDto;
import com.coway.trust.api.mobile.logistics.rdcstock.RdcStockListForm;
import com.coway.trust.api.mobile.logistics.recevie.ConfirmReceiveMForm;
import com.coway.trust.api.mobile.logistics.recevie.LogStockPartsReceiveDto;
import com.coway.trust.api.mobile.logistics.recevie.LogStockReceiveDto;
import com.coway.trust.api.mobile.logistics.recevie.LogStockReceiveForm;
import com.coway.trust.api.mobile.logistics.requestresult.RequestResultDListDto;
import com.coway.trust.api.mobile.logistics.requestresult.RequestResultListForm;
import com.coway.trust.api.mobile.logistics.requestresult.RequestResultMListDto;
import com.coway.trust.api.mobile.logistics.requestresult.RequestResultRejectForm;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnOnHandStockDListDto;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnOnHandStockListForm;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnOnHandStockMListDto;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnOnHandStockReqMForm;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnPartsSearchDto;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnPartsSearchForm;
import com.coway.trust.api.mobile.logistics.salesprice.StockPriceDto;
import com.coway.trust.api.mobile.logistics.salesprice.StockPriceForm;
import com.coway.trust.api.mobile.logistics.stockbyholder.StockByHolderListDto;
import com.coway.trust.api.mobile.logistics.stockbyholder.StockByHolderListForm;
import com.coway.trust.api.mobile.logistics.stockbyholder.StockByHolderQtyDto;
import com.coway.trust.api.mobile.logistics.stockbyholder.StockByHolderQtyForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferConfirmGiDForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferConfirmGiMForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferRejectSMOReqForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferReqStatusDListDto;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferReqStatusListForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferReqStatusMListDto;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferSMOCntRespForm;
import com.coway.trust.api.mobile.logistics.usedparts.UsedPartsDto;
import com.coway.trust.api.mobile.logistics.usedparts.UsedPartsListForm;
import com.coway.trust.biz.logistics.mlog.MlogApiService;
import com.coway.trust.biz.logistics.mlog.vo.AdjustmentStockBarcodeListVo;
import com.coway.trust.biz.logistics.mlog.vo.AdjustmentStockNoneBarcodeListVo;
import com.coway.trust.biz.logistics.mlog.vo.FilterChangeListVo;
import com.coway.trust.biz.logistics.mlog.vo.FilterNotChangeListVo;
import com.coway.trust.biz.logistics.mlog.vo.UserFilterListVo;
import com.coway.trust.cmmn.exception.PreconditionException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "logistics api", description = "logistics api")
@RestController(value = "logisticsApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/logistics")
public class LogisticsApiController {
  private static final Logger LOGGER = LoggerFactory.getLogger(LogisticsApiController.class);

  @Resource(name = "MlogApiService")
  private MlogApiService MlogApiService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @ApiOperation(value = "RDC Stock List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/rdcStockList", method = RequestMethod.GET)
  public ResponseEntity<List<RdcStockListDto>> getRDCStockList(@ModelAttribute RdcStockListForm RdcStockListForm) throws Exception {

    Map<String, Object> params = RdcStockListForm.createMap(RdcStockListForm);

    List<EgovMap> RDCStockList = MlogApiService.getRDCStockList(params);

    for (int i = 0; i < RDCStockList.size(); i++) {
      LOGGER.debug("RDCStockList    값 : {}", RDCStockList.get(i));

    }

    List<RdcStockListDto> list = RDCStockList.stream().map(r -> RdcStockListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Stock by Holder List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/stockbyHolderList", method = RequestMethod.GET)
  public ResponseEntity<List<StockByHolderListDto>> getStockbyHolderList(@ModelAttribute StockByHolderListForm StockByHolderListForm) throws Exception {

    Map<String, Object> params = StockByHolderListForm.createMap(StockByHolderListForm);

    List<EgovMap> StockbyHolderList = MlogApiService.getStockbyHolderList(params);

    for (int i = 0; i < StockbyHolderList.size(); i++) {
      LOGGER.debug("StockbyHolderList    값 : {}", StockbyHolderList.get(i));

    }
    List<StockByHolderListDto> list = StockbyHolderList.stream().map(r -> StockByHolderListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Common StockList Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/stockCommonQty", method = RequestMethod.GET)
  public ResponseEntity<List<StockByHolderQtyDto>> getStockbyHolderQty(@ModelAttribute StockByHolderQtyForm StockByHolderQtyForm) throws Exception {

    Map<String, Object> params = StockByHolderQtyForm.createMap(StockByHolderQtyForm);

    List<EgovMap> StockbyHolderQty = MlogApiService.getCommonQty(params);

    for (int i = 0; i < StockbyHolderQty.size(); i++) {
      LOGGER.debug("StockbyHolderQty    값 : {}", StockbyHolderQty.get(i));

    }
    List<StockByHolderQtyDto> list = StockbyHolderQty.stream().map(r -> StockByHolderQtyDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "DisplayCt_CodyList Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/displayCt_CodyList", method = RequestMethod.GET)
  public ResponseEntity<List<DisplayCt_CodyListDto>> getCTStockList(@ModelAttribute DisplayCt_CodyListForm DisplayCt_CodyListForm) throws Exception {

    Map<String, Object> params = DisplayCt_CodyListForm.createMap(DisplayCt_CodyListForm);

    List<EgovMap> CTStockList = MlogApiService.getCt_CodyList(params);

    for (int i = 0; i < CTStockList.size(); i++) {
      LOGGER.debug("CTStockList    값 : {}", CTStockList.get(i));

    }
    List<DisplayCt_CodyListDto> list = CTStockList.stream().map(r -> DisplayCt_CodyListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Inventory Status Display - Overall Stock Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/inventoryOverallStock", method = RequestMethod.GET)
  public ResponseEntity<List<InventoryOverallStockDto>> getInventoryOverallStock(@ModelAttribute InventoryOverallStockForm InventoryOverallStockForm) throws Exception {

    Map<String, Object> params = InventoryOverallStockForm.createMap(InventoryOverallStockForm);

    List<EgovMap> inventoryOverallStock = MlogApiService.getInventoryOverallStock(params);

    for (int i = 0; i < inventoryOverallStock.size(); i++) {
      LOGGER.debug("inventoryOverallStock    값 : {}", inventoryOverallStock.get(i));
    }

    List<InventoryOverallStockDto> list = inventoryOverallStock.stream().map(r -> InventoryOverallStockDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Inventory Status Display - All List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/inventoryAllList", method = RequestMethod.GET)
  public ResponseEntity<List<InventoryAllListDto>> getAllStockList(@ModelAttribute InventoryAllListForm InventoryAllListForm) throws Exception {

    Map<String, Object> params = InventoryAllListForm.createMap(InventoryAllListForm);

    List<EgovMap> MyStockList = MlogApiService.getAllStockList(params);

    for (int i = 0; i < MyStockList.size(); i++) {
      LOGGER.debug("MyStockList    값 : {}", MyStockList.get(i));

    }

    List<InventoryAllListDto> list = MyStockList.stream().map(r -> InventoryAllListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Inventory Status Display - Stock by Holder Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/inventoryStockByHolder", method = RequestMethod.GET)
  public ResponseEntity<List<InventoryStockByHolderDto>> getInventoryStockByHolder(@ModelAttribute InventoryStockByHolderForm InventoryStockByHolderForm) throws Exception {

    Map<String, Object> params = InventoryStockByHolderForm.createMap(InventoryStockByHolderForm);

    List<EgovMap> StockHolder = MlogApiService.getInventoryStockByHolder(params);

    for (int i = 0; i < StockHolder.size(); i++) {
      LOGGER.debug("StockHolder 값 : {}", StockHolder.get(i));

    }

    List<InventoryStockByHolderDto> list = StockHolder.stream().map(r -> InventoryStockByHolderDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  /*
   * @ApiOperation(value = "StockReceive Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
   * @RequestMapping(value = "/stockReceiveList", method = RequestMethod.GET)
   * public ResponseEntity<List<LogStockReceiveDto>> stockReceiveList(
   * @ModelAttribute LogStockReceiveForm LogStockReceiveForm) throws Exception {
   * Map<String, Object> params = LogStockReceiveForm.createMap(LogStockReceiveForm);
   * List<EgovMap> headerList = MlogApiService.StockReceiveList(params);
   * List<LogStockReceiveDto> hList = new ArrayList<>();
   * for (int i = 0; i < headerList.size(); i++) {
   * LOGGER.debug("headerList 값 : {}", headerList.get(i));
   * }
   * for (int i = 0; i < headerList.size(); i++) {
   * hList = headerList.stream().map(r -> LogStockReceiveDto.create(r)).collect(Collectors.toList());
   * for (int j = 0; j < hList.size(); j++) {
   * Map<String, Object> tmpMap = headerList.get(j);
   * List<EgovMap> serialList = MlogApiService.selectStockReceiveSerial(tmpMap);
   * List<LogStockPartsReceiveDto> partsList = serialList.stream()
   * .map(r -> LogStockPartsReceiveDto.create(r)).collect(Collectors.toList());
   * hList.get(j).setPartsList(partsList);
   * }
   * }
   * return ResponseEntity.ok(hList);
   * }
   */

  @ApiOperation(value = "StockReceive Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/stockReceiveList", method = RequestMethod.GET)
  public ResponseEntity<List<LogStockReceiveDto>> stockReceiveList(@ModelAttribute LogStockReceiveForm LogStockReceiveForm) throws Exception {

    Map<String, Object> params = LogStockReceiveForm.createMap(LogStockReceiveForm);

    List<EgovMap> headerList = MlogApiService.StockReceiveList(params);

    List<LogStockReceiveDto> hList = new ArrayList<>();
    for (int i = 0; i < headerList.size(); i++) {
      LOGGER.debug("headerList 값 : {}", headerList.get(i));
    }

    hList = headerList.stream().map(r -> LogStockReceiveDto.create(r)).collect(Collectors.toList());

    for (int i = 0; i < headerList.size(); i++) {

      // for (int j = 0; j < hList.size(); j++) {
      Map<String, Object> tmpMap = headerList.get(i);
      List<EgovMap> serialList = MlogApiService.selectStockReceiveSerial(tmpMap);

      List<LogStockPartsReceiveDto> partsList = serialList.stream().map(r -> LogStockPartsReceiveDto.create(r)).collect(Collectors.toList());
      hList.get(i).setPartsList(partsList);
      // }

    }

    return ResponseEntity.ok(hList);

  }

  /**
   * On-Hand Stock Receive Display > Search(SERIAL_REQUIRE_CHK_YN= 'Y' location)
   *
   * @Author KR-MIN
   * @Date 2019. 12. 16.
   * @param LogStockReceiveForm
   * @return
   * @throws Exception
   */
  @ApiOperation(value = "StockReceive Search-Scan", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/stockReceiveListScan", method = RequestMethod.GET)
  public ResponseEntity<List<LogStockReceiveDto>> stockReceiveListScan(@ModelAttribute LogStockReceiveForm LogStockReceiveForm) throws Exception {

    Map<String, Object> params = LogStockReceiveForm.createMap(LogStockReceiveForm);

    List<EgovMap> headerList = MlogApiService.StockReceiveList(params);

    List<LogStockReceiveDto> hList = new ArrayList<>();
    for (int i = 0; i < headerList.size(); i++) {
      LOGGER.debug("headerList 값 : {}", headerList.get(i));
    }

    hList = headerList.stream().map(r -> LogStockReceiveDto.create(r)).collect(Collectors.toList());

    for (int i = 0; i < headerList.size(); i++) {

      // for (int j = 0; j < hList.size(); j++) {
      Map<String, Object> tmpMap = headerList.get(i);
      List<EgovMap> serialList = MlogApiService.selectStockReceiveSerialScan(tmpMap);

      List<LogStockPartsReceiveDto> partsList = serialList.stream().map(r -> LogStockPartsReceiveDto.create(r)).collect(Collectors.toList());
      hList.get(i).setPartsList(partsList);
      // }

    }

    return ResponseEntity.ok(hList);

  }

  @ApiOperation(value = "My Stock List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/myStockList", method = RequestMethod.GET)
  public ResponseEntity<List<MyStockListDto>> getMyStockList(@ModelAttribute MyStockListForm MyStockListForm) throws Exception {

    Map<String, Object> params = MyStockListForm.createMap(MyStockListForm);

    List<EgovMap> MyStockList;
    MyStockList = MlogApiService.getMyStockList(params);

    for (int i = 0; i < MyStockList.size(); i++) {
      LOGGER.debug("MyStockList    값 : {}", MyStockList.get(i));

    }

    List<MyStockListDto> list = MyStockList.stream().map(r -> MyStockListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Return On-Hand Stock - Parts Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/returnPartsSearch", method = RequestMethod.GET)
  public ResponseEntity<List<ReturnPartsSearchDto>> getReturnPartsSearch(@ModelAttribute ReturnPartsSearchForm ReturnPartsSearchForm) throws Exception {

    Map<String, Object> params = ReturnPartsSearchForm.createMap(ReturnPartsSearchForm);

    List<EgovMap> ReturnPartsSearchList = MlogApiService.getReturnPartsSearch(params);

    for (int i = 0; i < ReturnPartsSearchList.size(); i++) {
      LOGGER.debug("ReturnPartsSearchList    값 : {}", ReturnPartsSearchList.get(i));

    }

    List<ReturnPartsSearchDto> list = ReturnPartsSearchList.stream().map(r -> ReturnPartsSearchDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  /**
   * Return On-Hand Stock > Item Search(SERIAL_REQUIRE_CHK_YN= 'Y' location)
   *
   * @Author KR-MIN
   * @Date 2019. 12. 16.
   * @param ReturnPartsSearchForm
   * @return
   * @throws Exception
   */
  @ApiOperation(value = "Return On-Hand Stock - Parts Search-Scan", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/returnPartsSearchScan", method = RequestMethod.GET)
  public ResponseEntity<List<ReturnPartsSearchDto>> getReturnPartsSearchScan(@ModelAttribute ReturnPartsSearchForm ReturnPartsSearchForm) throws Exception {

    Map<String, Object> params = ReturnPartsSearchForm.createMap(ReturnPartsSearchForm);

    List<EgovMap> ReturnPartsSearchList = MlogApiService.getReturnPartsSearchScan(params);

    for (int i = 0; i < ReturnPartsSearchList.size(); i++) {
      LOGGER.debug("ReturnPartsSearchList    값 : {}", ReturnPartsSearchList.get(i));

    }

    List<ReturnPartsSearchDto> list = ReturnPartsSearchList.stream().map(r -> ReturnPartsSearchDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Alternative Filter Master List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/alternativeFilterMList", method = RequestMethod.GET)
  public ResponseEntity<List<AlternativeFilterMListDto>> getAlternativeFilterMList(@ModelAttribute AlternativeFilterMListForm AlternativeFilterMListForm) throws Exception {

    Map<String, Object> params = AlternativeFilterMListForm.createMap(AlternativeFilterMListForm);

    List<EgovMap> alternativeFilterMList = MlogApiService.getAlternativeFilterMList();

    for (int i = 0; i < alternativeFilterMList.size(); i++) {
      LOGGER.debug("alternativeFilterMList    값 : {}", alternativeFilterMList.get(i));

    }

    List<AlternativeFilterMListDto> list = alternativeFilterMList.stream().map(r -> AlternativeFilterMListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Alternative Filter Detail List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/alternativeFilterDList", method = RequestMethod.GET)
  public ResponseEntity<List<AlternativeFilterDListDto>> getAlternativeFilterDList(@ModelAttribute AlternativeFilterDListForm AlternativeFilterDListForm) throws Exception {

    Map<String, Object> params = AlternativeFilterDListForm.createMap(AlternativeFilterDListForm);

    List<EgovMap> alternativeFilterDList = MlogApiService.getAlternativeFilterDList();

    for (int i = 0; i < alternativeFilterDList.size(); i++) {
      LOGGER.debug("alternativeFilterDList    값 : {}", alternativeFilterDList.get(i));

    }

    List<AlternativeFilterDListDto> list = alternativeFilterDList.stream().map(r -> AlternativeFilterDListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Item Bank & Cody Item - Location List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/itemBankLocationList", method = RequestMethod.GET)
  public ResponseEntity<List<ItemBankLocationListDto>> getItemBankLocationList(@ModelAttribute ItemBankLocationListForm ItemBankLocationListForm) throws Exception {

    Map<String, Object> params = ItemBankLocationListForm.createMap(ItemBankLocationListForm);

    List<EgovMap> itemBankLocationList = MlogApiService.getItemBankLocationList(params);

    for (int i = 0; i < itemBankLocationList.size(); i++) {
      LOGGER.debug("itemBankLocationList    값 : {}", itemBankLocationList.get(i));

    }

    List<ItemBankLocationListDto> list = itemBankLocationList.stream().map(r -> ItemBankLocationListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Item Bank & Cody Item - Item List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/itemBankItemList", method = RequestMethod.GET)
  public ResponseEntity<List<ItemBankItemListDto>> getItemBankItemList(@ModelAttribute ItemBankItemListForm ItemBankItemListForm) throws Exception {

    Map<String, Object> params = ItemBankItemListForm.createMap(ItemBankItemListForm);

    List<EgovMap> itemBankItemList = MlogApiService.getItemBankItemList();

    for (int i = 0; i < itemBankItemList.size(); i++) {
      LOGGER.debug("itemBankItemList    값 : {}", itemBankItemList.get(i));

    }

    List<ItemBankItemListDto> list = itemBankItemList.stream().map(r -> ItemBankItemListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Item Bank & Cody Item - Result List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/itemBankResultList", method = RequestMethod.GET)
  public ResponseEntity<List<ItemBankResultListDto>> getItemBankResultList(@ModelAttribute ItemBankResultListForm itemBankResultListForm) throws Exception {

    Map<String, Object> params = ItemBankResultListForm.createMap(itemBankResultListForm);

    List<EgovMap> itemBankResultList = MlogApiService.getItemBankResultList(params);

    for (int i = 0; i < itemBankResultList.size(); i++) {
      LOGGER.debug("itemBankResultList    값 : {}", itemBankResultList.get(i));
    }

    List<ItemBankResultListDto> list = itemBankResultList.stream().map(r -> ItemBankResultListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Request Result - List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/requestResultList", method = RequestMethod.GET)
  public ResponseEntity<List<RequestResultMListDto>> getRequestResultList(@ModelAttribute RequestResultListForm RequestResultListForm) throws Exception {

    Map<String, Object> params = RequestResultListForm.createMap(RequestResultListForm);

    List<EgovMap> headerList = MlogApiService.getCommonReqHeader(params);

    List<RequestResultMListDto> hList = new ArrayList<>();
    for (int i = 0; i < headerList.size(); i++) {
      LOGGER.debug("headerList 값 : {}", headerList.get(i));
    }

    hList = headerList.stream().map(r -> RequestResultMListDto.create(r)).collect(Collectors.toList());

    for (int i = 0; i < headerList.size(); i++) {

      // for (int j = 0; j < hList.size(); j++) {
      Map<String, Object> tmpMap = headerList.get(i);
      List<EgovMap> reqParts = MlogApiService.getCommonReqParts(tmpMap);

      List<RequestResultDListDto> partsList = reqParts.stream().map(r -> RequestResultDListDto.create(r)).collect(Collectors.toList());
      // RequestResultMListDto odto = (RequestResultMListDto) hList.get(i);

      hList.get(i).setPartsList(partsList);
      // odto.setPartsList(partsList);
      // hList.set(i, odto) ;
      // }

    }

    return ResponseEntity.ok(hList);

  }

  /*
   * @ApiOperation(value = "Return On-Hand Stock - List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
   * @RequestMapping(value = "/returnOnHandStockList", method = RequestMethod.GET)
   * public ResponseEntity<List<ReturnOnHandStockMListDto>> getreturnOnHandStockList(
   * @ModelAttribute ReturnOnHandStockListForm ReturnOnHandStockListForm) throws Exception {
   * Map<String, Object> params = ReturnOnHandStockListForm.createMap(ReturnOnHandStockListForm);
   * List<EgovMap> headerList = MlogApiService.getCommonReqHeader(params);
   * List<ReturnOnHandStockMListDto> hList = new ArrayList<>();
   * for (int i = 0; i < headerList.size(); i++) {
   * LOGGER.debug("headerList 값 : {}", headerList.get(i));
   * }
   * for (int i = 0; i < headerList.size(); i++) {
   * hList = headerList.stream().map(r -> ReturnOnHandStockMListDto.create(r)).collect(Collectors.toList());
   * for (int j = 0; j < hList.size(); j++) {
   * Map<String, Object> tmpMap = headerList.get(j);
   * List<EgovMap> reqParts = MlogApiService.getCommonReqParts(tmpMap);
   * List<ReturnOnHandStockDListDto> partsList = reqParts.stream()
   * .map(r -> ReturnOnHandStockDListDto.create(r)).collect(Collectors.toList());
   * hList.get(j).setPartsList(partsList);
   * }
   * }
   * return ResponseEntity.ok(hList);
   * }
   */

  @ApiOperation(value = "Return On-Hand Stock - List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/returnOnHandStockList", method = RequestMethod.GET)
  public ResponseEntity<List<ReturnOnHandStockMListDto>> getreturnOnHandStockList(@ModelAttribute ReturnOnHandStockListForm ReturnOnHandStockListForm) throws Exception {

    Map<String, Object> params = ReturnOnHandStockListForm.createMap(ReturnOnHandStockListForm);

    List<EgovMap> headerList = MlogApiService.getCommonReqHeader(params);

    List<ReturnOnHandStockMListDto> hList = new ArrayList<>();
    for (int i = 0; i < headerList.size(); i++) {
      LOGGER.debug("headerList 값 : {}", headerList.get(i));
    }

    hList = headerList.stream().map(r -> ReturnOnHandStockMListDto.create(r)).collect(Collectors.toList());

    for (int i = 0; i < headerList.size(); i++) {

      // for (int j = 0; j < hList.size(); j++) {
      Map<String, Object> tmpMap = headerList.get(i);
      List<EgovMap> reqParts;
      // 20191216 KR-MIN serialRequireChkYn = Y : Select LOG0100M, N: LOG0061D,LOG0063D
      if ("Y".equals(tmpMap.get("serialRequireChkYn"))) {
        reqParts = MlogApiService.getCommonReqPartsScan(tmpMap);
      } else {
        reqParts = MlogApiService.getCommonReqParts(tmpMap);
      }

      List<ReturnOnHandStockDListDto> partsList = reqParts.stream().map(r -> ReturnOnHandStockDListDto.create(r)).collect(Collectors.toList());
      hList.get(i).setPartsList(partsList);
      // }

    }
    return ResponseEntity.ok(hList);
  }

  @ApiOperation(value = "Audit Stock - Result Detail Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/auditStockResultDetail", method = RequestMethod.GET)
  public ResponseEntity<List<StockAuditResultDetailDto>> getAuditStockResultDetail(@ModelAttribute StockAuditResultDetailForm StockAuditResultDetailForm) throws Exception {

    Map<String, Object> params = StockAuditResultDetailForm.createMap(StockAuditResultDetailForm);

    List<EgovMap> auditStockResultDetail = MlogApiService.getAuditStockResultDetail(params);

    for (int i = 0; i < auditStockResultDetail.size(); i++) {
      LOGGER.debug("itemBankLocationList    값 : {}", auditStockResultDetail.get(i));

    }

    List<StockAuditResultDetailDto> list = auditStockResultDetail.stream().map(r -> StockAuditResultDetailDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  /*
   * @ApiOperation(value = "Stock Transfer - Request Status List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
   * @RequestMapping(value = "/StockTransferReqStatusList", method = RequestMethod.GET)
   * public ResponseEntity<List<StockTransferReqStatusMListDto>> getStockTransferReqStatusList(
   * @ModelAttribute StockTransferReqStatusListForm StockTransferReqStatusListForm) throws Exception {
   * Map<String, Object> params = StockTransferReqStatusListForm.createMap(StockTransferReqStatusListForm);
   * List<EgovMap> headerList = MlogApiService.getStockTransferReqStatusMList(params);
   * List<StockTransferReqStatusMListDto> hList = new ArrayList<>();
   * for (int i = 0; i < headerList.size(); i++) {
   * LOGGER.debug("Request Status headerList1111 값 : {}", headerList.get(i));
   * }
   * for (int i = 0; i < headerList.size(); i++) {
   * hList = headerList.stream().map(r -> StockTransferReqStatusMListDto.create(r)).collect(Collectors.toList());
   * for (int j = 0; j < hList.size(); j++) {
   * Map<String, Object> tmpMap = headerList.get(j);
   * tmpMap.put("searchStatus", params.get("searchStatus"));
   * List<EgovMap> reqParts = MlogApiService.getStockTransferReqStatusDList(tmpMap);
   * List<StockTransferReqStatusDListDto> partsList = reqParts.stream()
   * .map(r -> StockTransferReqStatusDListDto.create(r)).collect(Collectors.toList());
   * hList.get(j).setPartsList(partsList);
   * }
   * }
   * return ResponseEntity.ok(hList);
   * }
   */

  @ApiOperation(value = "Stock Transfer - Request Status List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/StockTransferReqStatusList", method = RequestMethod.GET)
  public ResponseEntity<List<StockTransferReqStatusMListDto>> getStockTransferReqStatusList(@ModelAttribute StockTransferReqStatusListForm StockTransferReqStatusListForm) throws Exception {

    Map<String, Object> params = StockTransferReqStatusListForm.createMap(StockTransferReqStatusListForm);

    List<EgovMap> headerList = MlogApiService.getStockTransferReqStatusMList(params);

    List<StockTransferReqStatusMListDto> hList = new ArrayList<>();
    for (int i = 0; i < headerList.size(); i++) {
      LOGGER.debug("Request Status headerList1111 값 : {}", headerList.get(i));
    }

    hList = headerList.stream().map(r -> StockTransferReqStatusMListDto.create(r)).collect(Collectors.toList());

    for (int i = 0; i < headerList.size(); i++) {

      // for (int j = 0; j < hList.size(); j++) {
      Map<String, Object> tmpMap = headerList.get(i);
      tmpMap.put("searchStatus", params.get("searchStatus"));
      List<EgovMap> reqParts = MlogApiService.getStockTransferReqStatusDList(tmpMap);

      List<StockTransferReqStatusDListDto> partsList = reqParts.stream().map(r -> StockTransferReqStatusDListDto.create(r)).collect(Collectors.toList());
      hList.get(i).setPartsList(partsList);
      // }

    }
    return ResponseEntity.ok(hList);
  }

  @ApiOperation(value = "Adjustment Stock - None-Barcode List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/noneBarcodeList", method = RequestMethod.GET)
  public ResponseEntity<AdjustmentStockNoneBarcodeListVo> getNonBarcodeList(@ModelAttribute NonBarcodeListForm nonbarcodeListForm) throws Exception {

    Map<String, Object> params = NonBarcodeListForm.createMap(nonbarcodeListForm);
    String invenAdjustLocId = "";

    AdjustmentStockNoneBarcodeListVo dto = null;

    List<EgovMap> header = MlogApiService.getNonBarcodeM(params);

    if (header.size() > 0) {
      dto = new AdjustmentStockNoneBarcodeListVo();

      for (int i = 0; i < header.size(); i++) {
        Map<String, Object> headerMap = header.get(i);
        dto.setInvenAdjustNo((String) headerMap.get("invenAdjustNo"));
        dto.setAdjustStatus((String) headerMap.get("adjustStatus"));
        dto.setAdjustCreateDate((String) headerMap.get("adjustCreateDate"));
        dto.setAdjustBaseDate((String) headerMap.get("adjustBaseDate"));
        dto.setAdjustLocation((String) headerMap.get("adjustLocation"));
        dto.setAdjustNormalQty(CommonUtils.getInt(headerMap.get("adjustNormalQty")));
        dto.setAdjustNotQty(CommonUtils.getInt(headerMap.get("diffQty")));
        dto.setAdjustQty(CommonUtils.getInt(headerMap.get("adjustQty")));

        invenAdjustLocId = (String) headerMap.get("invenAdjustLocId");

      }

      LOGGER.debug("invenAdjustLocId 값 : {}", invenAdjustLocId);

      List<EgovMap> nonBarcodeDList = MlogApiService.getNonBarcodeDList(invenAdjustLocId);

      List<NonBarcodeDListDto> adjustList = nonBarcodeDList.stream().map(r -> NonBarcodeDListDto.create(r)).collect(Collectors.toList());
      dto.setAdjustList(adjustList);

      for (int i = 0; i < adjustList.size(); i++) {
        LOGGER.debug("adjustList 값 : {}", adjustList.get(i));
      }

    }
    return ResponseEntity.ok(dto);

  }

  @ApiOperation(value = "Adjustment Stock - Barcode List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/barcodeListForm", method = RequestMethod.GET)
  public ResponseEntity<AdjustmentStockBarcodeListVo> getBarcodeList(@ModelAttribute BarcodeListForm barcodeListForm) throws Exception {

    Map<String, Object> params = BarcodeListForm.createMap(barcodeListForm);
    String invenAdjustLocId = "";

    AdjustmentStockBarcodeListVo dto = null;

    List<EgovMap> header = MlogApiService.getNonBarcodeM(params);
    if (header.size() > 0) {
      dto = new AdjustmentStockBarcodeListVo();

      for (int i = 0; i < header.size(); i++) {
        Map<String, Object> headerMap = header.get(i);
        dto.setInvenAdjustNo((String) headerMap.get("invenAdjustNo"));
        dto.setAdjustStatus((String) headerMap.get("adjustStatus"));
        dto.setAdjustCreateDate((String) headerMap.get("adjustCreateDate"));
        dto.setAdjustBaseDate((String) headerMap.get("adjustBaseDate"));
        dto.setAdjustLocation((String) headerMap.get("adjustLocation"));
        dto.setAdjustNormalQty(CommonUtils.getInt(headerMap.get("adjustNormalQty")));
        dto.setAdjustNotQty(CommonUtils.getInt(headerMap.get("diffQty")));
        dto.setAdjustQty(CommonUtils.getInt(headerMap.get("adjustQty")));

        invenAdjustLocId = (String) headerMap.get("invenAdjustLocId");
      }

      LOGGER.debug("invenAdjustLocId 값 : {}", invenAdjustLocId);

      List<EgovMap> barcodeDList = MlogApiService.getBarcodeDList(invenAdjustLocId);

      List<EgovMap> barcodeCList = MlogApiService.getBarcodeCList(invenAdjustLocId);

      List<BarcodeDListDto> adjustList = barcodeDList.stream().map(r -> BarcodeDListDto.create(r)).collect(Collectors.toList());

      List<BarcodeCListDto> completeList = barcodeCList.stream().map(r -> BarcodeCListDto.create(r)).collect(Collectors.toList());

      dto.setAdjustList(adjustList);
      dto.setCompleteList(completeList);

      for (int i = 0; i < adjustList.size(); i++) {
        LOGGER.debug("adjustList 값 : {}", adjustList.get(i));
      }

    }

    return ResponseEntity.ok(dto);

  }

  @ApiOperation(value = "Display of Used Parts & Filter Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/usedParts", method = RequestMethod.GET)
  public ResponseEntity<List<UsedPartsDto>> getusedPartsList(@ModelAttribute UsedPartsListForm usedPartsListForm) throws Exception {

    Map<String, Object> params = UsedPartsListForm.createMap(usedPartsListForm);

    List<EgovMap> usedpartslist = MlogApiService.getUsedPartsList(params);
    List<UsedPartsDto> list = usedpartslist.stream().map(r -> UsedPartsDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "miscPart Master Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/miscPartList", method = RequestMethod.GET)
  public ResponseEntity<List<MiscPartDto>> miscPartList(@ModelAttribute MiscPartListForm miscPartListForm) throws Exception {

    Map<String, Object> params = MiscPartListForm.createMap(miscPartListForm);

    List<EgovMap> miscPartList = MlogApiService.getMiscPartList();

    for (int i = 0; i < miscPartList.size(); i++) {
      LOGGER.debug("miscPartList    값 : {}", miscPartList.get(i));

    }

    List<MiscPartDto> list = miscPartList.stream().map(r -> MiscPartDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Filter Inventory Display - Not Change List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/filterNotChangeList", method = RequestMethod.GET)
  public ResponseEntity<FilterNotChangeListVo> getfilterNotChangeList(@ModelAttribute FilterNotChangeListForm filterNotChangeListForm) throws Exception {

    Map<String, Object> params = FilterNotChangeListForm.createMap(filterNotChangeListForm);

    params.put("querytype", "sum");
    FilterNotChangeListVo dto = null;

    List<EgovMap> header = MlogApiService.getFilterNotChangeList(params);

    for (int i = 0; i < header.size(); i++) {

      LOGGER.debug("header 사이즈 : {}", header.get(i));

    }

    if (header.size() > 0) {
      dto = new FilterNotChangeListVo();

      for (int i = 0; i < header.size(); i++) {
        Map<String, Object> headerMap = header.get(i);

        dto.setTotalTobeChangeQty(Integer.parseInt(String.valueOf(headerMap.get("totalTobeChangeQty"))));

      }

      params.put("querytype", "list");
      List<EgovMap> notchangeDlist = MlogApiService.getFilterNotChangeList(params);

      List<FilterNotChangeDListDto> notchangelist = notchangeDlist.stream().map(r -> FilterNotChangeDListDto.create(r)).collect(Collectors.toList());
      dto.setPartsList(notchangelist);

      for (int i = 0; i < notchangelist.size(); i++) {
        LOGGER.debug("notchangelist 값 : {}", notchangelist.get(i));
      }

    }
    return ResponseEntity.ok(dto);

  }

  @ApiOperation(value = "Filter Inventory Display - User Filter List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/userFilterList", method = RequestMethod.GET)
  public ResponseEntity<UserFilterListVo> getuserFilterList(@ModelAttribute UserFilterListForm userFilterListForm) throws Exception {

    Map<String, Object> params = UserFilterListForm.createMap(userFilterListForm);

    params.put("querytype", "sum");
    UserFilterListVo dto = null;

    List<EgovMap> header = MlogApiService.getUserFilterList(params);

    for (int i = 0; i < header.size(); i++) {

      LOGGER.debug("header 사이즈 : {}", header.get(i));

    }

    if (header.size() > 0) {
      dto = new UserFilterListVo();

      for (int i = 0; i < header.size(); i++) {
        Map<String, Object> headerMap = header.get(i);

        dto.setTotalTobeChangeQty(Integer.parseInt(String.valueOf(headerMap.get("totalTobeChangeQty"))));
        dto.setTotalShortageQty(Integer.parseInt(String.valueOf(headerMap.get("totalShortageQty"))));
        dto.setTotalQty(Integer.parseInt(String.valueOf(headerMap.get("totalQty"))));

      }

      params.put("querytype", "list");
      List<EgovMap> userFilterDList = MlogApiService.getUserFilterList(params);

      List<UserFilterDListDto> userFilterList = userFilterDList.stream().map(r -> UserFilterDListDto.create(r)).collect(Collectors.toList());
      dto.setPartsList(userFilterList);

      for (int i = 0; i < userFilterDList.size(); i++) {
        LOGGER.debug("notchangelist 값 : {}", userFilterDList.get(i));
      }

    }
    return ResponseEntity.ok(dto);

  }

  @ApiOperation(value = "Filter Inventory Display - Change List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/filterChangeList", method = RequestMethod.GET)
  public ResponseEntity<FilterChangeListVo> getfilterChangeList(@ModelAttribute FilterChangeListForm filterChangeListForm) throws Exception {

    Map<String, Object> params = FilterChangeListForm.createMap(filterChangeListForm);

    params.put("querytype", "sum");
    FilterChangeListVo dto = null;

    List<EgovMap> header = MlogApiService.getFilterChangeList(params);

    for (int i = 0; i < header.size(); i++) {

      LOGGER.debug("header 사이즈 : {}", header.get(i));

    }

    if (header.size() > 0) {
      dto = new FilterChangeListVo();

      for (int i = 0; i < header.size(); i++) {
        Map<String, Object> headerMap = header.get(i);

        dto.setTotalTobeChangeQty(Integer.parseInt(String.valueOf(headerMap.get("totalTobeChangeQty"))));
        dto.setTotalShortageQty(Integer.parseInt(String.valueOf(headerMap.get("totalShortageQty"))));

      }

      params.put("querytype", "list");
      List<EgovMap> filterChangeDList = MlogApiService.getFilterChangeList(params);

      List<FilterChangeDListDto> filterChangeList = filterChangeDList.stream().map(r -> FilterChangeDListDto.create(r)).collect(Collectors.toList());
      dto.setPartsList(filterChangeList);

      for (int i = 0; i < filterChangeDList.size(); i++) {
        LOGGER.debug("notchangelist 값 : {}", filterChangeDList.get(i));
      }

    }
    return ResponseEntity.ok(dto);

  }

  @ApiOperation(value = "Inventory Status Display - On Hand Stock (My Stock)Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/inventoryOnHandStock", method = RequestMethod.GET)
  public ResponseEntity<List<InventoryOnHandStockDto>> getInventoryOnHandStock(@ModelAttribute InventoryOnHandStockForm inventoryOnHandStockForm) throws Exception {

    Map<String, Object> params = InventoryOnHandStockForm.createMap(inventoryOnHandStockForm);

    String type = params.get("searchType").toString();

    LOGGER.debug("type    값 : {}", type);

    List<EgovMap> getInventoryOnHandStock = null;

    if ("4".equals(type)) {
      getInventoryOnHandStock = MlogApiService.getInventoryOnHandStockNoSerial(params);
    } else {
      getInventoryOnHandStock = MlogApiService.getInventoryOnHandStock(params);
    }

    for (int i = 0; i < getInventoryOnHandStock.size(); i++) {
      LOGGER.debug("MyStockList    값 : {}", getInventoryOnHandStock.get(i));

    }

    List<InventoryOnHandStockDto> list = getInventoryOnHandStock.stream().map(r -> InventoryOnHandStockDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  /**
   * 아래부분 현창배 추가
   */

  @ApiOperation(value = "Stock Audit Result Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/stockaudit/result", method = RequestMethod.GET)
  public ResponseEntity<List<StockAuditResultDto>> getStockAuditResult(@ModelAttribute StockAuditResultForm stockauditresultForm) throws Exception {

    Map<String, Object> params = StockAuditResultForm.createMap(stockauditresultForm);

    List<EgovMap> stockauditresult = MlogApiService.getStockAuditResult(params);
    List<StockAuditResultDto> list = stockauditresult.stream().map(r -> StockAuditResultDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Stock Price Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/stock/price", method = RequestMethod.GET)
  public ResponseEntity<List<StockPriceDto>> getStockPriceList(@ModelAttribute StockPriceForm stockpriceForm) throws Exception {

    Map<String, Object> params = StockPriceForm.createMap(stockpriceForm);

    List<EgovMap> stockpricelist = MlogApiService.getStockPriceList(params);
    List<StockPriceDto> list = stockpricelist.stream().map(r -> StockPriceDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  /**
   * 인서트 부분 추가
   */

  @ApiOperation(value = "Inventory Status Display - Request Transfer", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/inventoryReqTransfer", method = RequestMethod.POST)
  public void inventoryReqTransfer(@RequestBody InventoryReqTransferMForm inventoryReqTransferMForms) throws Exception {
    MlogApiService.saveInvenReqTransfer(inventoryReqTransferMForms);

  }

  @ApiOperation(value = "Stock Transfer - Confirm GI Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/stockTransferConfirmGI", method = RequestMethod.POST)
  public void stockTransferConfirmGIReq(@RequestBody List<StockTransferConfirmGiMForm> stockTransferConfirmGiMForm) throws Exception {

    Boolean bool = false;

    if (!stockTransferConfirmGiMForm.isEmpty() && stockTransferConfirmGiMForm.size() > 0) {
      // 1. serialcheck 61,62,63 table search
      // try {
      Map<String, Object> chekMap = new HashMap();
      for (int i = 0; i < stockTransferConfirmGiMForm.size(); i++) {
        chekMap.put("userId", stockTransferConfirmGiMForm.get(i).getUserId());
        chekMap.put("partsCode", stockTransferConfirmGiMForm.get(i).getPartsCode());
        List<StockTransferConfirmGiDForm> list = stockTransferConfirmGiMForm.get(i).getStockTransferConfirmGiDetail();
        for (int j = 0; j < list.size(); j++) {
          // serial checkLogic add
          // StockTransferConfirmGiDForm scdf = list.get(j);
          // System.out.println("692Line :::: " + scdf.getSerialNo());
          StockTransferConfirmGiDForm form = list.get(j);

          chekMap.put("serialNo", form.getSerialNo());

          Map<String, Object> serialChek = MlogApiService.selectStockMovementSerial(chekMap);

          LOGGER.debug("CHECK62    값 : {}", serialChek.get("CHECK62"));
          LOGGER.debug("CHECK63    값 : {}", serialChek.get("CHECK63"));

          if ("Y".equals(serialChek.get("CHECK62")) && "Y".equals(serialChek.get("CHECK63"))) {
            // bool=true;
            LOGGER.debug("제대로된 시리얼입니다!!! ");
          } else {
            LOGGER.debug("제대로된 시리얼이 아닙니다!!!  ");
            // bool=false;
            throw new PreconditionException(AppConstants.FAIL, "Please check the serial.");
          }

        }
      }

      MlogApiService.stockMovementReqDelivery(stockTransferConfirmGiMForm);

    } else {
      throw new PreconditionException(AppConstants.FAIL, "No Data");
    }

  }

  /**
   * Stock Move. Out > Confirm GI(SERIAL_REQUIRE_CHK_YN= 'Y' location)
   *
   * @Author KR-MIN
   * @Date 2019. 12. 16.
   * @param stockTransferConfirmGiMForm
   * @throws Exception
   */
  @ApiOperation(value = "Stock Transfer - Confirm GI Request-Scan", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/stockTransferConfirmGIScan", method = RequestMethod.POST)
  public void stockTransferConfirmGIReqScan(@RequestBody List<StockTransferConfirmGiMForm> stockTransferConfirmGiMForm) throws Exception {

    Boolean bool = false;

    if (!stockTransferConfirmGiMForm.isEmpty() && stockTransferConfirmGiMForm.size() > 0) {

      MlogApiService.stockMovementReqDeliveryScan(stockTransferConfirmGiMForm);

    } else {
      throw new PreconditionException(AppConstants.FAIL, "No Data");
    }

  }

  @ApiOperation(value = "Receive Display - Confirm Receive", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/displayConfirmReceive", method = RequestMethod.POST)
  public void confirmReceive(@RequestBody ConfirmReceiveMForm confirmReceiveMForm) throws Exception {

    String delNo = confirmReceiveMForm.getSmoNo();

    Map<String, Object> grlist = MlogApiService.selectDelvryGRcmplt(delNo);
    // System.out.println("gr컴플리트?? : "+grlist);
    LOGGER.debug("grlist    값 : {}", grlist);
    // LOGGER.debug("사이즈 값 : {}", grlist.size());
    if (null == grlist) {
      throw new PreconditionException(AppConstants.FAIL, "DelvryNO does not exist.");
    }
    String grmplt = (String) grlist.get("DEL_GR_CMPLT");
    String gimplt = (String) grlist.get("DEL_GI_CMPLT");

    LOGGER.debug("grmplt    값 : {}", grmplt);
    LOGGER.debug("gimplt    값 : {}", gimplt);

    if ("Y".equals(grmplt) || "N".equals(gimplt)) {
      // System.out.println("NO");
      throw new PreconditionException(AppConstants.FAIL, "Already processed.");
    } else {
      // System.out.println("YES");
      MlogApiService.stockMovementConfirmReceive(confirmReceiveMForm);
    }
  }

  /**
   * On-Hand Stock Receive Display > Confirm recieve(SERIAL_REQUIRE_CHK_YN= 'Y' location)
   *
   * @Author KR-MIN
   * @Date 2019. 12. 16.
   * @param confirmReceiveMForm
   * @throws Exception
   */
  @ApiOperation(value = "Receive Display - Confirm Receive-Scan", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/displayConfirmReceiveScan", method = RequestMethod.POST)
  public void confirmReceiveScan(@RequestBody ConfirmReceiveMForm confirmReceiveMForm) throws Exception {

    String delNo = confirmReceiveMForm.getSmoNo();

    Map<String, Object> grlist = MlogApiService.selectDelvryGRcmplt(delNo);
    // System.out.println("gr컴플리트?? : "+grlist);
    LOGGER.debug("grlist    값 : {}", grlist);
    // LOGGER.debug("사이즈 값 : {}", grlist.size());
    if (null == grlist) {
      throw new PreconditionException(AppConstants.FAIL, "DelvryNO does not exist.");
    }
    String grmplt = (String) grlist.get("DEL_GR_CMPLT");
    String gimplt = (String) grlist.get("DEL_GI_CMPLT");

    LOGGER.debug("grmplt    값 : {}", grmplt);
    LOGGER.debug("gimplt    값 : {}", gimplt);

    if ("Y".equals(grmplt) || "N".equals(gimplt)) {
      // System.out.println("NO");
      throw new PreconditionException(AppConstants.FAIL, "Already processed.");
    } else {
      // System.out.println("YES");
      MlogApiService.stockMovementConfirmReceiveScan(confirmReceiveMForm);
    }
  }

  @ApiOperation(value = "Input result of Adjustment Stock Barcode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/inputAdjustmentStockBarcode", method = RequestMethod.POST)
  public void inputBarcode(@RequestBody List<InputBarcodePartsForm> inputBarcodePartsForm) throws Exception {

    MlogApiService.inputBarcode(inputBarcodePartsForm);
  }

  @ApiOperation(value = "Input count qty of Adjustment Stock in Non-Barcode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/inputAdjustmentStockNonBarcode", method = RequestMethod.POST)
  public void inputAdjustmentStockNonBarcode(@RequestBody InputNonBarcodeForm inputNonBarcodeForm) throws Exception {
    MlogApiService.inputNonBarcode(inputNonBarcodeForm);
  }

  @ApiOperation(value = "Stock Transfer - Reject SMO Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/rejectSMORequest", method = RequestMethod.POST)
  public void rejectSMORequest(@RequestBody StockTransferRejectSMOReqForm stockTransferRejectSMOReqForm) throws Exception {

    Map<String, Object> params = StockTransferRejectSMOReqForm.createMap(stockTransferRejectSMOReqForm);

    String str = MlogApiService.stockMovementCommonCancle(params);

    if (str != null && !"".equals(str)) {
      if ("18".equals(str)) {
        throw new PreconditionException(AppConstants.FAIL, "It cannot delete for INS.");
      } else {
        throw new PreconditionException(AppConstants.FAIL, "In process of request.");
      }
    }

  }

  @ApiOperation(value = "Request Result - Request Reject", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/requestResultReject", method = RequestMethod.POST)
  public void reqResultReject(@RequestBody RequestResultRejectForm requestResultRejectForm) throws Exception {

    Map<String, Object> params = RequestResultRejectForm.createMap(requestResultRejectForm);

    String str = MlogApiService.stockMovementCommonCancle(params);

    if (str != null && !"".equals(str)) {
      if ("18".equals(str)) {
        throw new PreconditionException(AppConstants.FAIL, "It cannot delete for INS.");
      } else {
        throw new PreconditionException(AppConstants.FAIL, "In process of request.");
      }
    }

  }

  @ApiOperation(value = "Return On-Hand Stock - Delete Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/returnOnHandStockDelReq", method = RequestMethod.POST)
  public void returnOnHandStockDelReq(@RequestBody RequestResultRejectForm requestResultRejectForm) throws Exception {

    Map<String, Object> params = RequestResultRejectForm.createMap(requestResultRejectForm);

    String str = MlogApiService.stockMovementCommonCancle(params);

    if (str != null && !"".equals(str)) {
      if ("18".equals(str)) {
        throw new PreconditionException(AppConstants.FAIL, "It cannot delete for INS.");
      } else {
        throw new PreconditionException(AppConstants.FAIL, "In process of request.");
      }
    }

  }

  @ApiOperation(value = "Return On-Hand Stock - Return Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/returnOnHandStockReq", method = RequestMethod.POST)
  public void returnOnHandStockReq(@RequestBody ReturnOnHandStockReqMForm returnOnHandStockReqMForm) throws Exception {
    MlogApiService.returnOnHandStockReq(returnOnHandStockReqMForm);
  }

  /**
   * Return On-Hand Stock > Register > Add > Confirm(SERIAL_REQUIRE_CHK_YN= 'Y' location)
   *
   * @Author KR-MIN
   * @Date 2019. 12. 16.
   * @param returnOnHandStockReqMForm
   * @throws Exception
   */
  @ApiOperation(value = "Return On-Hand Stock - Return Request-Scan", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/returnOnHandStockReqScan", method = RequestMethod.POST)
  public void returnOnHandStockReqScan(@RequestBody ReturnOnHandStockReqMForm returnOnHandStockReqMForm) throws Exception {
    MlogApiService.returnOnHandStockReqScan(returnOnHandStockReqMForm);
  }

  /* Woongjin Jun */
  @ApiOperation(value = "Stock HomeCare Price Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/stock/homeCarePrice", method = RequestMethod.GET)
  public ResponseEntity<List<StockPriceDto>> getStockHomeCarePriceList(@ModelAttribute StockPriceForm stockpriceForm) throws Exception {
    Map<String, Object> params = StockPriceForm.createMap(stockpriceForm);

    List<EgovMap> stockpricelist = MlogApiService.getStockHCPriceList(params);

    List<StockPriceDto> list = stockpricelist.stream().map(r -> StockPriceDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }
  /* Woongjin Jun */

  /* Woongjin Han */
  @ApiOperation(value = "Stock Transfer - Request Status List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/StockTransferReqStatusListScan", method = RequestMethod.GET)
  public ResponseEntity<List<StockTransferReqStatusMListDto>> getStockTransferReqStatusListScan(@ModelAttribute StockTransferReqStatusListForm StockTransferReqStatusListForm) throws Exception {

    Map<String, Object> params = StockTransferReqStatusListForm.createMap(StockTransferReqStatusListForm);

    List<EgovMap> headerList = MlogApiService.getStockTransferReqStatusMList(params);

    List<StockTransferReqStatusMListDto> hList = new ArrayList<>();
    for (int i = 0; i < headerList.size(); i++) {
      LOGGER.debug("Request Status headerList1111 값 : {}", headerList.get(i));
    }

    hList = headerList.stream().map(r -> StockTransferReqStatusMListDto.create(r)).collect(Collectors.toList());

    for (int i = 0; i < headerList.size(); i++) {

      // for (int j = 0; j < hList.size(); j++) {
      Map<String, Object> tmpMap = headerList.get(i);
      tmpMap.put("searchStatus", params.get("searchStatus"));
      List<EgovMap> reqParts = MlogApiService.getStockTransferReqStatusDListScan(tmpMap);

      List<StockTransferReqStatusDListDto> partsList = reqParts.stream().map(r -> StockTransferReqStatusDListDto.create(r)).collect(Collectors.toList());
      hList.get(i).setPartsList(partsList);
      // }

    }
    return ResponseEntity.ok(hList);
  }
  /* Woongjin Han */

  @ApiOperation(value = "Hi Care Inventory Control", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/hiCareInventory", method = RequestMethod.GET)
  public ResponseEntity<List<HiCareInventoryDto>> getHiCareInventory(@ModelAttribute HiCareInventoryForm hiCareInventoryForm) throws Exception {

    Map<String, Object> params = hiCareInventoryForm.createMap(hiCareInventoryForm);

    List<EgovMap> StockHolder = MlogApiService.getHiCareInventory(params);

    for (int i = 0; i < StockHolder.size(); i++) {
      LOGGER.debug("StockHolder 값 : {}", StockHolder.get(i));

    }

    List<HiCareInventoryDto> list = StockHolder.stream().map(r -> HiCareInventoryDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Stock Movement - In Out Qty List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/smoInOutQtyList", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> getSmoInOutQtyList(@ModelAttribute LogStockReceiveForm LogStockReceiveForm) throws Exception {

    Map<String, Object> params = LogStockReceiveForm.createMap(LogStockReceiveForm);

    Map<String, Object> details = MlogApiService.getSMOCntList(params);

    /*
     * List<StockTransferSMOCntRespForm> hList = new ArrayList<>();
     * for (int i = 0; i < headerList.size(); i++) {
     * LOGGER.debug("Request Status headerList1111 값 : {}", headerList.get(i));
     * }
     */

    // StockTransferSMOCntRespForm cntdetails = headerList.stream().map(r -> StockTransferSMOCntRespForm.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(details);
  }

  @ApiOperation(value = "Inventory Status Display - Onhand Stock Serial Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/onHandStkSerialSearch", method = RequestMethod.GET)
  public ResponseEntity<List<InventoryOnHandStockSerialDto>> getOnHandStkSerialList(@ModelAttribute InventoryOnHandStockSerialForm InventoryOnHandStockSerialForm) throws Exception {

    Map<String, Object> params = InventoryOnHandStockSerialForm.createMap(InventoryOnHandStockSerialForm);
    List<EgovMap> detail = MlogApiService.getOnHandStkSerialList(params);

    for (int i = 0; i < detail.size(); i++) {
      LOGGER.debug("ON HAND STOCK SERIAL CHECK : {}", detail.get(i));
    }

    List<InventoryOnHandStockSerialDto> list = detail.stream().map(r -> InventoryOnHandStockSerialDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Consignment Transfer Amount Cody - Get Member Listing Only Own Branch", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/getMemberList", method = RequestMethod.GET)
  public ResponseEntity<List<InventoryCodyOnHandStockDto>> getMemberList(@ModelAttribute InventoryCodyOnHandStockForm inventoryCodyOnHandStockForm) throws Exception {

    Map<String, Object> params = InventoryCodyOnHandStockForm.createMap(inventoryCodyOnHandStockForm);
    List<EgovMap> detail = MlogApiService.getAllMember(params);

    for (int i = 0; i < detail.size(); i++) {
      LOGGER.debug("MEMBER LISTING : {}", detail.get(i));
    }

    List<InventoryCodyOnHandStockDto> list = detail.stream().map(r -> InventoryCodyOnHandStockDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Consignment Transfer Amount Cody - Get Available Filter List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/getCodyAvaFilterList", method = RequestMethod.GET)
  public ResponseEntity<List<InventoryCodyOnHandStockDto>> getCodyAvaFilterList(@ModelAttribute InventoryCodyOnHandStockForm inventoryCodyOnHandStockForm) throws Exception {

    Map<String, Object> params = InventoryCodyOnHandStockForm.createMap(inventoryCodyOnHandStockForm);
    List<EgovMap> detail = MlogApiService.getCodyAvaFilterList(params);

    for (int i = 0; i < detail.size(); i++) {
      LOGGER.debug("CODY AVAILABLE FILTER LISTING : {}", detail.get(i));
    }

    List<InventoryCodyOnHandStockDto> list = detail.stream().map(r -> InventoryCodyOnHandStockDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }
}
