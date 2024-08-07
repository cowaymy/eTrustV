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
import com.coway.trust.config.datasource.DataSource;
import com.coway.trust.config.datasource.DataSourceType;

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

@Service("billingRentalService")
public class BillingMgmtServiceImpl extends EgovAbstractServiceImpl implements BillingMgmtService {

	private static final Logger logger = LoggerFactory.getLogger(BillingMgmtServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "billingRentalMapper")
	private BillingMgmtMapper billingRentalMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	
	@Override
	public List<EgovMap> selectBillingMgnt(Map<String, Object> params) {
		return billingRentalMapper.selectBillingMgnt(params);
	}

	@Override
	public EgovMap selectBillingMaster(Map<String, Object> params) {
		return billingRentalMapper.selectBillingMaster(params);
	}

	@Override
	public List<EgovMap> selectBillingDetail(Map<String, Object> params) {
		return billingRentalMapper.selectBillingDetail(params);
	}
	
	@Override
	public int selectBillingDetailCount(Map<String, Object> params) {
		return billingRentalMapper.selectBillingDetailCount(params);
	}

	@Override
	@DataSource(value = DataSourceType.LONG_TIME)
	public void callEaryBillProcedure(Map<String, Object> params) {
		billingRentalMapper.callEaryBillProcedure(params);
	}

	@Override
	@DataSource(value = DataSourceType.LONG_TIME)
	public void callBillProcedure(Map<String, Object> params) {
		billingRentalMapper.callBillProcedure(params);
	}

	@Override
	public int getExistBill(Map<String, Object> params) {
		return billingRentalMapper.getExistBill(params);
	}

	@Override
	@DataSource(value = DataSourceType.LONG_TIME)
	public void confirmEarlyBills(Map<String, Object> params) {
		billingRentalMapper.confirmEarlyBills(params);
	}

	@Override
	@DataSource(value = DataSourceType.LONG_TIME)
	public void confirmBills(Map<String, Object> params) {
		billingRentalMapper.confirmBills(params);
	}
	
	/**
	 * 
	 * @param params
	 * @return
	 */
	@Override
	public int countMonthlyRawData(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return billingRentalMapper.countMonthlyRawData(params);
	}
	
	
}
