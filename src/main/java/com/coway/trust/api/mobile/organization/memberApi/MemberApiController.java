package com.coway.trust.api.mobile.organization.memberApi;

import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.memberApi.MemberApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : MemberApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 09.    KR-JAEMJAEM:)   First creation
 * 2020. 04. 09.    MY-ONGHC         Restructure Messy Code
 *          </pre>
 */
@Api(value = "MemberApiController", description = "MemberApiController")
@RestController(value = "MemberApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/memberApi")
public class MemberApiController {

  private static final Logger LOGGER = LoggerFactory.getLogger(MemberApiController.class);

  @Resource(name = "MemberApiService")
  private MemberApiService memberApiService;

  @ApiOperation(value = "selectMemberList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectMemberList", method = RequestMethod.GET)
  public ResponseEntity<List<MemberApiDto>> selectMemberList(@ModelAttribute MemberApiForm param) throws Exception {
    List<EgovMap> selectMemberList = memberApiService.selectMemberList(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selectMemberList.size(); i++) {
        LOGGER.debug("selectMemberList    값 : {}", selectMemberList.get(i));
      }
    }
    return ResponseEntity.ok(selectMemberList.stream().map(r -> MemberApiDto.create(r)).collect(Collectors.toList()));
  }
}
