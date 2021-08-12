package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.bs.BsReversalService;
import com.coway.trust.web.services.bs.BsReversalController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("bsReversalService")
public class BsReversalServiceImpl extends EgovAbstractServiceImpl implements BsReversalService{
	private static final Logger logger = LoggerFactory.getLogger(BsReversalController.class);
	
	@Resource(name = "bsReversalMapper")
	private BsReversalMapper bsReversalMapper;
	
	public List<EgovMap> selectOrderList(Map<String, Object> params) {
		return bsReversalMapper.selectOrderList(params);
	}
	
	@Override
	public EgovMap selectConfigBasicInfo(Map<String, Object> params) {
		return bsReversalMapper.selectConfigBasicInfo(params);
	}
	
	@Override
	public List<EgovMap> selectReverseReason() {
		return bsReversalMapper.selectReverseReason();
	}
	
	@Override
	public List<EgovMap> selectFailReason() {
		return bsReversalMapper.selectFailReason();
	}
	

}
