package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.bs.BsHistoryService;
import com.coway.trust.web.services.bs.BsHistoryController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("bsHistoryService")
public class BsHistoryServiceImpl extends EgovAbstractServiceImpl implements BsHistoryService{
	private static final Logger logger = LoggerFactory.getLogger(BsHistoryController.class);
	
	@Resource(name = "bsHistoryMapper")
	private BsHistoryMapper bsHistoryMapper;
	
	@Override
	public List<EgovMap> selectOrderList(Map<String, Object> params) {
		return bsHistoryMapper.selectOrderList(params);
	}
	
	@Override
	public int selectFilterCnt(Map<String, Object> params) {
		return bsHistoryMapper.selectFilterCnt(params);
	}
	
	@Override
	public List<EgovMap> filterInfo(Map<String, Object> params) {
		return bsHistoryMapper.filterInfo(params);
	}
	
	@Override
	public List<EgovMap> filterTree(Map<String, Object> params) {
		return bsHistoryMapper.filterTree(params);
	}
}
