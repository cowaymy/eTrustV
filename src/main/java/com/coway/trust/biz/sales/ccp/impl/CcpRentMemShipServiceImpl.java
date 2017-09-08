package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.ccp.CcpRentMemShipService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ccpRentMemShipService")
public class CcpRentMemShipServiceImpl implements CcpRentMemShipService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpRentMemShipServiceImpl.class);
	
	@Resource(name = "ccpRentMemShipMapper")
	private CcpRentMemShipMapper ccpRentMemShipMapper;

	
	@Override
	public List<EgovMap> getBranchCodeList() throws Exception {
		
		return ccpRentMemShipMapper.getBranchCodeList();
	}

	
	@Override
	public List<EgovMap> getReasonCodeList() throws Exception {
		
		return ccpRentMemShipMapper.getReasonCodeList();
	}


	@Override
	public List<EgovMap> selectCcpRentListSearchList(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectCcpRentListSearchList(params);
	}
	
}
