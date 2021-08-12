package com.coway.trust.api.project.common;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.CommonApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

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

@Api(value = "CommonApiController",description = "CommonApiController")
@RestController(value = "CommonApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI)
public class CommonApiController {

  @Resource(name = "commonApiService")
  private CommonApiService commonApiService;

  @ApiOperation(value = "checkAccess", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/checkAccess", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkAccess(HttpServletRequest request,@ModelAttribute CommonApiForm params) throws Exception {
    return ResponseEntity.ok(commonApiService.checkAccess(request,params));
  }

}
