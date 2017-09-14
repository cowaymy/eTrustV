package com.coway.trust.biz.payment.billing.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.billing.service.BillingMgmtService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("billingRantalService")
public class BillingMgmtServiceImpl extends EgovAbstractServiceImpl implements BillingMgmtService {

	private static final Logger logger = LoggerFactory.getLogger(BillingMgmtServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "billingRantalMapper")
	private BillingMgmtMapper billingRantalMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	
	@Override
	public List<EgovMap> selectBillingMgnt(Map<String, Object> params) {
		return billingRantalMapper.selectBillingMgnt(params);
	}

	@Override
	public EgovMap selectBillingMaster(Map<String, Object> params) {
		return billingRantalMapper.selectBillingMaster(params);
	}

	@Override
	public List<EgovMap> selectBillingDetail(Map<String, Object> params) {
		return billingRantalMapper.selectBillingDetail(params);
	}

	@Override
	public void callEaryBillProcedure(Map<String, Object> params) {
		billingRantalMapper.callEaryBillProcedure(params);
	}

	@Override
	public void callBillProcedure(Map<String, Object> params) {
		billingRantalMapper.callBillProcedure(params);
	}
	
	
}
