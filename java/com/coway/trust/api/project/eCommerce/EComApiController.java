package com.coway.trust.api.project.eCommerce;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.EcommApiService;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


/**
 * @ClassName : CommonApiController.java
 * @Description : TO-DO Class Description
 *
 * @HistoryselectAnotherContact
 *
 *                              <pre>
 * Date                Author         Description
 * -------------       -----------      -------------
 * 2020. 12. 16.    MY-KAHKIT   First creation
 *                              </pre>
 */

@Api(value = "EComApiController",description = "EComApiController")
@RestController(value = "EComApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI + "/eComm")
public class EComApiController {

  @Resource(name = "eCommApiService")
  private EcommApiService eCommApiService;

  @ApiOperation(value = "/registerOrder", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/registerOrder", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> registerOrd(HttpServletRequest request,@ModelAttribute EComApiForm params) throws Exception {
    return ResponseEntity.ok(eCommApiService.registerOrder(request, params));
  }

  @ApiOperation(value = "/checkOrdStatus", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/checkOrdStatus", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkOrdStus(HttpServletRequest request,@ModelAttribute EComApiForm params) throws Exception {
    return ResponseEntity.ok(eCommApiService.checkOrderStatus(request, params));
  }

  @ApiOperation(value = "/cardDiffNRIC", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/cardDiffNRIC", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> cardDiffNRIC(HttpServletRequest request,@ModelAttribute EComApiForm params) throws Exception {
    return ResponseEntity.ok(eCommApiService.cardDiffNRIC(request, params));
  }

  @ApiOperation(value = "/insertNewAddr", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/insertNewAddr", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> insertNewAddr(HttpServletRequest request,@ModelAttribute EComApiForm params) throws Exception {
    return ResponseEntity.ok(eCommApiService.insertNewAddr(request, params));
  }

  @ApiOperation(value = "/cancelOrder", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/cancelOrder", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> cancelOrder(HttpServletRequest request,@ModelAttribute EComApiForm params) throws Exception {
    return ResponseEntity.ok(eCommApiService.cancelOrder(request, params));
  }

  @ApiOperation(value = "/getCustomerCategory", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/getCustomerCategory", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> getCustomerCategory(HttpServletRequest request,@ModelAttribute EComApiCustCatForm params) throws Exception {
	  return ResponseEntity.ok(eCommApiService.getCustomerCategory(request, params));
  }
}
