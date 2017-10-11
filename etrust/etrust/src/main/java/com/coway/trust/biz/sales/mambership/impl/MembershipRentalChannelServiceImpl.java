/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipRentalChannelService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo  
 *
 */
@Service("membershipRentalChannelService")
public class MembershipRentalChannelServiceImpl extends EgovAbstractServiceImpl implements MembershipRentalChannelService {

	
	@Resource(name = "membershipRentalChannelMapper")
	private MembershipRentalChannelMapper membershipRentalChannelMapper;  
	
	@Override
	public List<EgovMap> getLoadRejectReasonList(Map<String, Object> params) {
		return membershipRentalChannelMapper.getLoadRejectReasonList(params);
	}
	

	
	@Override 
	public int  SAL0074D_update(Map<String, Object> params) {
		
		int  val   =0;
		int rtnVal=0;
		val =membershipRentalChannelMapper.SAL0074D_update(params);
		
		if(val > 0){
			rtnVal =membershipRentalChannelMapper.SAL0077D_update(params);
		}
		
		return rtnVal;
	}
}
