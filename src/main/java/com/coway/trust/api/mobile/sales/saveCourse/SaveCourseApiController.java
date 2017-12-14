package com.coway.trust.api.mobile.sales.saveCourse;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.msales.CourseApiService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "course api", description = "course api")
@RestController(value = "saveCourseApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/course")
public class SaveCourseApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(SaveCourseApiController.class);

	@Resource(name = "CourseApiService")
	private CourseApiService courseApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "Save Course", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void saveCourse(@RequestBody SaveCourseForm  saveCourseForm) throws Exception {
		courseApiService.saveCourse(saveCourseForm);		
	}

}
