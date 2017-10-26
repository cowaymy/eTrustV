package com.coway.trust.api.mobile.sales.orderAddrSearch;

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
import com.coway.trust.api.mobile.sales.orderAddrSearch.OrderAddressDto;
import com.coway.trust.api.mobile.sales.orderAddrSearch.OrderAddressForm;
import com.coway.trust.biz.sales.msales.OrderAddressApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "sales api", description = "sales api")
@RestController(value = "OrderAddressApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/sales")
public class OrderAddressApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(OrderAddressApiController.class);
	
	@Resource(name = "OrderAddressApiService")
	private OrderAddressApiService OrderAddressApiService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@ApiOperation(value = "Order Address Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/address", method = RequestMethod.GET)
	public ResponseEntity<List<OrderAddressDto>> orderAddressList(
			@ModelAttribute OrderAddressForm orderAddressForm) throws Exception {

		Map<String, Object> params = OrderAddressForm.createMap(orderAddressForm);
		List<EgovMap> address = OrderAddressApiService.orderAddressList(params);
		List<OrderAddressDto> addrList = address.stream().map(r -> OrderAddressDto.create(r)).collect(Collectors.toList());
		
		
		return ResponseEntity.ok(addrList);
	}
}
