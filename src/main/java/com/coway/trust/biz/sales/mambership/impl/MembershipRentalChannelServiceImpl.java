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
		
		int rtnVal=0;
		
		EgovMap paymentServiceContract = membershipRentalChannelMapper.paymentServiceContract(params);
		EgovMap paymentRentPaySet = membershipRentalChannelMapper.paymentRentPaySet(params);
		
		if(paymentServiceContract != null){
			if(paymentRentPaySet != null){
				membershipRentalChannelMapper.SAL0074D_update(params);
			}
			rtnVal = membershipRentalChannelMapper.SAL0077D_update(params);
			
		}
		
		return rtnVal;
	}
}
