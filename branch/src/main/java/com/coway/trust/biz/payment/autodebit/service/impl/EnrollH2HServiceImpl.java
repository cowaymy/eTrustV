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
import com.coway.trust.biz.payment.autodebit.service.EnrollH2HService;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.SimpleDateFormat;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import java.io.*;
import org.apache.commons.lang.StringUtils;

@Service("enrollH2HService")
public class EnrollH2HServiceImpl extends EgovAbstractServiceImpl implements EnrollH2HService {

	@Resource(name = "enrollH2HMapper")
	private EnrollH2HMapper enrollH2HMapper;

	/**
	 * EnrollmentList(Master Grid) 조회
	 *
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectEnrollmentH2H(Map<String, Object> params) {
		return enrollH2HMapper.selectEnrollmentH2H(params);
	}

	public List<EgovMap> selectEnrollmentH2HById(Map<String, Object> params) {
		return enrollH2HMapper.selectEnrollmentH2HById(params);
	}


	public List<EgovMap> selectEnrollmentH2HListById(Map<String, Object> params) {
		return enrollH2HMapper.selectEnrollmentH2HListById(params);
	}

	public List<EgovMap> selectH2HEnrollmentSubListById(Map<String, Object> params) {
		return enrollH2HMapper.selectH2HEnrollmentSubListById(params);
	}

    public Map<String, Object> generateNewEEnrollment(Map<String, Object> param){
		return enrollH2HMapper.generateNewEEnrollment(param);
	}

    public Map<String, Object> deactivateEEnrollmentStatus(Map<String, Object> param){
		return enrollH2HMapper.deactivateEEnrollmentStatus(param);
	}

}
