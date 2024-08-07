package com.coway.trust.api.mobile.organization.courseApi;

import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.courseApi.CourseApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : CourseApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "CourseApiController", description = "CourseApiController")
@RestController(value = "CourseApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/courseApi")
public class CourseApiController {



	private static final Logger LOGGER = LoggerFactory.getLogger(CourseApiController.class);



	@Resource(name = "CourseApiService")
	private CourseApiService courseApiService;



	@ApiOperation(value = "selectCourse", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectCourse", method = RequestMethod.GET)
	public ResponseEntity<List<CourseApiDto>> selectCourse(@ModelAttribute CourseApiForm param) throws Exception {
		List<EgovMap> selectCourse = courseApiService.selectCourse(param);
		if(LOGGER.isDebugEnabled()){
			for (int i = 0; i < selectCourse.size(); i++) {
				LOGGER.debug("selectCourse    값 : {}", selectCourse.get(i));
			}
		}
		return ResponseEntity.ok(selectCourse.stream().map(r -> CourseApiDto.create(r)).collect(Collectors.toList()));
	}



	@ApiOperation(value = "saveCourse", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/saveCourse", method = RequestMethod.POST)
	public void saveCourse(@RequestBody CourseApiForm param) throws Exception {
		courseApiService.saveCourse(param);
	}
}