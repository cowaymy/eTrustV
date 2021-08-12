package com.coway.trust.api.mobile.sales.registerPreOrder;

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
import com.coway.trust.biz.sales.msales.OrderApiService;
import com.coway.trust.cmmn.model.SessionVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "sales api", description = "sales api")
@RestController(value = "regPreOrderApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/sales")
public class RegPreOrderApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(RegPreOrderApiController.class);

	@Resource(name = "OrderApiService")
	private OrderApiService orderApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "Pre-Order Register", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/regpreorder", method = RequestMethod.POST)
	public void registerPreorder(@RequestBody RegPreOrderForm  regPreOrderForm) throws Exception {
		orderApiService.insertPreOrder(regPreOrderForm);		
	}

}
