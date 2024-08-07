/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipPaymentService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Service("membershipPaymentService")
public class MembershipPaymentServiceImpl extends EgovAbstractServiceImpl implements MembershipPaymentService {

	
	@Resource(name = "membershipPaymentMapper")
	private MembershipPaymentMapper membershipPaymentMapper;
	
	

	@Override
	public List<EgovMap> selPaymentConfig(Map<String, Object> params) {
		return membershipPaymentMapper.selPaymentConfig(params);
	}
	
	

	@Override
	public List<EgovMap> paymentLastMembership(Map<String, Object> params) {
		return membershipPaymentMapper.paymentLastMembership(params);
	}
	

	@Override
	public List<EgovMap> paymentInsAddress(Map<String, Object> params) {
		return membershipPaymentMapper.paymentInsAddress(params);
	}
	
	
	@Override
	public EgovMap paymentCharges(Map<String, Object> params) {
		return membershipPaymentMapper.paymentCharges(params);
	}
	
	@Override
	public List<EgovMap> paymentCollecterList(Map<String, Object> params) {
		return membershipPaymentMapper.paymentCollecterList(params);
	}
	

	@Override
	public List<EgovMap> paymentColleConfirm(Map<String, Object> params) {
		return membershipPaymentMapper.paymentColleConfirm(params);
	}
	
	@Override
	public List<EgovMap> paymentGetAccountCode(Map<String, Object> params) {
		return membershipPaymentMapper.paymentGetAccountCode(params);
	}
	
	
	
}
