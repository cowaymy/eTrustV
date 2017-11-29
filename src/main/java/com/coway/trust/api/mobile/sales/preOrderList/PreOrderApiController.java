package com.coway.trust.api.mobile.sales.preOrderList;

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
import com.coway.trust.biz.sales.msales.OrderApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "sales api", description = "sales api")
@RestController(value = "PreOrderApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/sales")
public class PreOrderApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PreOrderApiController.class);
	
	@Resource(name = "OrderApiService")
	private OrderApiService orderApiService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@ApiOperation(value = "Pre Order List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/preorder", method = RequestMethod.GET)
	public ResponseEntity<List<PreOrderDto>> orderAddressList(@ModelAttribute PreOrderForm preOrderForm) throws Exception {

		Map<String, Object> params = PreOrderForm.createMap(preOrderForm);
		List<EgovMap> preOrder = orderApiService.preOrderList(params);
		List<PreOrderDto> preOrderList = preOrder.stream().map(r -> PreOrderDto.create(r)).collect(Collectors.toList());
				
		return ResponseEntity.ok(preOrderList);
	}
}
