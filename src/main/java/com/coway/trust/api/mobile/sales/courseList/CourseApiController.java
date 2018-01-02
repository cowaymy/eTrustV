package com.coway.trust.api.mobile.sales.courseList;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.orderPromotionList.OrderPromotionDto;
import com.coway.trust.biz.sales.msales.CourseApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "course api", description = "course api")
@RestController(value = "CourseApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/course")
public class CourseApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CourseApiController.class);
	
	@Resource(name = "CourseApiService")
	private CourseApiService courseApiService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@ApiOperation(value = "Course List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/courselist", method = RequestMethod.GET)
	public ResponseEntity<List<CourseDto>> courseList(@ModelAttribute CourseForm courseForm) throws Exception {

		Map<String, Object> params = courseForm.createMap(courseForm);
		
		EgovMap memInfo = courseApiService.memInfo(params);
		
		params.put("memType", memInfo.get("memType"));
		
		List<EgovMap> course = courseApiService.courseList(params);
		
		for(EgovMap obj : course){

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("memId", memInfo.get("memId"));
			param.put("courseId", obj.get("courseId"));

			EgovMap courseMemInfo = courseApiService.courseMemInfo(param);
			
			if("2361".equals(obj.get("coursAttendOwner").toString())){
					
				if( courseMemInfo != null ){
					if("8".equals(courseMemInfo.get("coursMemStusId").toString() )){
	    				obj.put("courseStatus", "1");
	    			}else if("1".equals(courseMemInfo.get("coursMemStusId").toString() )){
						obj.put("courseStatus", "2");
					}
				}else{					
					obj.put("courseStatus", "1");
				}
    			
			}else if("2315".equals(obj.get("coursAttendOwner").toString())){
				if( courseMemInfo != null ){
					if("8".equals(courseMemInfo.get("coursMemStusId").toString() )){
	    				obj.put("courseStatus", "4");
	    			}else if("1".equals(courseMemInfo.get("coursMemStusId").toString() )){
						obj.put("courseStatus", "3");
					}					
				}else{
					obj.put("courseStatus", "4");
				}
			}
			
			if(Integer.parseInt(obj.get("courseJoinCnt").toString()) >= Integer.parseInt(obj.get("courseLimit").toString())){
				obj.put("courseStatus", "4");
			}
		
		}
		
		List<CourseDto> courseList = course.stream().map(r -> CourseDto.create(r)).collect(Collectors.toList());
				
		return ResponseEntity.ok(courseList);
	}
}
