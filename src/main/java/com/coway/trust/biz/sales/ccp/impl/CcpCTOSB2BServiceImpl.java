package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.ccp.CcpCTOSB2BService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("ccpCTOSB2BService")
public class CcpCTOSB2BServiceImpl extends EgovAbstractServiceImpl implements CcpCTOSB2BService{

	
	@Resource(name = "ccpCTOSB2BMapper")
	private CcpCTOSB2BMapper ccpCTOSB2BMapper;
	
	
	@Override
	public List<EgovMap> selectCTOSB2BList(Map<String, Object> params) throws Exception {
		
		return ccpCTOSB2BMapper.selectCTOSB2BList(params);
	}


	@Override
	public List<EgovMap> getCTOSDetailList(Map<String, Object> params) throws Exception {
		
		return ccpCTOSB2BMapper.getCTOSDetailList(params);
	}
}
