/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipQuotationService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Service("membershipQuotationService")
public class MembershipQuotationServiceImpl extends EgovAbstractServiceImpl implements MembershipQuotationService {

	
	@Resource(name = "membershipQuotationMapper")
	private MembershipQuotationMapper membershipQuotationMapper;
	
	

	@Override
	public List<EgovMap> quotationList(Map<String, Object> params) {
		return membershipQuotationMapper.quotationList(params);
	}
	

	@Override
	public List<EgovMap> newOListuotationList(Map<String, Object> params) {
		return membershipQuotationMapper.newOListuotationList(params);
	}
	
	
	@Override
	public  EgovMap newGetExpDate(Map<String, Object> params) {
		return membershipQuotationMapper.newGetExpDate(params);
	}
	

	@Override
	public List<EgovMap> getSrvMemCode(Map<String, Object> params) {
		return membershipQuotationMapper.getSrvMemCode(params);
	}
	

	@Override
	public  EgovMap mPackageInfo(Map<String, Object> params) {
		return membershipQuotationMapper.mPackageInfo(params);
	}

	@Override
	public List<EgovMap> getPromotionCode(Map<String, Object> params) {
		return membershipQuotationMapper.getPromotionCode(params);
	}
	
	@Override
	public List<EgovMap> getFilterCharge(Map<String, Object> params) {
		return membershipQuotationMapper.getFilterCharge(params);
	}
	
	
	
	
}
