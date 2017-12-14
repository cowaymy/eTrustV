package com.coway.trust.biz.sales.msales.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.sales.registerPreOrder.RegPreOrderForm;
import com.coway.trust.api.mobile.sales.saveCourse.SaveCourseForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.sales.msales.CourseApiService;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("CourseApiService")
public class CourseApiServiceImpl extends EgovAbstractServiceImpl implements CourseApiService{

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "CourseApiMapper")
	private CourseApiMapper CourseApiMapper;
	
	@Autowired
	private LoginMapper loginMapper;
	
	@Override
	public List<EgovMap> courseList(Map<String, Object> params) {
		return CourseApiMapper.courseList(params);
	}

	@Override
	public EgovMap courseMemInfo(Map<String, Object> param) {
		return CourseApiMapper.courseMemInfo(param);
	}

	@Override
	public EgovMap memInfo(Map<String, Object> params) {
		return CourseApiMapper.memInfo(params);
	}
	
	@Override
	public void saveCourse(SaveCourseForm  saveCourseForm) throws Exception {

		Map<String, Object> params = SaveCourseForm.createMap(saveCourseForm);

		EgovMap memMap = CourseApiMapper.memInfo(params);
		
		int memId = CommonUtils.intNvl(memMap.get("memId"));
		String memName = (String) memMap.get("name");
		String memNric = (String) memMap.get("nric");
		
		params.put("_USER_ID", saveCourseForm.getUserId());
		
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		
		params.put("memId",   memId);
		params.put("memName", memName);
		params.put("memNric", memNric);
		params.put("userId",  loginVO.getUserId());
	
		if( 1 == saveCourseForm.getRequestType()) {
			CourseApiMapper.registerCourse(params);
		}
		else if(2 == saveCourseForm.getRequestType()) {
			CourseApiMapper.cancelCourse(params);
		}
	}
}
