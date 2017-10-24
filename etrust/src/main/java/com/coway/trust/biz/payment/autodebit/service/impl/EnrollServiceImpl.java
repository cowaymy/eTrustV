package com.coway.trust.biz.payment.autodebit.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.antlr.grammar.v3.ANTLRParser.exceptionGroup_return;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.autodebit.service.EnrollService;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.SimpleDateFormat;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import java.io.*;
import org.apache.commons.lang.StringUtils;


/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("enrollService")
public class EnrollServiceImpl extends EgovAbstractServiceImpl implements EnrollService {

	@Resource(name = "enrollMapper")
	private EnrollMapper enrollMapper;

	/**
	 * EnrollmentList(Master Grid) 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectEnrollmentList(Map<String, Object> params) {
		return enrollMapper.selectEnrollmentList(params);
	}


	/**
	 * View Enrollment Master 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectViewEnrollment(Map<String, Object> params) {
		return enrollMapper.selectViewEnrollment(params);
	}


	/**
	 * View Enrollment List 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectViewEnrollmentList(Map<String, Object> params) {
		return enrollMapper.selectViewEnrollmentList(params);
	}


	/**
	 * Save Enroll(저장)
	 * @param params
	 * @return
	 */
	@Override
	 public Map<String, Object> saveEnroll(Map<String, Object> param){
		return enrollMapper.saveEnroll(param);
	}
	
	/**
	 * EnrollmentDetView 조회 후 파일생성
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectEnrollmentDetView(Map<String, Object> params) {
		return enrollMapper.selectEnrollmentDetView(params);
	}	
}
