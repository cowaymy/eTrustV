package com.coway.trust.api.mobile.payment.payment;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.payment.service.PaymentApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : PaymentApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 30.   KR-HAN        First creation
 * </pre>
 */
@Api(value = "payment api", description = "payment api")
@RestController(value = "paymentApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/payment")
public class PaymentApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PaymentApiController.class);

	@Resource(name = "paymentApiService")
	private PaymentApiService paymentApiService;

	@Resource(name = "commonPaymentService")
	private CommonPaymentService commonPaymentService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 9. 30.
	 * @param paymentForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "Payment List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectPaymentList", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectPaymentList(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

        // 주문 조회
       selectPaymentList = paymentApiService.selectPaymentList(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}


	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 10. 9.
	 * @param paymentForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "selectPayment Detail List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectPaymentDetailList", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectPaymentDetailList(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

       List<EgovMap> resultList = commonPaymentService.selectOrderInfoRental(params);

       if( resultList.size() > 0 ){
    	   double rpf =  (double) resultList.get(0).get("rpf");
           double rpfPaid =  (double) resultList.get(0).get("rpfPaid");

           String excludeRPF = (rpf > 0 && rpfPaid >= rpf) ? "N" : "Y";
           if (rpf == 0) excludeRPF = "N";

           params.put("excludeRPF", excludeRPF);
       }

        // 주문 상세 조회
//       selectPaymentList = pymentApiService.selectPaymentDetailList(params);
       selectPaymentList = commonPaymentService.selectBillInfoRental(params);

       SimpleDateFormat original_format = new SimpleDateFormat("yyyy-MM-dd");
       SimpleDateFormat new_format = new SimpleDateFormat("dd/MM/yy");

       for (int i = 0; i < selectPaymentList.size(); i++) {
    	   EgovMap map = selectPaymentList.get(i);

           Date original_date = original_format.parse( (String) map.get("billDt"));

           // 날짜 형식을 원하는 타입으로 변경한다.
           String new_date = new_format.format(original_date);

           map.put("billDt", new_date);
	}

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}


	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 10. 14.
	 * @param paymentForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "select Mega Deal By Order Id", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectMegaDealByOrderId", method = RequestMethod.GET)
	public ResponseEntity<PaymentDto>  selectMegaDealByOrderId(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       EgovMap resultMap = null;

        //
       resultMap = paymentApiService.selectMegaDealByOrderId(params);

       if(resultMap == null || resultMap.get("megaDeal") == null){
			resultMap = new EgovMap();
			resultMap.put("megaDeal",0);
		}

       return ResponseEntity.ok(PaymentDto.create(resultMap));
	}

	 /**
	 * selectBillInfoRental
	 * @Author KR-HAN
	 * @Date 2019. 10. 14.
	 * @param paymentForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "select Bill Info Rental", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectBillInfoRental", method = RequestMethod.GET)
	public ResponseEntity<PaymentDto>  selectBillInfoRental(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       EgovMap resultMap = null;
        //
       resultMap = paymentApiService.selectBillInfoRental(params);

       return ResponseEntity.ok(PaymentDto.create(resultMap));
	}

	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 10. 15.
	 * @param paymentForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "select Sales Notification Infol", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectSalesNotificationInfo", method = RequestMethod.GET)
	public ResponseEntity<PaymentDto>  selectSalesNotificationInfo(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       EgovMap resultMap = null;
        //
       resultMap = paymentApiService.selectSalesNotificationInfo(params);

       return ResponseEntity.ok(PaymentDto.create(resultMap));
	}


	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 10. 15.
	 * @param paymentForm
	 * @throws Exception
	 */
	@ApiOperation(value = "Save Sales Notification", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/saveSalesNotification", method = RequestMethod.POST)
	public void saveSalesNotification(@RequestBody PaymentForm  paymentForm) throws Exception {
		paymentApiService.insertSalesNotification(paymentForm);
	}


	@ApiOperation(value = "Bank Select Box", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectBankSelectBox", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectBankSelectBox(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

    // 조회.
       selectPaymentList = paymentApiService.selectBankSelectBox(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}


	@ApiOperation(value = "Card Mode Box", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectCardModeBox", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectCardModeBox(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

    // 조회.
       selectPaymentList = paymentApiService.selectCardModeBox(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}

	@ApiOperation(value = "selectMerchantBankOn2708", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectMerchantBankOn2708", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectMerchantBankOn2708(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

    // 조회.
       selectPaymentList = paymentApiService.selectMerchantBankOn2708(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}

	@ApiOperation(value = "selectMerchantBankOn2709", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectMerchantBankOn2709", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectMerchantBankOn2709(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

    // 조회.
       selectPaymentList = paymentApiService.selectMerchantBankOn2709(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}

	@ApiOperation(value = "selectMerchantBankOn2710", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectMerchantBankOn2710", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectMerchantBankOn2710(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

    // 조회.
       selectPaymentList = paymentApiService.selectMerchantBankOn2710(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}

	@ApiOperation(value = "selectMerchantBankOn2711", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectMerchantBankOn2711", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectMerchantBankOn2711(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

    // 조회.
       selectPaymentList = paymentApiService.selectMerchantBankOn2711(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}

	@ApiOperation(value = "selectMerchantBankOn2712", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectMerchantBankOn2712", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectMerchantBankOn2712(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

    // 조회.
       selectPaymentList = paymentApiService.selectMerchantBankOn2712(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}

	@ApiOperation(value = "selectIssueBankOn2710", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectIssueBankOn2710", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectIssueBankOn2710(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

    // 조회.
       selectPaymentList = paymentApiService.selectIssueBankOn2710(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}

	@ApiOperation(value = "selectIssueBankOn2712", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectIssueBankOn2712", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectIssueBankOn2712(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

    // 조회.
       selectPaymentList = paymentApiService.selectIssueBankOn2712(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}

	@ApiOperation(value = "selectIssueBankOnDefault", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectIssueBankOnDefault", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentDto>>  selectIssueBankOnDefault(@ModelAttribute PaymentForm paymentForm) throws Exception {

       Map<String, Object> params = paymentForm.createMap(paymentForm);
       List<EgovMap> selectPaymentList = null;

    // 조회.
       selectPaymentList = paymentApiService.selectIssueBankOnDefault(params);

       List<PaymentDto> paymentList = selectPaymentList.stream().map(r -> PaymentDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}
}
