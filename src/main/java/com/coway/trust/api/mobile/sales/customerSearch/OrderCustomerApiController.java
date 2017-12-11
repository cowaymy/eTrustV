package com.coway.trust.api.mobile.sales.customerSearch;

import java.util.Map;

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
import com.coway.trust.biz.sales.msales.OrderCustomerApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "sales api", description = "sales api")
@RestController(value = "OrderCustomerApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/sales")
public class OrderCustomerApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(OrderCustomerApiController.class);
	
	@Resource(name = "OrderCustomerApiService")
	private OrderCustomerApiService orderCustomerApiService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@ApiOperation(value = "Order Customer Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/customer", method = RequestMethod.GET)
	public ResponseEntity<OrderCustomerDto> orderCustomerInfo(
			@ModelAttribute OrderCustomerForm orderCustomerForm) throws Exception {
		
		Map<String, Object> params = OrderCustomerForm.createMap(orderCustomerForm);
		EgovMap orderCustomerInfo = orderCustomerApiService.orderCustInfo(params);
		OrderCustomerDto dto = OrderCustomerDto.create(orderCustomerInfo);
		
		return ResponseEntity.ok(dto);
	}

}
