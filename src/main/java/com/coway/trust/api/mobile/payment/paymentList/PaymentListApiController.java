package com.coway.trust.api.mobile.payment.paymentList;

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
import com.coway.trust.api.mobile.payment.payment.PaymentDto;
import com.coway.trust.biz.payment.payment.service.PaymentListApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : PaymentListApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 21.   KR-HAN        First creation
 * </pre>
 */
@Api(value = "payment List api", description = "payment api")
@RestController(value = "paymentListApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/paymentList")
public class PaymentListApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PaymentListApiController.class);

	@Resource(name = "paymentListApiService")
	private PaymentListApiService paymentListApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 10. 21.
	 * @param paymentListForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "Payment List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectPaymentList", method = RequestMethod.GET)
	public ResponseEntity<List<PaymentListDto>>  selectPaymentList(@ModelAttribute PaymentListForm paymentListForm) throws Exception {

       Map<String, Object> params = paymentListForm.createMap(paymentListForm);
       List<EgovMap> selectPaymentList = null;

        // 주문 조회
       selectPaymentList =paymentListApiService.selectPaymentList(params);

       List<PaymentListDto> paymentList = selectPaymentList.stream().map(r -> PaymentListDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(paymentList);
	}

}
