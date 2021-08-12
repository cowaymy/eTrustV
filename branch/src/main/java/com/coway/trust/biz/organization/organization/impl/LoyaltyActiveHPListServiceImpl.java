package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.LoyaltyActiveHPListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("loyaltyActiveHPListService")
public class LoyaltyActiveHPListServiceImpl extends EgovAbstractServiceImpl implements LoyaltyActiveHPListService {

	@Resource(name = "loyaltyActiveHPListMapper")
	private LoyaltyActiveHPListMapper loyaltyActiveHPListMapper;

	@Override
	public List<EgovMap> selectLoyaltyActiveHPList(Map<String, Object> params) {
		return loyaltyActiveHPListMapper.selectLoyaltyActiveHPList(params);
	}

}
