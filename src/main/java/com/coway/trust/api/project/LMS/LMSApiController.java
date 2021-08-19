package com.coway.trust.api.project.LMS;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.LMSApiService;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.json.HTTP;
import org.json.JSONObject;

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

@Api(value = "LMSApiController",description = "LMSApiController")
@RestController(value = "LMSApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI + "/LMS")
public class LMSApiController {

  @Resource(name = "LMSApiService")
  private LMSApiService lmsApiService;

  @ApiOperation(value = "/insertCourse", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/insertCourse", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> insertCourse(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
    return ResponseEntity.ok(lmsApiService.insertCourse(request, params));
  }

  @ApiOperation(value = "/updateCourse", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/updateCourse", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> updateCourse(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
    return ResponseEntity.ok(lmsApiService.updateCourse(request, params));
  }

  @ApiOperation(value = "/updateCourseAttend", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/updateCourseAttend", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> updateCourseAttend(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
    return ResponseEntity.ok(lmsApiService.updateCourseAttend(request, params));
  }

  @ApiOperation(value = "/updateAttendResult", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/updateAttendResult", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> updateAttendResult(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
    return ResponseEntity.ok(lmsApiService.updateAttendResult(request, params));
  }

}
