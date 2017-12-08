package com.coway.trust.biz.services.installation.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.installation.InstallationReversalService;
import com.coway.trust.web.services.installation.InstallationReversalController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("installationReversalService")
public class InstallationReversalServiceImpl extends EgovAbstractServiceImpl implements InstallationReversalService{
	private static final Logger logger = LoggerFactory.getLogger(InstallationReversalController.class);
	
	@Resource(name = "installationReversalMapper")
	private InstallationReversalMapper installationReversalMapper;
	
	public List<EgovMap> selectOrderList(Map<String, Object> params) {
		return installationReversalMapper.selectOrderList(params);
	}
	
	@Override
	public EgovMap installationReversalSearchDetail1(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail1(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail2(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail2(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail3(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail3(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail4(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail4(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail5(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail5(params);
	}

}
