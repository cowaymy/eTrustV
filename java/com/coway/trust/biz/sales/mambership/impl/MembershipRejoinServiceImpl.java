/**
 *
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipRejoinService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Service("membershipRejoinService")
public class MembershipRejoinServiceImpl extends EgovAbstractServiceImpl implements MembershipRejoinService {

	private static final Logger logger = LoggerFactory.getLogger(MembershipRejoinServiceImpl.class);

	@Resource(name = "membershipRejoinMapper")
	private MembershipRejoinMapper MembershipRejoinMapper;

	@Override
	public List<EgovMap> selectRejoinList(Map<String, Object> params) {
		return MembershipRejoinMapper.selectRejoinList(params);
	}

	@Override
	public List<EgovMap> selectExpiredMembershipList(Map<String, Object> params) {
	    return MembershipRejoinMapper.selectExpiredMembershipList(params);
	}
}



