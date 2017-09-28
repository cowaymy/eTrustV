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
import com.coway.trust.biz.logistics.mlog.MlogApiService;
import com.coway.trust.biz.logistics.stockmovement.vo.StrockMovementVoForMobile;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "logistics api", description = "logistics api")
@RestController(value = "logisticsApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/logistics")
public class logisticsApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(logisticsApiController.class);

	@Resource(name = "MlogApiService")
	private MlogApiService MlogApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "CT 재고 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/StockbyHolderList", method = RequestMethod.GET)
	public ResponseEntity<List<logisticsCodeAllDto>> CTStockList(
			@ModelAttribute logisticsCodeAllForm logisticsCodeAllForm) throws Exception {

		Map<String, Object> params = logisticsCodeAllForm.createMap(logisticsCodeAllForm);

		List<EgovMap> CTStockList = MlogApiService.getCTStockList(params);

		for (int i = 0; i < CTStockList.size(); i++) {
			LOGGER.debug("CTStockList    값 : {}", CTStockList.get(i));

		}
		List<logisticsCodeAllDto> list = CTStockList.stream().map(r -> logisticsCodeAllDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "RDC 재고 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/RDCStockList", method = RequestMethod.GET)
	public ResponseEntity<List<logisticsRdcStockDto>> RDCStockList(
			@ModelAttribute logisticsRdcStockForm logisticsRdcStockForm) throws Exception {

		Map<String, Object> params = logisticsRdcStockForm.createMap(logisticsRdcStockForm);

		List<EgovMap> RDCStockList = MlogApiService.getRDCStockList(params);

		for (int i = 0; i < RDCStockList.size(); i++) {
			LOGGER.debug("RDCStockList    값 : {}", RDCStockList.get(i));

		}

		List<logisticsRdcStockDto> list = RDCStockList.stream().map(r -> logisticsRdcStockDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "parts 재고 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/MyStockList", method = RequestMethod.GET)
	public ResponseEntity<List<logisticsAllStockListDto>> MyStockList(
			@ModelAttribute logisticsAllStockListForm logisticsAllStockListForm) throws Exception {

		Map<String, Object> params = logisticsAllStockListForm.createMap(logisticsAllStockListForm);

		List<EgovMap> MyStockList = MlogApiService.getAllStockList(params);

		for (int i = 0; i < MyStockList.size(); i++) {
			LOGGER.debug("MyStockList    값 : {}", MyStockList.get(i));

		}

		List<logisticsAllStockListDto> list = MyStockList.stream().map(r -> logisticsAllStockListDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	// @ApiOperation(value = "StockHolder 재고 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces =
	// MediaType.APPLICATION_JSON_VALUE)
	// @RequestMapping(value = "/StockHolderList", method = RequestMethod.GET)
	// public ResponseEntity<List<logStockHolderDto>> StockHolderList(@ModelAttribute logisticsStockHolderForm
	// logisticsStockHolderForm)
	// throws Exception {
	//
	// Map<String, Object> params = logisticsStockHolderForm.createMap(logisticsStockHolderForm);
	//
	// List<EgovMap> StockHolder = MlogApiService.selectPartsStockHolder(params);
	//
	// for (int i = 0; i < StockHolder.size(); i++) {
	// LOGGER.debug("StockHolder 값 : {}",StockHolder.get(i));
	//
	// }
	//
	// List<logStockHolderDto> list = StockHolder.stream().map(r -> logStockHolderDto.create(r))
	// .collect(Collectors.toList());
	//
	// return ResponseEntity.ok(list);
	// }

	@ApiOperation(value = "StockReceive 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/StockReceiveList", method = RequestMethod.GET)
	public ResponseEntity<List<LogStockReceiveDto>> StockReceiveList(
			@ModelAttribute LogStockReceiveForm LogStockReceiveForm) throws Exception {

		Map<String, Object> params = LogStockReceiveForm.createMap(LogStockReceiveForm);

		List<EgovMap> headerList = MlogApiService.StockReceiveList(params);

		for (int i = 0; i < headerList.size(); i++) {
			Map<String, Object> tmpMap = headerList.get(i);

			List<EgovMap> serialList = MlogApiService.selectStockReceiveSerial(tmpMap);

		}

		List<LogStockReceiveDto> list = headerList.stream().map(r -> LogStockReceiveDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	// class AllDto{
	// private List<HeaderDto> headers;
	// private List<PartDto> parts;
	//
	//
	//
	// class HeaderDto{
	// private String headerId;
	// private String headerName;
	// }
	//
	// class PartDto{
	// private String partId;
	// private String partName;
	// }
	// }

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

	@ApiOperation(value = "Stock Request 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/movement/requeststatus", method = RequestMethod.GET)
	public ResponseEntity<List<StrockMovementVoForMobile>> getStockRequestStatusList(
			@ModelAttribute StockRequestStatusForm stockRequestStatusForm) throws Exception {

		Map<String, Object> params = StockRequestStatusForm.createMap(stockRequestStatusForm);

		List<StrockMovementVoForMobile> headerList = MlogApiService.getStockRequestStatusHeader(params);
		for (int i = 0; i < headerList.size(); i++) {
			Map<String, Object> setMap = new HashMap<String, Object>();
			setMap.put("reqstNo", headerList.get(i).getSmoNo());
			List<StrockMovementVoForMobile> partsList = MlogApiService.getRequestStatusParts(setMap);
			headerList.get(i).setPartsList(partsList);
		}
		return ResponseEntity.ok(headerList);
	}
}
