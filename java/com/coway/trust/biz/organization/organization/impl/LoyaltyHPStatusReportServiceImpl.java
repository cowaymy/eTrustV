package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.LoyaltyHPStatusReportService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("loyaltyHPStatusReportService")
public class LoyaltyHPStatusReportServiceImpl extends EgovAbstractServiceImpl implements LoyaltyHPStatusReportService {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoyaltyHPStatusReportServiceImpl.class);

	@Resource(name = "LoyaltyHPStatusReportMapper")
	private LoyaltyHPStatusReportMapper LoyaltyHPStatusReportMapper;

	@Override
	public List<EgovMap> selectOrgCode(Map<String, Object> params) {
		return LoyaltyHPStatusReportMapper.selectOrgCode(params);
	}
}
