package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.impl.OrgChartListMapper;
import com.coway.trust.biz.services.bs.BsManagementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("bsManagementService")
public class BsManagementServiceImpl extends EgovAbstractServiceImpl implements BsManagementService {

	@Value("${app.name}")
	private String appName;
	
	@Resource(name = "bsManagementMapper")
	private BsManagementMapper bsManagementMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	
	@Override
	public List<EgovMap> selectBsManagementList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return bsManagementMapper.selectBsManagementList(params);
	}

	@Override
	public List<EgovMap> selectBsStateList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return bsManagementMapper.selectBsStateList(params);
	}

	@Override
	public List<EgovMap> selectAreaList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return bsManagementMapper.selectAreaList(params);
	}

}
