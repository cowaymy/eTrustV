/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coway.trust.biz.sales.mambership.MembershipRentalService;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

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
	
	@Resource(name = "orderRegisterMapper")
	private OrderRegisterMapper orderRegisterMapper;  
	
	private static Logger logger = LoggerFactory.getLogger(MembershipRentalServiceImpl.class);
	
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
		return  membershipRentalMapper.usp_SELECT_ServiceContract_LedgerOutstanding(params);
	}
	@Override
	public EgovMap  usp_SELECT_ServiceContract_Ledger(Map<String, Object> params) {
		
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
	public EgovMap selectPatsetInfo(Map<String, Object> params, SessionVO sessionVO) {
		
		EgovMap result = membershipRentalMapper.selectPatsetInfo(params);
		
		if(CommonUtils.isNotEmpty(result.get("custCrcNo"))) {
			Map<String, Object> pMap = new HashMap<String, Object>();
			
			pMap.put("userId", sessionVO.getUserId());
			pMap.put("moduleUnitId", "252");
			
			EgovMap rsltMap = orderRegisterMapper.selectCheckAccessRight(pMap);
			
			if(rsltMap == null) {
				result.put("custCrcNo", CommonUtils.getMaskCreditCardNo(StringUtils.trim((String)result.get("custCrcNo")), "*", 6));
			}
		}
		else {
			result.put("custCrcNo", "-");
		}
		
		return result;
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
	
	
	@Override
	public EgovMap selectQuotInfoInfo(Map<String, Object> params) {
		return membershipRentalMapper.selectQuotInfoInfo(params);
	}
	
	
	@Override
	public List<EgovMap> paymentViewHistory(Map<String, Object> params) {
		return membershipRentalMapper.paymentViewHistory(params);
	}
	
	
	@Override
	public void viewHistPaySetting(Map<String, Object> setmap){
		logger.debug("					" + setmap.toString());
		membershipRentalMapper.viewHistPaySetting(setmap);
	}
	
}
