package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.OrgChartListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orgChartListService")
public class OrgChartListServiceImpl extends EgovAbstractServiceImpl implements OrgChartListService{

	
	
	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(MemberEventServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "orgChartListMapper")
	private OrgChartListMapper orgChartListMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	
	@Override
	public List<EgovMap> selectOrgChartHpList(Map<String, Object> params) {
	
		return orgChartListMapper.selectOrgChartHpList(params);
	}

	@Override
	public List<EgovMap> selectHpChildList(Map<String, Object> params) {
	
		return orgChartListMapper.selectHpChildList(params);
	}
	
	
	@Override
	public List<EgovMap> selectOrgChartCdList(Map<String, Object> params) {
	
		return orgChartListMapper.selectOrgChartCdList(params);
	}
	
	
	
	@Override
	public List<EgovMap> selectOrgChartCtList(Map<String, Object> params) {
	
		return orgChartListMapper.selectOrgChartCtList(params);
	}

	@Override
	public List<EgovMap> getDeptTreeList(Map<String, Object> params) {
		
		String memUpId ="";
		
		if(params.get("groupCode").equals("1")){
			memUpId = "124";
		}else if(params.get("groupCode").equals("2")){
			memUpId = "31983";
		}else if(params.get("groupCode").equals("3")){
			memUpId = "23259";     
		}
		params.put("memUpId", memUpId);			
		
		return orgChartListMapper.getDeptTreeList(params);
	}

	
	
	@Override
	public List<EgovMap> getGroupTreeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orgChartListMapper.getGroupTreeList(params);

	}

	@Override
	public List<EgovMap> selectOrgChartDetList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orgChartListMapper.selectOrgChartDetList(params);
	}



	
}
