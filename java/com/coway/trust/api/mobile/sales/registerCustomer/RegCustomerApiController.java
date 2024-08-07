package com.coway.trust.api.mobile.sales.registerCustomer;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.msales.OrderCustomerApiService;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "sales api", description = "sales api")
@RestController(value = "regCustomerApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/sales")
public class RegCustomerApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(RegCustomerApiController.class);
	
	@Resource(name = "OrderCustomerApiService")
	private OrderCustomerApiService orderCustomerApiService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "Customer Register", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/regcustomer", method = RequestMethod.POST)
	public void registerCustomer(@RequestBody RegCustomerForm regCustomerForm) throws Exception{
		orderCustomerApiService.insertCustomer(regCustomerForm);
	}
}
