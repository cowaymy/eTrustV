/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipRCService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author kmo
 *
 */
@Service("membershipRCService")
public class MembershipRCServiceImpl extends EgovAbstractServiceImpl implements MembershipRCService {

	private static Logger logger = LoggerFactory.getLogger(MembershipRCServiceImpl.class);
	
	@Resource(name = "membershipRCMapper")
	private MembershipRCMapper membershipRCMapper;


	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Override
	public List<EgovMap> selectCancellationList(Map<String, Object> params) {
		return membershipRCMapper.selectCancellationList(params);
	}
	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params) {
		return membershipRCMapper.selectBranchList(params);
	}
	@Override
	public List<EgovMap> selectReasonList(Map<String, Object> params) {
		return membershipRCMapper.selectReasonList(params);
	}
	@Override
	public EgovMap selectCancellationInfo(Map<String, Object> params) {
		return membershipRCMapper.selectCancellationInfo(params);
	}
	@Override
	public List<EgovMap> selectCodeList(Map<String, Object> params) {
		// 
		return membershipRCMapper.selectCodeList(params);
	}

}
