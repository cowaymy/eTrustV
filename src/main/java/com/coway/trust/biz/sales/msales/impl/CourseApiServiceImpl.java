package com.coway.trust.biz.sales.msales.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.sales.msales.CourseApiService;

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
	
}
