package com.coway.trust.api.mobile.payment.mobileLumpSumPayment;

import java.util.ArrayList;
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
import com.coway.trust.api.mobile.payment.eGhlPaymentCollection.EGhlPaymentCollectionApiDto;
import com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.MobileLumpSumPaymentKeyInService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : MobileLumpSumPaymentKeyInApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author                 Description
 * -------------  -----------              -------------
 * 2023. 03.08   MY-FRANGO        First creation
 * </pre>
 */

@Api(value = "mobileLumpSumPayment api", description = "mobileLumpSumPayment api")
@RestController(value = "MobileLumpSumPaymentApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/mobileLumpSumPayment")
public class MobileLumpSumPaymentApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MobileLumpSumPaymentApiController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name="mobileLumpSumPaymentKeyInService")
	private MobileLumpSumPaymentKeyInService mobileLumpSumPaymentKeyInService;

	@ApiOperation(value = "customerInfoSearch", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/customerInfoSearch", method = RequestMethod.GET)
	public ResponseEntity<List<MobileLumpSumPaymentApiDto>> customerInfoSearch(@ModelAttribute MobileLumpSumPaymentApiForm mobileLumpSumPaymentApiForm) throws Exception {
		Map<String, Object> params = mobileLumpSumPaymentApiForm.createMap(mobileLumpSumPaymentApiForm);

		List<EgovMap> searchResult = mobileLumpSumPaymentKeyInService.customerInfoSearch(params);
		if(searchResult.size() > 0){
		    List<MobileLumpSumPaymentApiDto> result = searchResult.stream().map(r -> MobileLumpSumPaymentApiDto.create(r)).collect(Collectors.toList());
			return ResponseEntity.ok(result);
		}
		else{
			List<MobileLumpSumPaymentApiDto> result = new ArrayList<>();
			return ResponseEntity.ok(result);
		}
	}

	@ApiOperation(value = "getCustomerOutstandingOrderNumber", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/getCustomerOutstandingOrderNumber", method = RequestMethod.GET)
	public ResponseEntity<List<MobileLumpSumPaymentApiDto>> getCustomerOutstandingOrderNumber(@ModelAttribute MobileLumpSumPaymentApiForm mobileLumpSumPaymentApiForm) throws Exception {
		Map<String, Object> params = mobileLumpSumPaymentApiForm.createMap(mobileLumpSumPaymentApiForm);

		List<EgovMap> searchResult = mobileLumpSumPaymentKeyInService.getCustomerOutstandingDistinctOrder(params);
	    List<MobileLumpSumPaymentApiDto> result = searchResult.stream().map(r -> MobileLumpSumPaymentApiDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(result);
	}

	@ApiOperation(value = "getCustomerOutstandingOrderDetailList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/getCustomerOutstandingOrderDetailList", method = RequestMethod.GET)
	public ResponseEntity<List<MobileLumpSumPaymentApiDto>> getCustomerOutstandingOrderDetailList(@ModelAttribute MobileLumpSumPaymentApiForm mobileLumpSumPaymentApiForm) throws Exception {
		Map<String, Object> params = mobileLumpSumPaymentApiForm.createMap(mobileLumpSumPaymentApiForm);
		LOGGER.debug(params.toString());
		if(!mobileLumpSumPaymentApiForm.getOrdNoList().isEmpty()){
			params.put("ordNoList",mobileLumpSumPaymentApiForm.getOrdNoList().split(","));
		}

		List<EgovMap> searchResult = mobileLumpSumPaymentKeyInService.getCustomerOutstandingOrderDetailList(params);
	    List<MobileLumpSumPaymentApiDto> result = searchResult.stream().map(r -> MobileLumpSumPaymentApiDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(result);
	}

	@ApiOperation(value = "submissionSave", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/submissionSave", method = RequestMethod.POST)
	public ResponseEntity<MobileLumpSumPaymentApiDto> submissionSave(@RequestBody MobileLumpSumPaymentApiForm mobileLumpSumPaymentApiForm) throws Exception {
		Map<String, Object> params = mobileLumpSumPaymentApiForm.createMap(mobileLumpSumPaymentApiForm);
		LOGGER.debug(params.toString());

		Map<String, Object> searchResult = mobileLumpSumPaymentKeyInService.submissionSave(params);
		MobileLumpSumPaymentApiDto result = new MobileLumpSumPaymentApiDto();
		if(Integer.parseInt(searchResult.get("result").toString()) == 1){
			result.setResponseCode(1);
			params.putAll(searchResult);

			/*
			 * Temporary dont sent sms due to request, have to update sms message if reopen
			 */
			//mobileLumpSumPaymentKeyInService.sendSms(params);
			mobileLumpSumPaymentKeyInService.sendEmail(params);
		}
		else{
			result.setResponseCode(0);
		}
		return ResponseEntity.ok(result);
	}

	@ApiOperation(value = "updateCashMatchingInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/updateCashMatchingInfo", method = RequestMethod.POST)
	public ResponseEntity<MobileLumpSumPaymentApiDto> updateCashMatchingInfo(@RequestBody MobileLumpSumPaymentApiForm mobileLumpSumPaymentApiForm) throws Exception {
		Map<String, Object> params = mobileLumpSumPaymentApiForm.createMap(mobileLumpSumPaymentApiForm);
		LOGGER.debug(params.toString());

		int resultResponse = mobileLumpSumPaymentKeyInService.mobileUpdateCashMatchingData(params);

		MobileLumpSumPaymentApiDto result = new MobileLumpSumPaymentApiDto();
		result.setResponseCode(resultResponse);
		return ResponseEntity.ok(result);
	}

	@ApiOperation(value = "selectCashMatchingPayGroupList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectCashMatchingPayGroupList", method = RequestMethod.GET)
	public ResponseEntity<List<MobileLumpSumPaymentApiDto>> mobileSelectCashMatchingPayGroupList(@ModelAttribute MobileLumpSumPaymentApiForm mobileLumpSumPaymentApiForm) throws Exception {
		Map<String, Object> params = mobileLumpSumPaymentApiForm.createMap(mobileLumpSumPaymentApiForm);
		LOGGER.debug(params.toString());

		List<EgovMap> searchResult = mobileLumpSumPaymentKeyInService.mobileSelectCashMatchingPayGroupList(params);
		List<MobileLumpSumPaymentApiDto> result = searchResult.stream().map(r -> MobileLumpSumPaymentApiDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(result);
	}

	@ApiOperation(value = "getMobileLumpSumHistory", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/getMobileLumpSumHistory", method = RequestMethod.GET)
	public ResponseEntity<List<MobileLumpSumPaymentApiDto>> getMobileLumpSumHistory(@ModelAttribute MobileLumpSumPaymentApiForm mobileLumpSumPaymentApiForm) throws Exception {
		Map<String, Object> params = mobileLumpSumPaymentApiForm.createMap(mobileLumpSumPaymentApiForm);
		LOGGER.debug(params.toString());

		List<EgovMap> searchResult = mobileLumpSumPaymentKeyInService.getMobileLumpSumHistory(params);
		List<MobileLumpSumPaymentApiDto> result = searchResult.stream().map(r -> MobileLumpSumPaymentApiDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(result);
	}
}
