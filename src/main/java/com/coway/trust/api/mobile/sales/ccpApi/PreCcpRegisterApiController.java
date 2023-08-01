package com.coway.trust.api.mobile.sales.ccpApi;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiForm;
import com.coway.trust.biz.sales.ccp.PreCcpRegisterService;
import com.coway.trust.biz.sales.ccpApi.PreCcpRegisterApiService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : PreCcpRegisterApiController.java
 * @Description : TO-DO Class Description
 *
 */

@Api(value = "PreCcpRegisterApiController", description = "PreCcpRegisterApiController")
@RestController(value = "PreCcpRegisterApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/ccpApi")
public class PreCcpRegisterApiController {

  @Autowired
  private SessionHandler sessionHandler;

  private static final Logger LOGGER = LoggerFactory.getLogger(PreCcpRegisterApiController.class);

  @Resource(name = "PreCcpRegisterApiService")
  private PreCcpRegisterApiService preCcpRegisterApiService;

  @Resource(name = "preCcpRegisterService")
  private PreCcpRegisterService preCcpRegisterService;

  @ApiOperation(value = "checkPreCcpResult", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/checkPreCcpResult", method = RequestMethod.GET)
  public ResponseEntity<List<PreCcpRegisterApiDto>> checkPreCcpResult(@ModelAttribute PreCcpRegisterApiForm param) throws Exception {

	  List<EgovMap> preCcpResult = preCcpRegisterApiService.checkPreCcpResult(param);

	  if(preCcpResult != null){
		  	Map<String, Object> detailsMap = new HashMap<String, Object>();
		  	detailsMap.put("customerNric", param.getSelectKeyword());
		  	detailsMap.put("userId", preCcpResult.get(0).get("userId"));
		  	detailsMap.put("custId", preCcpResult.get(0).get("custId"));
		  	detailsMap.put("chsStatus", preCcpResult.get(0).get("chsStatus"));
		  	detailsMap.put("chsRsn", preCcpResult.get(0).get("chsRsn"));
		  	detailsMap.put("customerType", 7289);
			int result = preCcpRegisterService.insertPreCcpSubmission(detailsMap);
	  }

      if (LOGGER.isDebugEnabled()) {
          for (int i = 0; i < preCcpResult.size(); i++) {
            LOGGER.debug("preCcpResult    값 : {}", preCcpResult.get(i));
          }
      }

      return ResponseEntity.ok(preCcpResult.stream().map(r -> PreCcpRegisterApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "searchOrderSummaryList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/searchOrderSummaryList", method = RequestMethod.GET)
  public ResponseEntity<List<PreCcpRegisterApiDto>> searchOrderSummaryList(@ModelAttribute PreCcpRegisterApiForm param) throws Exception {

	  List<EgovMap> orderSummary = preCcpRegisterApiService.searchOrderSummaryList(param);

      if (LOGGER.isDebugEnabled()) {
          for (int i = 0; i < orderSummary.size(); i++) {
            LOGGER.debug("orderSummary    값 : {}", orderSummary.get(i));
          }
      }

      return ResponseEntity.ok(orderSummary.stream().map(r -> PreCcpRegisterApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "chkExistCust", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/chkExistCust", method = RequestMethod.GET)
  public ResponseEntity <ReturnMessage> chkExistCust(@RequestParam Map<String, Object>params) {

	   ReturnMessage message = new ReturnMessage();
	   EgovMap getExistCustomer = preCcpRegisterService.getExistCustomer(params);
	   EgovMap getRegisteredCust = preCcpRegisterService.getRegisteredCust(params);

	   message.setCode((getExistCustomer == null && getRegisteredCust ==null) ? AppConstants.FAIL : AppConstants.SUCCESS);
	   return ResponseEntity.ok(message);
  }

//  @ApiOperation(value = "savePreCcp", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
//  @RequestMapping(value = "/savePreCcp", method = RequestMethod.POST)
//  public ResponseEntity<PreCcpRegisterApiForm> savePreCcp(@RequestBody PreCcpRegisterApiForm param) throws Exception {
//    return ResponseEntity.ok(preCcpRegisterApiService.savePreCcp(param));
//  }


}
