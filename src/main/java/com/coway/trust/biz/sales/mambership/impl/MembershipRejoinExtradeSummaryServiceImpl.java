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

import com.coway.trust.biz.sales.mambership.MembershipRejoinExtradeSummaryService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Service("membershipRejoinExtradeSummaryService")
public class MembershipRejoinExtradeSummaryServiceImpl extends EgovAbstractServiceImpl implements MembershipRejoinExtradeSummaryService {

	private static final Logger logger = LoggerFactory.getLogger(MembershipRejoinExtradeSummaryServiceImpl.class);

	@Resource(name = "membershipRejoinExtradeSummaryMapper")
	private MembershipRejoinExtradeSummaryMapper membershipRejoinExtradeSummaryMapper;

	@Override
	public List<EgovMap> selectRejoinExtradeSummaryList(Map<String, Object> params) {
		return membershipRejoinExtradeSummaryMapper.selectRejoinExtradeSummaryList(params);
	}

	/*@Override
	public List<EgovMap> selectExpiredMembershipList(Map<String, Object> params) {
	    return membershipRejoinExtradeSummaryMapper.selectExpiredMembershipList(params);
	}*/
}



