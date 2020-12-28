package com.coway.trust.api.project.eCommerce;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.EcommApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

import javax.annotation.Resource;


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

  @ApiOperation(value = "/checkOrdStus", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/checkOrdStus", method = RequestMethod.GET)
  public ResponseEntity<EComApiDto> checkOrdStus(@ModelAttribute EComApiForm params) throws Exception {
    return ResponseEntity.ok(eCommApiService.checkOrderStatus(params));
  }

  @ApiOperation(value = "/isCardExists", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/isCardExists", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> isCardExists(@ModelAttribute EComApiForm params) throws Exception {
    return ResponseEntity.ok(eCommApiService.isCardExists(params));
  }

}
