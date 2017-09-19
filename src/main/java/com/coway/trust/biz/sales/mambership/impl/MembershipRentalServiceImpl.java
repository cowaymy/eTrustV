/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipRentalService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo  
 *
 */
@Service("membershipRentalService")
public class MembershipRentalServiceImpl extends EgovAbstractServiceImpl implements MembershipRentalService {

	
	@Resource(name = "membershipRentalMapper")
	private MembershipRentalMapper membershipRentalMapper;  
	 
	
	@Override
	public List<EgovMap> selectList(Map<String, Object> params) {
		return membershipRentalMapper.selectList(params);
	}

	@Override
	public List<EgovMap> selectPaymentList(Map<String, Object> params) {
		return membershipRentalMapper.selectPaymentList(params);
	}

	@Override
	public List<EgovMap> selectCallLogList(Map<String, Object> params) {
		return membershipRentalMapper.selectCallLogList(params);
	}
	
	
	@Override
	public List<EgovMap> selectPaymentDetailList(Map<String, Object> params) {
		return membershipRentalMapper.selectPaymentDetailList(params);
	}
	
	@Override
	public EgovMap  selectOrderMailingInfo(Map<String, Object> params) {
		return membershipRentalMapper.selectOrderMailingInfo(params);
	}
	
	
	
	@Override
	public EgovMap usp_SELECT_ServiceContract_LedgerOutstanding(Map<String, Object> params) {
		return membershipRentalMapper.usp_SELECT_ServiceContract_LedgerOutstanding(params);
	}
	@Override
	public EgovMap usp_SELECT_ServiceContract_Ledger(Map<String, Object> params) {
		return membershipRentalMapper.usp_SELECT_ServiceContract_Ledger(params);
	}
	
	@Override
	public EgovMap selectCcontactSalesInfo(Map<String, Object> params) {
		return membershipRentalMapper.selectCcontactSalesInfo(params);
	}
	
	@Override
	public EgovMap selectConfigInfo(Map<String, Object> params) {
		return membershipRentalMapper.selectConfigInfo(params);
	}
	
	@Override
	public EgovMap selectPatsetInfo(Map<String, Object> params) {
		return membershipRentalMapper.selectPatsetInfo(params);
	}
	
	@Override
	public EgovMap selectPayThirdPartyInfo(Map<String, Object> params) {
		return membershipRentalMapper.selectPayThirdPartyInfo(params);
	}
	
	
	@Override
	public EgovMap selectPayBillingInfo(Map<String, Object> params) {
		return membershipRentalMapper.selectPayBillingInfo(params);
	}
	
	@Override
	public EgovMap selectPayUnbillInfo(Map<String, Object> params) {
		return membershipRentalMapper.selectPayUnbillInfo(params);
	}
	

	@Override
	public EgovMap accServiceContractLedgers(Map<String, Object> params) {
		return membershipRentalMapper.accServiceContractLedgers(params);
	}
	
	

}
