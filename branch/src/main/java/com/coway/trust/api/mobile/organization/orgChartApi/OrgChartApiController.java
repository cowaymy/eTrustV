package com.coway.trust.api.mobile.organization.orgChartApi;

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
import com.coway.trust.biz.organization.orgChartApi.OrgChartApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : OrgChartApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 5.   KR-JAEMJAEM:)        First creation
 * </pre>
 */
@Api(value = "OrgChartApiController", description = "OrgChartApiController")
@RestController(value = "OrgChartApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/orgChartApi")
public class OrgChartApiController {



	private static final Logger LOGGER = LoggerFactory.getLogger(OrgChartApiController.class);



	@Resource(name = "OrgChartApiService")
	private OrgChartApiService orgChartApiService;



	@ApiOperation(value = "selectOrgChart", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectOrgChart", method = RequestMethod.GET)
	public ResponseEntity<List<OrgChartApiDto>> selectOrgChart(@ModelAttribute OrgChartApiForm param) throws Exception {
		List<EgovMap> selectOrgChart = orgChartApiService.selectOrgChart(param);
		if(LOGGER.isDebugEnabled()){
			for (int i = 0; i < selectOrgChart.size(); i++) {
				LOGGER.debug("courseList    값 : {}", selectOrgChart.get(i));
			}
		}
		return ResponseEntity.ok(selectOrgChart.stream().map(r -> OrgChartApiDto.create(r)).collect(Collectors.toList()));
	}
}
