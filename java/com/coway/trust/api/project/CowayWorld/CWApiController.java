package com.coway.trust.api.project.CowayWorld;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.time.StopWatch;
import org.apache.http.HttpResponse;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.CWApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : CWApiController.java
 * @Description : TO-DO Class Description
 *
 * @HistoryselectAnotherContact
 *
 *                              <pre>
 * Date                Author         Description
 * -------------       -----------      -------------
 * 2021. 10. 27.    MY-HLTANG   First creation- API for coway world
 *                              </pre>
 */

@Api(value = "CWApiController",description = "CWApiController")
@RestController(value = "CWApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI + "/CW")
public class CWApiController {

  @Resource(name = "CWApiService")
  private CWApiService cwApiService;

  @Resource(name = "commonApiService")
  private CommonApiService commonApiService;

  @ApiOperation(value = "/memDetailsInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/memDetailsInfo", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> memDetailsInfo(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
	  EgovMap result = null;
	  /*result = commonApiService.verifyBasicAuth(request,params);
	  if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(result.get("code").toString())){
		  result = cwApiService.memDetailsInfo(request, params);
	  }*/

	  result = cwApiService.memDetailsInfo(request, params);
	  System.out.println("memDetailsInfo end");
    return ResponseEntity.ok(result);
  }

  /*@ApiOperation(value = "/memDetailsInfo1", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/memDetailsInfo1", method = RequestMethod.GET)
  public HttpResponse  memDetailsInfo1(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
	  EgovMap  response = cwApiService.memDetailsInfo(request, params);
	  request.setAttribute("Body", response);
    return  (HttpResponse) request;
  }*/

}
