package com.coway.trust.biz.organization.courseApi.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.organization.courseApi.CourseApiDto;
import com.coway.trust.api.mobile.organization.courseApi.CourseApiForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.organization.courseApi.CourseApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CourseApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("CourseApiService")
public class CourseApiServiceImpl extends EgovAbstractServiceImpl implements CourseApiService{



	private static final Logger LOGGER = LoggerFactory.getLogger(CourseApiServiceImpl.class);



	@Resource(name = "CourseApiMapper")
	private CourseApiMapper courseApiMapper;



	@Autowired
	private LoginMapper loginMapper;



	@Override
	public List<EgovMap> selectCourse(CourseApiForm param) throws Exception {
		if( null == param ){
			throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
		}
		if( CommonUtils.isEmpty(param.getUserId()) ){
            throw new ApplicationException(AppConstants.FAIL, "User Id value does not exist.");
        }
		return courseApiMapper.selectCourse(CourseApiForm.createMap(param));
	}



	@Override
	public void saveCourse(CourseApiForm param) throws Exception {
		int saveCnt = 0;

		List<EgovMap> selectCourse = this.selectCourse(param);
		if(LOGGER.isDebugEnabled()){
			for (int i = 0; i < selectCourse.size(); i++) {
				LOGGER.debug("selectCourse    값 : {}", selectCourse.get(i));
			}
		}
		if( selectCourse.size() != 1 ){
			throw new ApplicationException(AppConstants.FAIL, "No information to save.");
		}
		CourseApiDto selectData = CourseApiDto.create(selectCourse.get(0));

		if( CommonUtils.isEmpty( selectData.getMemId() )){
			throw new ApplicationException(AppConstants.FAIL, "Member ID value does not exist.");
		}
		if( CommonUtils.isEmpty( selectData.getName() )){
			throw new ApplicationException(AppConstants.FAIL, "Name value does not exist.");
		}
		if( CommonUtils.isEmpty( selectData.getNric() )){
			throw new ApplicationException(AppConstants.FAIL, "NRIC value does not exist.");
		}
		if( CommonUtils.isEmpty(selectData.getCoursItmId()) && (("U").equals(selectData.getSaveFlag()) || ("D").equals(selectData.getSaveFlag())) ){
			throw new ApplicationException(AppConstants.FAIL, "CourseItem ID value does not exist.");
		}

		Map<String, Object> loginInfoMap = new HashMap<String, Object>();
		loginInfoMap.put("_USER_ID", param.getUserId());
		LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
		if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
			throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
		}

		Map<String, Object> saveData = new HashMap<String, Object>();
		saveData.put("coursId",			param.getCoursId() );
		saveData.put("coursMemId",		selectData.getMemId() );
		saveData.put("coursDUpdUserId",	loginVO.getUserId() );
		saveData.put("coursDMemName",	selectData.getName() );
		saveData.put("coursDMemNric",	selectData.getNric() );
		saveData.put("coursItmId",		selectData.getCoursItmId() );
		if( ("1").equals(selectData.getCoursStatus()) && ("1").equals(param.getCoursStatus()) ) {
			if( ("I").equals(selectData.getSaveFlag() ) ){
				saveCnt = courseApiMapper.insertCourse(saveData);
			}else if( ("U").equals(selectData.getSaveFlag()) ){
				saveCnt = courseApiMapper.updateCourse(saveData);
			}else{
				throw new ApplicationException(AppConstants.FAIL, "Contact your administrator.");
			}
		}else if ( ("2").equals(selectData.getCoursStatus()) && ("2").equals(param.getCoursStatus()) ) {
			if( ("D").equals(selectData.getSaveFlag()) ){
				saveCnt = courseApiMapper.deleteCourse(saveData);
			}else{
				throw new ApplicationException(AppConstants.FAIL, "Contact your administrator.");
			}
		}else{
			throw new ApplicationException(AppConstants.FAIL, "Contact your administrator.");
		}
		if( saveCnt == 0 ){
			throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
		}
	}
}
