package com.coway.trust.api.mobile.logistics;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.logistics.alternativefilter.AlternativeFilterDListDto;
import com.coway.trust.api.mobile.logistics.alternativefilter.AlternativeFilterDListForm;
import com.coway.trust.api.mobile.logistics.alternativefilter.AlternativeFilterMListDto;
import com.coway.trust.api.mobile.logistics.alternativefilter.AlternativeFilterMListForm;
import com.coway.trust.api.mobile.logistics.audit.BarcodeListDto;
import com.coway.trust.api.mobile.logistics.audit.BarcodeListForm;
import com.coway.trust.api.mobile.logistics.audit.NonBarcodeListDto;
import com.coway.trust.api.mobile.logistics.audit.NonBarcodeListForm;
import com.coway.trust.api.mobile.logistics.audit.StockAuditResultDetailDto;
import com.coway.trust.api.mobile.logistics.audit.StockAuditResultDetailForm;
import com.coway.trust.api.mobile.logistics.audit.StockAuditResultDto;
import com.coway.trust.api.mobile.logistics.audit.StockAuditResultForm;
import com.coway.trust.api.mobile.logistics.ctcodylist.DisplayCt_CodyListDto;
import com.coway.trust.api.mobile.logistics.ctcodylist.DisplayCt_CodyListForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryAllListDto;
import com.coway.trust.api.mobile.logistics.inventory.InventoryAllListForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryOverallStockDto;
import com.coway.trust.api.mobile.logistics.inventory.InventoryOverallStockForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryStockByHolderDto;
import com.coway.trust.api.mobile.logistics.inventory.InventoryStockByHolderForm;
import com.coway.trust.api.mobile.logistics.itembank.ItemBankItemListDto;
import com.coway.trust.api.mobile.logistics.itembank.ItemBankItemListForm;
import com.coway.trust.api.mobile.logistics.itembank.ItemBankLocationListDto;
import com.coway.trust.api.mobile.logistics.itembank.ItemBankLocationListForm;
import com.coway.trust.api.mobile.logistics.mystock.MyStockListDto;
import com.coway.trust.api.mobile.logistics.mystock.MyStockListForm;
import com.coway.trust.api.mobile.logistics.rdcstock.RdcStockListDto;
import com.coway.trust.api.mobile.logistics.rdcstock.RdcStockListForm;
import com.coway.trust.api.mobile.logistics.recevie.LogStockPartsReceiveDto;
import com.coway.trust.api.mobile.logistics.recevie.LogStockReceiveDto;
import com.coway.trust.api.mobile.logistics.recevie.LogStockReceiveForm;
import com.coway.trust.api.mobile.logistics.requestresult.RequestResultDListDto;
import com.coway.trust.api.mobile.logistics.requestresult.RequestResultListForm;
import com.coway.trust.api.mobile.logistics.requestresult.RequestResultMListDto;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnOnHandStockDListDto;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnOnHandStockListForm;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnOnHandStockMListDto;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnPartsSearchDto;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnPartsSearchForm;
import com.coway.trust.api.mobile.logistics.salesprice.StockPriceDto;
import com.coway.trust.api.mobile.logistics.salesprice.StockPriceForm;
import com.coway.trust.api.mobile.logistics.stockbyholder.StockByHolderListDto;
import com.coway.trust.api.mobile.logistics.stockbyholder.StockByHolderListForm;
import com.coway.trust.api.mobile.logistics.stockbyholder.StockByHolderQtyDto;
import com.coway.trust.api.mobile.logistics.stockbyholder.StockByHolderQtyForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockRequestStatusForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferReqStatusDListDto;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferReqStatusListForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferReqStatusMListDto;
import com.coway.trust.biz.logistics.mlog.MlogApiService;
import com.coway.trust.biz.logistics.mlog.vo.StrockMovementVoForMobile;

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

	@ApiOperation(value = "RDC Stock List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/rdcStockList", method = RequestMethod.GET)
	public ResponseEntity<List<RdcStockListDto>> getRDCStockList(@ModelAttribute RdcStockListForm RdcStockListForm)
			throws Exception {

		Map<String, Object> params = RdcStockListForm.createMap(RdcStockListForm);

		List<EgovMap> RDCStockList = MlogApiService.getRDCStockList(params);

		for (int i = 0; i < RDCStockList.size(); i++) {
			LOGGER.debug("RDCStockList    값 : {}", RDCStockList.get(i));

		}

		List<RdcStockListDto> list = RDCStockList.stream().map(r -> RdcStockListDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	@ApiOperation(value = "Stock by Holder List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/stockbyHolderList", method = RequestMethod.GET)
	public ResponseEntity<List<StockByHolderListDto>> getStockbyHolderList(
			@ModelAttribute StockByHolderListForm StockByHolderListForm) throws Exception {

		Map<String, Object> params = StockByHolderListForm.createMap(StockByHolderListForm);

		List<EgovMap> StockbyHolderList = MlogApiService.getStockbyHolderList(params);

		for (int i = 0; i < StockbyHolderList.size(); i++) {
			LOGGER.debug("StockbyHolderList    값 : {}", StockbyHolderList.get(i));

		}
		List<StockByHolderListDto> list = StockbyHolderList.stream().map(r -> StockByHolderListDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	@ApiOperation(value = "Common StockList 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/stockCommonQty", method = RequestMethod.GET)
	public ResponseEntity<List<StockByHolderQtyDto>> getStockbyHolderQty(
			@ModelAttribute StockByHolderQtyForm StockByHolderQtyForm) throws Exception {

		Map<String, Object> params = StockByHolderQtyForm.createMap(StockByHolderQtyForm);

		List<EgovMap> StockbyHolderQty = MlogApiService.getCommonQty(params);

		for (int i = 0; i < StockbyHolderQty.size(); i++) {
			LOGGER.debug("StockbyHolderQty    값 : {}", StockbyHolderQty.get(i));

		}
		List<StockByHolderQtyDto> list = StockbyHolderQty.stream().map(r -> StockByHolderQtyDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	@ApiOperation(value = "DisplayCt_CodyList 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/displayCt_CodyList", method = RequestMethod.GET)
	public ResponseEntity<List<DisplayCt_CodyListDto>> getCTStockList(
			@ModelAttribute DisplayCt_CodyListForm DisplayCt_CodyListForm) throws Exception {

		Map<String, Object> params = DisplayCt_CodyListForm.createMap(DisplayCt_CodyListForm);

		List<EgovMap> CTStockList = MlogApiService.getCt_CodyList(params);

		for (int i = 0; i < CTStockList.size(); i++) {
			LOGGER.debug("CTStockList    값 : {}", CTStockList.get(i));

		}
		List<DisplayCt_CodyListDto> list = CTStockList.stream().map(r -> DisplayCt_CodyListDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	@ApiOperation(value = "Inventory Status Display - Overall Stock 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/inventoryOverallStock", method = RequestMethod.GET)
	public ResponseEntity<List<InventoryOverallStockDto>> getInventoryOverallStock(
			@ModelAttribute InventoryOverallStockForm InventoryOverallStockForm) throws Exception {

		Map<String, Object> params = InventoryOverallStockForm.createMap(InventoryOverallStockForm);

		List<EgovMap> inventoryOverallStock = MlogApiService.getInventoryOverallStock(params);

		for (int i = 0; i < inventoryOverallStock.size(); i++) {
			LOGGER.debug("inventoryOverallStock    값 : {}", inventoryOverallStock.get(i));
		}

		List<InventoryOverallStockDto> list = inventoryOverallStock.stream().map(r -> InventoryOverallStockDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	@ApiOperation(value = "Inventory Status Display - All List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/inventoryAllList", method = RequestMethod.GET)
	public ResponseEntity<List<InventoryAllListDto>> getAllStockList(
			@ModelAttribute InventoryAllListForm InventoryAllListForm) throws Exception {

		Map<String, Object> params = InventoryAllListForm.createMap(InventoryAllListForm);

		List<EgovMap> MyStockList = MlogApiService.getAllStockList(params);

		for (int i = 0; i < MyStockList.size(); i++) {
			LOGGER.debug("MyStockList    값 : {}", MyStockList.get(i));

		}

		List<InventoryAllListDto> list = MyStockList.stream().map(r -> InventoryAllListDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	@ApiOperation(value = "Inventory Status Display - Stock by Holder 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/inventoryStockByHolder", method = RequestMethod.GET)
	public ResponseEntity<List<InventoryStockByHolderDto>> getInventoryStockByHolder(
			@ModelAttribute InventoryStockByHolderForm InventoryStockByHolderForm) throws Exception {

		Map<String, Object> params = InventoryStockByHolderForm.createMap(InventoryStockByHolderForm);

		List<EgovMap> StockHolder = MlogApiService.getInventoryStockByHolder(params);

		for (int i = 0; i < StockHolder.size(); i++) {
			LOGGER.debug("StockHolder 값 : {}", StockHolder.get(i));

		}

		List<InventoryStockByHolderDto> list = StockHolder.stream().map(r -> InventoryStockByHolderDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "StockReceive 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/stockReceiveList", method = RequestMethod.GET)
	public ResponseEntity<List<LogStockReceiveDto>> stockReceiveList(
			@ModelAttribute LogStockReceiveForm LogStockReceiveForm) throws Exception {

		Map<String, Object> params = LogStockReceiveForm.createMap(LogStockReceiveForm);

		List<EgovMap> headerList = MlogApiService.StockReceiveList(params);

		List<LogStockReceiveDto> hList = null;
		for (int i = 0; i < headerList.size(); i++) {
			LOGGER.debug("headerList 값 : {}", headerList.get(i));
		}

		for (int i = 0; i < headerList.size(); i++) {

			hList = headerList.stream().map(r -> LogStockReceiveDto.create(r)).collect(Collectors.toList());

			for (int j = 0; j < hList.size(); j++) {
				Map<String, Object> tmpMap = (Map<String, Object>) headerList.get(j);
				List<EgovMap> serialList = MlogApiService.selectStockReceiveSerial(tmpMap);

				List<LogStockPartsReceiveDto> partsList = serialList.stream()
						.map(r -> LogStockPartsReceiveDto.create(r)).collect(Collectors.toList());
				hList.get(j).setPartsList(partsList);
			}

		}

		return ResponseEntity.ok(hList);

	}

	
	@ApiOperation(value = "My Stock List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/myStockList", method = RequestMethod.GET)
	public ResponseEntity<List<MyStockListDto>> getMyStockList(
			@ModelAttribute MyStockListForm MyStockListForm) throws Exception {

		Map<String, Object> params = MyStockListForm.createMap(MyStockListForm);

		List<EgovMap> MyStockList = MlogApiService.getMyStockList(params);

		for (int i = 0; i < MyStockList.size(); i++) {
			LOGGER.debug("MyStockList    값 : {}", MyStockList.get(i));

		}

		List<MyStockListDto> list = MyStockList.stream().map(r -> MyStockListDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	@ApiOperation(value = "Return On-Hand Stock - Parts Search 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/returnPartsSearch", method = RequestMethod.GET)
	public ResponseEntity<List<ReturnPartsSearchDto>> getReturnPartsSearch(
			@ModelAttribute ReturnPartsSearchForm ReturnPartsSearchForm) throws Exception {

		Map<String, Object> params = ReturnPartsSearchForm.createMap(ReturnPartsSearchForm);

		List<EgovMap> ReturnPartsSearchList = MlogApiService.getReturnPartsSearch(params);

		for (int i = 0; i < ReturnPartsSearchList.size(); i++) {
			LOGGER.debug("ReturnPartsSearchList    값 : {}", ReturnPartsSearchList.get(i));

		}

		List<ReturnPartsSearchDto> list = ReturnPartsSearchList.stream().map(r -> ReturnPartsSearchDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	@ApiOperation(value = "Alternative Filter Master List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/alternativeFilterMList", method = RequestMethod.GET)
	public ResponseEntity<List<AlternativeFilterMListDto>> getAlternativeFilterMList(
			@ModelAttribute AlternativeFilterMListForm AlternativeFilterMListForm) throws Exception {

		Map<String, Object> params = AlternativeFilterMListForm.createMap(AlternativeFilterMListForm);

		List<EgovMap> alternativeFilterMList = MlogApiService.getAlternativeFilterMList();

		for (int i = 0; i < alternativeFilterMList.size(); i++) {
			LOGGER.debug("alternativeFilterMList    값 : {}", alternativeFilterMList.get(i));

		}
		
		List<AlternativeFilterMListDto> list = alternativeFilterMList.stream().map(r -> AlternativeFilterMListDto.create(r))
				.collect(Collectors.toList());		
		
		return ResponseEntity.ok(list);
	}
	
	
	@ApiOperation(value = "Alternative Filter Detail List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/alternativeFilterDList", method = RequestMethod.GET)
	public ResponseEntity<List<AlternativeFilterDListDto>> getAlternativeFilterDList(
			@ModelAttribute AlternativeFilterDListForm AlternativeFilterDListForm) throws Exception {

		Map<String, Object> params = AlternativeFilterDListForm.createMap(AlternativeFilterDListForm);

		List<EgovMap> alternativeFilterDList = MlogApiService.getAlternativeFilterDList();

		for (int i = 0; i < alternativeFilterDList.size(); i++) {
			LOGGER.debug("alternativeFilterDList    값 : {}", alternativeFilterDList.get(i));

		}
		
		List<AlternativeFilterDListDto> list = alternativeFilterDList.stream().map(r -> AlternativeFilterDListDto.create(r))
				.collect(Collectors.toList());		
		
		return ResponseEntity.ok(list);
	}
	
	
	
	@ApiOperation(value = "Item Bank & Cody Item - Location List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/itemBankLocationList", method = RequestMethod.GET)
	public ResponseEntity<List<ItemBankLocationListDto>> getItemBankLocationList(
			@ModelAttribute ItemBankLocationListForm ItemBankLocationListForm) throws Exception {

		Map<String, Object> params = ItemBankLocationListForm.createMap(ItemBankLocationListForm);

		List<EgovMap> itemBankLocationList = MlogApiService.getItemBankLocationList(params);

		for (int i = 0; i < itemBankLocationList.size(); i++) {
			LOGGER.debug("itemBankLocationList    값 : {}", itemBankLocationList.get(i));

		}

		List<ItemBankLocationListDto> list = itemBankLocationList.stream().map(r -> ItemBankLocationListDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	@ApiOperation(value = "Item Bank & Cody Item - Item List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/itemBankItemList", method = RequestMethod.GET)
	public ResponseEntity<List<ItemBankItemListDto>> getItemBankItemList(
			@ModelAttribute ItemBankItemListForm ItemBankItemListForm) throws Exception {

		Map<String, Object> params = ItemBankItemListForm.createMap(ItemBankItemListForm);

		List<EgovMap> itemBankItemList = MlogApiService.getItemBankItemList();

		for (int i = 0; i < itemBankItemList.size(); i++) {
			LOGGER.debug("itemBankItemList    값 : {}", itemBankItemList.get(i));

		}

		List<ItemBankItemListDto> list = itemBankItemList.stream().map(r -> ItemBankItemListDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	@ApiOperation(value = "Request Result - List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/requestResultList", method = RequestMethod.GET)
	public ResponseEntity<List<RequestResultMListDto>> getRequestResultList(
			@ModelAttribute RequestResultListForm RequestResultListForm) throws Exception {

		Map<String, Object> params = RequestResultListForm.createMap(RequestResultListForm);

		List<EgovMap> headerList = MlogApiService.getCommonReqHeader(params);

		List<RequestResultMListDto> hList = null;
		for (int i = 0; i < headerList.size(); i++) {
			LOGGER.debug("headerList 값 : {}", headerList.get(i));
		}

		for (int i = 0; i < headerList.size(); i++) {

			hList = headerList.stream().map(r -> RequestResultMListDto.create(r)).collect(Collectors.toList());

			for (int j = 0; j < hList.size(); j++) {
				Map<String, Object> tmpMap = (Map<String, Object>) headerList.get(j);
				List<EgovMap> reqParts = MlogApiService.getCommonReqParts(tmpMap);

				List<RequestResultDListDto> partsList = reqParts.stream()
						.map(r -> RequestResultDListDto.create(r)).collect(Collectors.toList());
				hList.get(j).setPartsList(partsList);
			}

		}

		return ResponseEntity.ok(hList);

	}
		
	
	@ApiOperation(value = "Return On-Hand Stock - List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/returnOnHandStockList", method = RequestMethod.GET)
	public ResponseEntity<List<ReturnOnHandStockMListDto>> getreturnOnHandStockList(
			@ModelAttribute ReturnOnHandStockListForm ReturnOnHandStockListForm) throws Exception {

		Map<String, Object> params = ReturnOnHandStockListForm.createMap(ReturnOnHandStockListForm);

		List<EgovMap> headerList = MlogApiService.getCommonReqHeader(params);

		List<ReturnOnHandStockMListDto> hList = null;
		for (int i = 0; i < headerList.size(); i++) {
			LOGGER.debug("headerList 값 : {}", headerList.get(i));
		}

		for (int i = 0; i < headerList.size(); i++) {

			hList = headerList.stream().map(r -> ReturnOnHandStockMListDto.create(r)).collect(Collectors.toList());

			for (int j = 0; j < hList.size(); j++) {
				Map<String, Object> tmpMap = (Map<String, Object>) headerList.get(j);
				List<EgovMap> reqParts = MlogApiService.getCommonReqParts(tmpMap);

				List<ReturnOnHandStockDListDto> partsList = reqParts.stream()
						.map(r -> ReturnOnHandStockDListDto.create(r)).collect(Collectors.toList());
				hList.get(j).setPartsList(partsList);
			}

		}
		return ResponseEntity.ok(hList);
	}
	
	
	@ApiOperation(value = "Audit Stock - Result Detail 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/auditStockResultDetail", method = RequestMethod.GET)
	public ResponseEntity<List<StockAuditResultDetailDto>> getAuditStockResultDetail(
			@ModelAttribute StockAuditResultDetailForm StockAuditResultDetailForm) throws Exception {

		Map<String, Object> params = StockAuditResultDetailForm.createMap(StockAuditResultDetailForm);

		List<EgovMap> auditStockResultDetail = MlogApiService.getAuditStockResultDetail(params);

		for (int i = 0; i < auditStockResultDetail.size(); i++) {
			LOGGER.debug("itemBankLocationList    값 : {}", auditStockResultDetail.get(i));

		}

		List<StockAuditResultDetailDto> list = auditStockResultDetail.stream().map(r -> StockAuditResultDetailDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	@ApiOperation(value = "Stock Transfer - Request Status List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/StockTransferReqStatusList", method = RequestMethod.GET)
	public ResponseEntity<List<StockTransferReqStatusMListDto>> getStockTransferReqStatusList(
			@ModelAttribute StockTransferReqStatusListForm StockTransferReqStatusListForm) throws Exception {

		Map<String, Object> params = StockTransferReqStatusListForm.createMap(StockTransferReqStatusListForm);

		List<EgovMap> headerList = MlogApiService.getStockTransferReqStatusMList(params);

		List<StockTransferReqStatusMListDto> hList = null;
		for (int i = 0; i < headerList.size(); i++) {
			LOGGER.debug("headerList 값 : {}", headerList.get(i));
		}

		for (int i = 0; i < headerList.size(); i++) {

			hList = headerList.stream().map(r -> StockTransferReqStatusMListDto.create(r)).collect(Collectors.toList());

			for (int j = 0; j < hList.size(); j++) {
				Map<String, Object> tmpMap = (Map<String, Object>) headerList.get(j);
				List<EgovMap> reqParts = MlogApiService.getStockTransferReqStatusDList(tmpMap);

				List<StockTransferReqStatusDListDto> partsList = reqParts.stream()
						.map(r -> StockTransferReqStatusDListDto.create(r)).collect(Collectors.toList());
				hList.get(j).setPartsList(partsList);
			}

		}
		return ResponseEntity.ok(hList);
	}
	
	
	
	
	/**
	 * 아래부분 현창배 추가
	 */

	@ApiOperation(value = "Stock Audit Barcode 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/barcode/list", method = RequestMethod.GET)
	public ResponseEntity<List<BarcodeListDto>> getBarcodeList(@ModelAttribute BarcodeListForm barcodeListForm)
			throws Exception {

		Map<String, Object> params = BarcodeListForm.createMap(barcodeListForm);

		List<EgovMap> barcodeList = MlogApiService.getBarcodeList(params);
		List<BarcodeListDto> list = barcodeList.stream().map(r -> BarcodeListDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "Stock Audit NonBarcode 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/nonbarcode/list", method = RequestMethod.GET)
	public ResponseEntity<List<NonBarcodeListDto>> getNonBarcodeList(
			@ModelAttribute NonBarcodeListForm nonbarcodeListForm) throws Exception {

		Map<String, Object> params = NonBarcodeListForm.createMap(nonbarcodeListForm);

		List<EgovMap> nonbarcodeList = MlogApiService.getNonBarcodeList(params);
		List<NonBarcodeListDto> list = nonbarcodeList.stream().map(r -> NonBarcodeListDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "Stock Audit Result 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/stockaudit/result", method = RequestMethod.GET)
	public ResponseEntity<List<StockAuditResultDto>> getStockAuditResult(
			@ModelAttribute StockAuditResultForm stockauditresultForm) throws Exception {

		Map<String, Object> params = StockAuditResultForm.createMap(stockauditresultForm);

		List<EgovMap> stockauditresult = MlogApiService.getStockAuditResult(params);
		List<StockAuditResultDto> list = stockauditresult.stream().map(r -> StockAuditResultDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "Stock Price 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/stock/price", method = RequestMethod.GET)
	public ResponseEntity<List<StockPriceDto>> getStockPriceList(@ModelAttribute StockPriceForm stockpriceForm)
			throws Exception {

		Map<String, Object> params = StockPriceForm.createMap(stockpriceForm);

		List<EgovMap> stockpricelist = MlogApiService.getStockPriceList(params);
		List<StockPriceDto> list = stockpricelist.stream().map(r -> StockPriceDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

//	@ApiOperation(value = "Stock Request 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
//	@RequestMapping(value = "/movement/requeststatus", method = RequestMethod.GET)
//	public ResponseEntity<List<StrockMovementVoForMobile>> getStockRequestStatusList(
//			@ModelAttribute StockRequestStatusForm stockRequestStatusForm) throws Exception {
//
//		Map<String, Object> params = StockRequestStatusForm.createMap(stockRequestStatusForm);
//
//		List<StrockMovementVoForMobile> headerList = MlogApiService.getStockRequestStatusHeader(params);
//		for (int i = 0; i < headerList.size(); i++) {
//			Map<String, Object> setMap = new HashMap<String, Object>();
//			setMap.put("reqstNo", headerList.get(i).getSmoNo());
//			List<StrockMovementVoForMobile> partsList = MlogApiService.getRequestStatusParts(setMap);
//			headerList.get(i).setPartsList(partsList);
//		}
//		return ResponseEntity.ok(headerList);
//	}
}
