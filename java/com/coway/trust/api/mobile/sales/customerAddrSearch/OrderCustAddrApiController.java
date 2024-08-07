package com.coway.trust.api.mobile.sales.customerAddrSearch;

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
import com.coway.trust.biz.sales.msales.OrderCustAddrApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "sales api", description = "sales api")
@RestController(value = "OrderCustAddrApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/sales")
public class OrderCustAddrApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(OrderCustAddrApiController.class);
	
	@Resource(name = "OrderCustAddrApiService")
	private OrderCustAddrApiService orderCustAddrApiService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@ApiOperation(value = "Order Address Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/customer/address", method = RequestMethod.GET)
	public ResponseEntity<List<OrderCustAddrDto>> orderCustAddressList(
			@ModelAttribute OrderCustAddrForm orderCustAddrForm) throws Exception {
		
		Map<String, Object> params = OrderCustAddrForm.createMap(orderCustAddrForm);
		List<EgovMap> custAddress = orderCustAddrApiService.orderCustAddressList(params);
		List<OrderCustAddrDto> custAddrList = custAddress.stream().map(r -> OrderCustAddrDto.create(r)).collect(Collectors.toList());
		
		return ResponseEntity.ok(custAddrList);
	}

}
