package com.coway.trust.api.mobile.common;

import java.util.List;
import java.util.Map;
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
import com.coway.trust.biz.common.mobileMenu.MobileMenuApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : MobileMenuApiController.java
 * @Description : MobileMenuApiController
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 1.   KR-HAN        First creation
 * </pre>
 */
@Api(value = "mobile menu api", description = "mobile menu api")
@RestController(value = "MobileMenuApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/mobileMenu")
public class MobileMenuApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MobileMenuApiController.class);

	@Resource(name = "mobileMenuApiService")
	private MobileMenuApiService mobileMenuApiService;

	 /**
	 * selectMobileMenuList
	 * @Author KR-HAN
	 * @Date 2019. 11. 1.
	 * @param mobileMenuApiForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "Mobile Menu List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectMobileMenuList", method = RequestMethod.GET)
	public ResponseEntity<List<MobileMenuApiDto>>  selectMobileMenuList(@ModelAttribute MobileMenuApiForm mobileMenuApiForm) throws Exception {

       Map<String, Object> params = mobileMenuApiForm.createMap(mobileMenuApiForm);
       List<EgovMap> selectMobileMenuList = null;

       selectMobileMenuList =mobileMenuApiService.selectMobileMenuList(params);

       List<MobileMenuApiDto> mobileMenuList = selectMobileMenuList.stream().map(r -> MobileMenuApiDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(mobileMenuList);
	}

}
