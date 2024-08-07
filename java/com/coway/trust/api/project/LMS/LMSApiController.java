package com.coway.trust.api.project.LMS;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.time.StopWatch;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.LMSApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : CommonApiController.java
 * @Description : TO-DO Class Description
 *
 * @HistoryselectAnotherContact
 *
 *                              <pre>
 * Date                Author         Description
 * -------------       -----------      -------------
 * 2021. 08. 19.    MY-HLTANG   First creation
 *                              </pre>
 */

@Api(value = "LMSApiController",description = "LMSApiController")
@RestController(value = "LMSApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI + "/LMS")
public class LMSApiController {

  @Resource(name = "LMSApiService")
  private LMSApiService lmsApiService;

  @Resource(name = "commonApiService")
  private CommonApiService commonApiService;

  @ApiOperation(value = "/insertCourse", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/insertCourse", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> insertCourse(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
    return ResponseEntity.ok(lmsApiService.insertCourse(request, params));
//    return ResponseEntity.ok(null);
  }

  @ApiOperation(value = "/updateCourse", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/updateCourse", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> updateCourse(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
    return ResponseEntity.ok(lmsApiService.updateCourse(request, params));
//	    return ResponseEntity.ok(null);
  }

  @ApiOperation(value = "/updateCourseAttend", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/updateCourseAttend", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> updateCourseAttend(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
    //return ResponseEntity.ok(lmsApiService.updateCourseAttend(request, params));
	  String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0",sysUserId = "0";

	  StopWatch stopWatch = new StopWatch();
	  EgovMap rtn = commonApiService.rtnRespMsg(request, code, message, respTm, params, null ,apiUserId);
	  try {
		  stopWatch.reset();
		  stopWatch.start();

		  rtn = lmsApiService.updateCourseAttend(request, params);

	  } catch (Exception e){

	  } finally {
		  stopWatch.stop();
	      respTm = stopWatch.toString();
	  }

	  return ResponseEntity.ok(rtn);
//	    return ResponseEntity.ok(null);


  }

  @ApiOperation(value = "/updateAttendResult", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/updateAttendResult", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> updateAttendResult(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
    return ResponseEntity.ok(lmsApiService.updateAttendResult(request, params));
//	    return ResponseEntity.ok(null);
  }

}
