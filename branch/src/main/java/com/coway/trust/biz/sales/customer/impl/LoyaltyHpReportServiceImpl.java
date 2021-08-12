package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.customer.LoyaltyHpReportService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("loyaltyHpReportService")
public class LoyaltyHpReportServiceImpl extends EgovAbstractServiceImpl implements LoyaltyHpReportService {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoyaltyHpReportServiceImpl.class);

	@Resource(name = "loyaltyHpReportMapper")
	private LoyaltyHpReportMapper loyaltyHpReportMapper;

	@Override
	public List<EgovMap> selectBatchUploadNumbers(Map<String, Object> params) {
		return loyaltyHpReportMapper.selectBatchUploadNumbers(params);
	}
}
