package com.coway.trust.biz.services.ecom.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.ecom.CpeService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("cpeService")
public class CpeServiceImpl implements CpeService {

	private static final Logger logger = LoggerFactory.getLogger(CpeServiceImpl.class);

	@Resource(name = "cpeMapper")
	private CpeMapper cpeMapper;

	@Override
	public List<EgovMap> getCpeStat(Map<String, Object> params) {
		return cpeMapper.getCpeStat(params);
	}

	@Override
	public List<EgovMap> getMainDeptList() {
		return cpeMapper.selectMainDept();
	}

	@Override
	public List<EgovMap> getSubDeptList(Map<String, Object> params) {
		return cpeMapper.selectSubDept(params);
	}

	@Override
	public EgovMap getOrderId(Map<String, Object> params) throws Exception {
		return cpeMapper.getOrderId(params);
	}

	@Override
	public List<EgovMap> selectSearchOrderNo(Map<String, Object> params) throws Exception {
		return cpeMapper.selectSearchOrderNo(params);
	}

	@Override
	public List<EgovMap> selectRequestType() throws Exception {
		return cpeMapper.selectRequestType();
	}

	@Override
	public List<EgovMap> getSubRequestTypeList(Map<String, Object> params) {
		return cpeMapper.getSubRequestTypeList(params);
	}

	@Override
	public void insertCpeReqst(Map<String, Object> params) {
		cpeMapper.insertCpeReqst(params);
	}

	@Override
	public int selectNextCpeId() {
		return cpeMapper.selectNextCpeId();
	}

}
