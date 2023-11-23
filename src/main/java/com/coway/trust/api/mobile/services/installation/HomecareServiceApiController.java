/*package com.coway.trust.api.mobile.services.installation;

import java.util.HashMap;
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
import com.coway.trust.api.mobile.logistics.stockAudit.StockAuditApiDto;
import com.coway.trust.api.mobile.logistics.stockAudit.StockAuditApiFormDto;
import com.coway.trust.api.mobile.payment.groupOrder.GroupOrderForm;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.api.mobile.sales.salesDashboardApi.SalesDashboardApiDto;
import com.coway.trust.api.mobile.sales.salesDashboardApi.SalesDashboardApiForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDto;
import com.coway.trust.api.mobile.services.as.AfterServiceResultForm;
import com.coway.trust.biz.sales.msales.OrderCustomerApiService;
import com.coway.trust.biz.sales.royaltyCustomerListApi.RoyaltyCustomerListApiService;
import com.coway.trust.biz.services.homecareServiceApi.HomecareServiceApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "HomecareServiceApiController", description = "HomecareServiceApiController")
@RestController(value = "HomecareServiceApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/royaltyCustomerListApi")
public class HomecareServiceApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(HomecareServiceApiController.class);

	@Resource(name = "HomecareServiceApiService")
	private HomecareServiceApiService homecareServiceApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;


	 @ApiOperation(value = "selectPartnerCode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	    @RequestMapping(value = "/selectPartnerCode", method = RequestMethod.GET)
	    public ResponseEntity<List<HomecareServiceApiDto>> selectPartnerCode(@ModelAttribute HomecareServiceApiForm param) throws Exception {
	        List<EgovMap>  selectPartnerCode = homecareServiceApiService.selectPartnerCode(param);
	        if(LOGGER.isErrorEnabled()){
	            for (int i = 0; i < selectPartnerCode.size(); i++) {
	                    LOGGER.debug("selectPartnerCode    값 : {}", selectPartnerCode.get(i));
	            }
	        }
	        return ResponseEntity.ok(selectPartnerCode.stream().map(r -> HomecareServiceApiDto.create(r)).collect(Collectors.toList()));
	    }
	 }*/