package com.coway.trust.biz.payment.billinggroup.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.billinggroup.service.BillingGroupService;
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

@Service("billingGroupService")
public class BillingGroupServiceImpl extends EgovAbstractServiceImpl implements BillingGroupService {

	private static final Logger logger = LoggerFactory.getLogger(BillingGroupServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "billingGroupMapper")
	private BillingGroupMapper billingGroupMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	
	
	/**
	 * selectCustBillId 조회
	 * @param params
	 * @return
	 */
	@Override
	public String selectCustBillId(Map<String, Object> params) {
		return billingGroupMapper.selectCustBillId(params);
	}
	
	/**
	 * selectBasicInfo 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectBasicInfo(Map<String, Object> params) {
		return billingGroupMapper.selectBasicInfo(params);
	}
	
	/**
	 * selectMaillingInfo 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectMaillingInfo(Map<String, Object> params) {
		return billingGroupMapper.selectMaillingInfo(params);
	}
	
	/**
	 * selectContractInfo 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectContractInfo(Map<String, Object> params) {
		return billingGroupMapper.selectContractInfo(params);
	}
	
	/**
	 * selectOrderGroupList 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectOrderGroupList(Map<String, Object> params) {
		return billingGroupMapper.selectOrderGroupList(params);
	}
	
	/**
	 * selectEstmReqHistory 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectEstmReqHistory(Map<String, Object> params) {
		return billingGroupMapper.selectEstmReqHistory(params);
	}
	
	/**
	 * selectBillGrpHistory 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectBillGrpHistory(Map<String, Object> params) {
		return billingGroupMapper.selectBillGrpHistory(params);
	}
	
	/**
	 * selectBillGrpOrder 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectBillGrpOrder(Map<String, Object> params) {
		return billingGroupMapper.selectBillGrpOrder(params);
	}
	
	/**
	 * selectBillGrpHistory 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectBillGroupOrderView(Map<String, Object> params) {
		return billingGroupMapper.selectBillGroupOrderView(params);
	}
	
	/**
	 * updRemark 업데이트
	 * @param params
	 * @return
	 */
	@Override
	public void updCustMaster(Map<String, Object> params) {
		billingGroupMapper.updCustMaster(params);
	}
	
	/**
	 * updSalesOrderMaster 업데이트
	 * @param params
	 * @return
	 */
	@Override
	public void updSalesOrderMaster(Map<String, Object> params) {
		billingGroupMapper.updSalesOrderMaster(params);
	}
	
	
	/**
	 * insRemarkHis
	 * @param params
	 * @return
	 */
	@Override
	public int insHistory(Map<String, Object> params) {
		return billingGroupMapper.insHistory(params);
	}
	
	/**
	 * selectDetailHistoryView 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectDetailHistoryView(Map<String, Object> params) {
		return billingGroupMapper.selectDetailHistoryView(params);
	}
	
	/**
	 * selectMailAddrHistorty 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectMailAddrHistorty(String param) {
		return billingGroupMapper.selectMailAddrHistorty(param);
	}
	
	/**
	 * selectContPersonHistorty 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectContPersonHistorty(String param) {
		return billingGroupMapper.selectContPersonHistorty(param);
	}
	
	/**
	 * selectCustMailAddrList 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectCustMailAddrList(Map<String, Object> params) {
		return billingGroupMapper.selectCustMailAddrList(params);
	}
	
	/**
	 * selectAddrKeywordList 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectAddrKeywordList(Map<String, Object> params) {
		return billingGroupMapper.selectAddrKeywordList(params);
	}
	
	/**
	 * selectSalesOrderM 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectSalesOrderM(Map<String, Object> params) {
		return billingGroupMapper.selectSalesOrderM(params);
	}
	
	/**
	 * selectContPersonList 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectContPersonList(Map<String, Object> params) {
		return billingGroupMapper.selectContPersonList(params);
	}
	
	/**
	 * selectContPerKeywordList 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectContPerKeywordList(Map<String, Object> params) {
		return billingGroupMapper.selectContPerKeywordList(params);
	}
	
	/**
	 * selectCustBillMaster 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectCustBillMaster(Map<String, Object> params) {
		return billingGroupMapper.selectCustBillMaster(params);
	}
	
	/**
	 * selectReqMaster 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectReqMaster(Map<String, Object> params) {
		return billingGroupMapper.selectReqMaster(params);
	}
	
	/**
	 * updReqEstm
	 * @param params
	 * @return
	 */
	@Override
	public void updReqEstm(Map<String, Object> params) {
		billingGroupMapper.updReqEstm(params);
	}
	
	/**
	 * selectDocNo
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectDocNo(Map<String, Object> params) {
		return billingGroupMapper.selectDocNo(params);
	}
	
	/**
	 * updDocNo
	 * @param params
	 * @return
	 */
	@Override
	public void updDocNo(Map<String, Object> params) {
		billingGroupMapper.updDocNo(params);
	}
	
	/**
	 * insEstmReq
	 * @param params
	 * @return
	 */
	@Override
	public void insEstmReq(Map<String, Object> params) {
		billingGroupMapper.insEstmReq(params);
	}
	
	/**
	 * selectEstmReqHisView
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectEstmReqHisView(Map<String, Object> params) {
		return billingGroupMapper.selectEstmReqHisView(params);
	}
	
	/**
	 * selectEStatementReqs
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectEStatementReqs(Map<String, Object> params) {
		return billingGroupMapper.selectEStatementReqs(params);
	}
	
	/**
	 * selectBillGrpOrdView
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectBillGrpOrdView(Map<String, Object> params) {
		return billingGroupMapper.selectBillGrpOrdView(params);
	}
	
	/**
	 * selectBillGrpOrdView
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectSalesOrderMs(Map<String, Object> params) {
		return billingGroupMapper.selectSalesOrderMs(params);
	}
	
	/**
	 * selectReplaceOrder
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectReplaceOrder(Map<String, Object> params) {
		return billingGroupMapper.selectReplaceOrder(params);
	}
	
	/**
	 * selectAddOrdList 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectAddOrdList(Map<String, Object> params) {
		return billingGroupMapper.selectAddOrdList(params);
	}
	
	/**
	 * selectMainOrderHistory
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectMainOrderHistory(Map<String, Object> params) {
		return billingGroupMapper.selectMainOrderHistory(params);
	}
	
	/**
	 * insBillGrpMaster
	 * @param params
	 * @return
	 */
	@Override
	public void insBillGrpMaster(Map<String, Object> params) {
		billingGroupMapper.insBillGrpMaster(params);
	}
}
