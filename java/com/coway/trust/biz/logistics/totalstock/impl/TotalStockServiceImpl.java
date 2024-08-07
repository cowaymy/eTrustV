package com.coway.trust.biz.logistics.totalstock.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.totalstock.TotalStockService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("TotalStockService")
public class TotalStockServiceImpl extends EgovAbstractServiceImpl implements TotalStockService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "TotalStockMapper")
	private TotalStockMapper TotalStockMapper;

	@Override
	public List<EgovMap> totStockSearchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return TotalStockMapper.totStockSearchList(params);
	}

	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return TotalStockMapper.selectBranchList(params);
	}

	@Override
	public List<EgovMap> selectCDCList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return TotalStockMapper.selectCDCList(params);
	}

	@Override
	public List<EgovMap> selectTotalDscList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return TotalStockMapper.selectTotalDscList(params);
	}


}
