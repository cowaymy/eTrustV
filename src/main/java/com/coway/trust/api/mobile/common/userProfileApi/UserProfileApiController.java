package com.coway.trust.api.mobile.common.userProfileApi;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.services.serviceMileage.ServiceMileageForm;
import com.coway.trust.biz.common.userProfileApi.UserProfileApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : UserProfileApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 11. 01.   KR-JAEMJAEM:)   First creation
 * 2023. 03. 30    MY-ONGHC         ADD BUSINESS CARD FEATURE
 * 2023. 09. 05    MY-ONGHC         ADD E-TAG FEATURE
 * </pre>
 */
@Api(value = "UserProfileApiController", description = "UserProfileApiController")
@RestController(value = "UserProfileApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/userProfileApi")
public class UserProfileApiController {

  @Resource(name = "UserProfileApiService")
  private UserProfileApiService userProfileApiService;

  @ApiOperation(value = "selectUserProfile", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectUserProfile", method = RequestMethod.GET)
  public ResponseEntity<UserProfileApiDto> selectUserProfile(@ModelAttribute UserProfileApiForm param) throws Exception {
    return ResponseEntity.ok(userProfileApiService.selectUserProfile(param));
  }

  @ApiOperation(value = "selectUserRole", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectUserRole", method = RequestMethod.GET)
  public ResponseEntity<UserProfileApiDto> selectUserRole(@ModelAttribute UserProfileApiForm param) throws Exception {
    return ResponseEntity.ok(userProfileApiService.selectUserRole(param));
  }

  @ApiOperation(value = "selectProfileImg", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectProfileImg", method = RequestMethod.GET)
  public ResponseEntity<UserProfileApiDto> selectProfileImg(@ModelAttribute UserProfileApiForm param) throws Exception {
    return ResponseEntity.ok(userProfileApiService.selectProfileImg(param));
  }

  @ApiOperation(value = "updateParticular", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/updateParticular", method = RequestMethod.POST)
  public ResponseEntity<List<EgovMap>> updateParticular(@RequestBody Map<String, Object> params) throws Exception {
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>IN");
    return ResponseEntity.ok(userProfileApiService.updateParticular(params));
  }
}
