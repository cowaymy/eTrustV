package com.coway.trust.api.mobile.payment.eGhlPaymentCollection;

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
import com.coway.trust.biz.payment.eGhlPaymentCollection.service.EGhlPaymentCollectionService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : EPaymentCollectionApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2022.11.08	  MY.FRANGO First creation
 * </pre>
 */

@Api(value = "eGhlPaymentCollection api", description = "eGhlPaymentCollection api")
@RestController(value = "eGhlPaymentCollectionApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/eghlpaymentcollection")
public class EGhlPaymentCollectionApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EGhlPaymentCollectionApiController.class);

	@Resource(name="eGhlPaymentCollectionService")
	private EGhlPaymentCollectionService eGhlPaymentCollectionService;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	@ApiOperation(value = "orderNumberBillSearch", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/orderNumberBillSearch", method = RequestMethod.GET)
	public ResponseEntity<List<EGhlPaymentCollectionApiDto>> orderNumberBillSearch(@ModelAttribute EGhlPaymentCollectionApiForm eGhlPaymentCollectionApiForm) throws Exception {
		Map<String, Object> params = eGhlPaymentCollectionApiForm.createMap(eGhlPaymentCollectionApiForm);
		List<EgovMap> orderResult = eGhlPaymentCollectionService.orderNumberBillMobileSearch(params);

	     List<EGhlPaymentCollectionApiDto> orderListResult = orderResult.stream().map(r -> EGhlPaymentCollectionApiDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(orderListResult);
	}
}
