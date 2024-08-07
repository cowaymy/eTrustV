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

     	int payModeId = Integer.parseInt(String.valueOf(paymentRentPaySet.get("modeId")));
		int payModeSelect = Integer.parseInt((String) params.get("modeID"));

		if(paymentServiceContract != null){
			if(paymentRentPaySet != null){
				if((payModeId == 131 || payModeId == 132) && payModeSelect == 130){
					int crtSeqSAL0236D = membershipRentalChannelMapper.crtSeqSAL0236D();
					params.put("deductId", crtSeqSAL0236D);
					params.put("modeId", payModeSelect);
					membershipRentalChannelMapper.insertDeductSAL0236D(params);
					membershipRentalChannelMapper.updatePaymentChannelvRescue(params);
				}
				else{
					membershipRentalChannelMapper.SAL0074D_update(params);
				}
			}
			rtnVal = membershipRentalChannelMapper.SAL0077D_update(params);

		}

		return rtnVal;
	}
}
