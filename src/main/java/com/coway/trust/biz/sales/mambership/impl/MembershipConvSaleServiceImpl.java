/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipConvSaleService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @author goo
 *
 */
@Service("membershipConvSaleService")
public class MembershipConvSaleServiceImpl extends EgovAbstractServiceImpl implements MembershipConvSaleService {

	
	@Resource(name = "membershipConvSaleMapper")
	private MembershipConvSaleMapper membershipConvSaleMapper;
	
	

	
	
	
}
