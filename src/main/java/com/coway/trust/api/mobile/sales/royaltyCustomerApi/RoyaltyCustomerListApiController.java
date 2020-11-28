package com.coway.trust.api.mobile.sales.royaltyCustomerApi;

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
import com.coway.trust.biz.sales.msales.OrderCustomerApiService;
import com.coway.trust.biz.sales.royaltyCustomerListApi.RoyaltyCustomerListApiService;


import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "RoyaltyCustomerListApiController", description = "RoyaltyCustomerListApiController")
@RestController(value = "RoyaltyCustomerListApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/royaltyCustomerListApi")
public class RoyaltyCustomerListApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(RoyaltyCustomerListApiController.class);

	@Resource(name = "RoyaltyCustomerListApiService")
	private RoyaltyCustomerListApiService royaltyCustomerListApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "selectWsLoyaltyList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectWsLoyaltyList", method = RequestMethod.GET)
	public ResponseEntity<List<RoyaltyCustomerListApiDto>> selectWsLoyaltyList() throws Exception {
		List<EgovMap> selectWsLoyaltyList = royaltyCustomerListApiService.selectWsLoyaltyList();



		if(LOGGER.isDebugEnabled()){
			for (int i = 0; i < selectWsLoyaltyList.size(); i++) {
				LOGGER.debug("selectWsLoyaltyList    값 : {}", selectWsLoyaltyList.get(i));
			}
		}
		return ResponseEntity.ok(selectWsLoyaltyList.stream().map(r -> RoyaltyCustomerListApiDto.create(r)).collect(Collectors.toList()));
	}

}
