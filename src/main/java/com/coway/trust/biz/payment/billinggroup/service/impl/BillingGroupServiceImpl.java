package com.coway.trust.biz.payment.billinggroup.service.impl;

import java.util.HashMap;
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
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
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
	
	/**
	 * selectGetOrder
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectGetOrder(Map<String, Object> params) {
		return billingGroupMapper.selectGetOrder(params);
	}
	
	/**
	 * getSAL0024DSEQ
	 * @param params
	 * @return
	 */
	@Override
	public int getSAL0024DSEQ() {
		return billingGroupMapper.getSAL0024DSEQ();
	}

	@Override
	public String saveAddNewGroup(Map<String, Object> params, SessionVO sessionVO) {
		
		String defaultDate = "1900-01-01";
		int userId = sessionVO.getUserId();
		String grpNo = "";
		params.put("defaultDate", defaultDate);
		
		EgovMap selectSalesOrderMs = billingGroupMapper.selectSalesOrderMs(params);
		
		if(selectSalesOrderMs != null && Integer.parseInt(String.valueOf(selectSalesOrderMs.get("salesOrdId"))) > 0){
			params.put("custBillId", String.valueOf(selectSalesOrderMs.get("custBillId")));
			EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(params);
			
			if(selectCustBillMaster != null && Integer.parseInt(String.valueOf(selectCustBillMaster.get("custBillId"))) > 0){
			
				//Insert history (Remove Order) - previous group
				//인서트 셋팅 시작
				String salesOrderIDOld = String.valueOf(selectSalesOrderMs.get("salesOrdId"));
				String salesOrderIDNew = "0";
				String contactIDOld = "0";
				String contactIDNew = "0";
				String addressIDOld = "0";
				String addressIDNew = "0";
				String statusIDOld = "0";
				String statusIDNew = "0";
				String remarkOld = "";
				String remarkNew = "";
				String emailOld = "";
				String emailNew = "";
				String isEStatementOld = "0";
				String isEStatementNew = "0";
				String isSMSOld = "0";
				String isSMSNew = "0";
				String isPostOld = "0";
				String isPostNew = "0";
				String typeId = "1046";
				String sysHisRemark = "[System] Group Order - Remove Order";
				String emailAddtionalNew = "";
				String emailAddtionalOld = "";
				
				Map<String, Object> hisRemoveOrdMap = new HashMap<String, Object>();
				hisRemoveOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
				hisRemoveOrdMap.put("userId", userId);
				hisRemoveOrdMap.put("reasonUpd", "[System] Move to new group.");
				hisRemoveOrdMap.put("salesOrderIDOld", salesOrderIDOld);
				hisRemoveOrdMap.put("salesOrderIDNew", salesOrderIDNew);
				hisRemoveOrdMap.put("contactIDOld", contactIDOld);
				hisRemoveOrdMap.put("contactIDNew", contactIDNew);
				hisRemoveOrdMap.put("addressIDOld", addressIDOld);
				hisRemoveOrdMap.put("addressIDNew", addressIDNew);
				hisRemoveOrdMap.put("statusIDOld", statusIDOld);
				hisRemoveOrdMap.put("statusIDNew", statusIDNew);
				hisRemoveOrdMap.put("remarkOld", remarkOld);
				hisRemoveOrdMap.put("remarkNew", remarkNew);
				hisRemoveOrdMap.put("emailOld", emailOld);
				hisRemoveOrdMap.put("emailNew", emailNew);
				hisRemoveOrdMap.put("isEStatementOld", isEStatementOld);
				hisRemoveOrdMap.put("isEStatementNew", isEStatementNew);
				hisRemoveOrdMap.put("isSMSOld", isSMSOld);
				hisRemoveOrdMap.put("isSMSNew", isSMSNew);
				hisRemoveOrdMap.put("isPostOld", isPostOld);
				hisRemoveOrdMap.put("isPostNew", isPostNew);
				hisRemoveOrdMap.put("typeId", typeId);
				hisRemoveOrdMap.put("sysHisRemark", sysHisRemark);
				hisRemoveOrdMap.put("emailAddtionalNew", emailAddtionalNew);
				hisRemoveOrdMap.put("emailAddtionalOld", emailAddtionalOld);
				billingGroupMapper.insHistory(hisRemoveOrdMap);
				
				if(String.valueOf(selectCustBillMaster.get("custBillSoId")).equals(String.valueOf(selectSalesOrderMs.get("salesOrdId"))) ){
					
					//Is Main Order in previous group
					String changeOrderId = "0";
					//Get first complete order
					Map<String, Object> replaceOrdMap = new HashMap<String, Object>();
	                replaceOrdMap.put("replaceOrd", "Y");
	                replaceOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
	                replaceOrdMap.put("salesOrdId", String.valueOf(selectSalesOrderMs.get("salesOrdId")));
					EgovMap replcaceOrder_1 = billingGroupMapper.selectReplaceOrder(replaceOrdMap);
					
					if (replcaceOrder_1 != null && Integer.parseInt(String.valueOf(replcaceOrder_1.get("salesOrdId"))) > 0){
						
						changeOrderId = String.valueOf(replcaceOrder_1.get("salesOrdId"));
					
					}else{
						
						Map<String, Object> replaceOrd2Map = new HashMap<String, Object>();
						replaceOrd2Map.put("replaceOrd2", "Y");
						replaceOrd2Map.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
						replaceOrd2Map.put("salesOrdId", String.valueOf(selectSalesOrderMs.get("salesOrdId")));
						EgovMap replcaceOrder_2 = billingGroupMapper.selectReplaceOrder(replaceOrd2Map);
						
						if (replcaceOrder_2 != null && Integer.parseInt(String.valueOf(replcaceOrder_2.get("salesOrdId"))) > 0){
							
							changeOrderId = String.valueOf(replcaceOrder_2.get("salesOrdId"));
							
						}else{
							
							Map<String, Object> replaceOrd3Map = new HashMap<String, Object>();
							replaceOrd3Map.put("replaceOrd3", "Y");
							replaceOrd3Map.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
							replaceOrd3Map.put("salesOrdId", String.valueOf(selectSalesOrderMs.get("salesOrdId")));
							EgovMap replcaceOrder_3 = billingGroupMapper.selectReplaceOrder(replaceOrd3Map);
							
							if (replcaceOrder_3 != null && Integer.parseInt(String.valueOf(replcaceOrder_3.get("salesOrdId"))) > 0){
								changeOrderId = String.valueOf(replcaceOrder_3.get("salesOrdId"));
							}
						}
					}
					
					if(Integer.parseInt(changeOrderId) > 0 ){
						
						// Got order to replace
                        //Insert history (Change Main Order) - previous group
						String salesOrderIDOld2 = String.valueOf(selectSalesOrderMs.get("salesOrdId"));
						String salesOrderIDNew2 = changeOrderId;
						String contactIDOld2 = "0";
						String contactIDNew2 = "0";
						String addressIDOld2 = "0";
						String addressIDNew2 = "0";
						String statusIDOld2 = "0";
						String statusIDNew2 = "0";
						String remarkOld2 = "";
						String remarkNew2 = "";
						String emailOld2 = "";
						String emailNew2 = "";
						String isEStatementOld2 = "0";
						String isEStatementNew2 = "0";
						String isSMSOld2 = "0";
						String isSMSNew2 = "0";
						String isPostOld2 = "0";
						String isPostNew2 = "0";
						String typeId2 = "1046";
						String sysHisRemark2 = "[System] Group Order - Auto Select Main Order";
						String emailAddtionalNew2 = "";
						String emailAddtionalOld2 = "";
						
						Map<String, Object> hisChgOrdMap = new HashMap<String, Object>();
						hisChgOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
						hisChgOrdMap.put("userId", userId);
						hisChgOrdMap.put("reasonUpd", "[System] Move to new group.");
						hisChgOrdMap.put("salesOrderIDOld", salesOrderIDOld2);
						hisChgOrdMap.put("salesOrderIDNew", salesOrderIDNew2);
						hisChgOrdMap.put("contactIDOld", contactIDOld2);
						hisChgOrdMap.put("contactIDNew", contactIDNew2);
						hisChgOrdMap.put("addressIDOld", addressIDOld2);
						hisChgOrdMap.put("addressIDNew", addressIDNew2);
						hisChgOrdMap.put("statusIDOld", statusIDOld2);
						hisChgOrdMap.put("statusIDNew", statusIDNew2);
						hisChgOrdMap.put("remarkOld", remarkOld2);
						hisChgOrdMap.put("remarkNew", remarkNew2);
						hisChgOrdMap.put("emailOld", emailOld2);
						hisChgOrdMap.put("emailNew", emailNew2);
						hisChgOrdMap.put("isEStatementOld", isEStatementOld2);
						hisChgOrdMap.put("isEStatementNew", isEStatementNew2);
						hisChgOrdMap.put("isSMSOld", isSMSOld2);
						hisChgOrdMap.put("isSMSNew", isSMSNew2);
						hisChgOrdMap.put("isPostOld", isPostOld2);
						hisChgOrdMap.put("isPostNew", isPostNew2);
						hisChgOrdMap.put("typeId", typeId2);
						hisChgOrdMap.put("sysHisRemark", sysHisRemark2);
						hisChgOrdMap.put("emailAddtionalNew", emailAddtionalNew2);
						hisChgOrdMap.put("emailAddtionalOld", emailAddtionalOld2);
						billingGroupMapper.insHistory(hisChgOrdMap);
						//인서트 셋팅  끝
						
						Map<String, Object> updChangeMap = new HashMap<String, Object>();
	        			updChangeMap.put("newGrpFlag", "Y");
	        			updChangeMap.put("custBillSoId", changeOrderId);
	        			updChangeMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
	        			billingGroupMapper.updCustMaster(updChangeMap);
					}else{
						
						// No replace order found - Inactive billing group
                        //Insert history (Change Main Order) - previous group
						String salesOrderIDOld2 = "0";
						String salesOrderIDNew2 = "0";
						String contactIDOld2 = "0";
						String contactIDNew2 = "0";
						String addressIDOld2 = "0";
						String addressIDNew2 = "0";
						String statusIDOld2 = String.valueOf(selectCustBillMaster.get("custBillStusId"));
						String statusIDNew2 = "8";
						String remarkOld2 = "";
						String remarkNew2 = "";
						String emailOld2 = "";
						String emailNew2 = "";
						String isEStatementOld2 = "0";
						String isEStatementNew2 = "0";
						String isSMSOld2 = "0";
						String isSMSNew2 = "0";
						String isPostOld2 = "0";
						String isPostNew2 = "0";
						String typeId2 = "1046";
						String sysHisRemark2 = "[System] Group Order - Auto Deactivate";
						String emailAddtionalNew2 = "";
						String emailAddtionalOld2 = "";
						
						Map<String, Object> hisChgOrdMap = new HashMap<String, Object>();
						hisChgOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
						hisChgOrdMap.put("userId", userId);
						hisChgOrdMap.put("reasonUpd", "[System] Move to new group.");
						hisChgOrdMap.put("salesOrderIDOld", salesOrderIDOld2);
						hisChgOrdMap.put("salesOrderIDNew", salesOrderIDNew2);
						hisChgOrdMap.put("contactIDOld", contactIDOld2);
						hisChgOrdMap.put("contactIDNew", contactIDNew2);
						hisChgOrdMap.put("addressIDOld", addressIDOld2);
						hisChgOrdMap.put("addressIDNew", addressIDNew2);
						hisChgOrdMap.put("statusIDOld", statusIDOld2);
						hisChgOrdMap.put("statusIDNew", statusIDNew2);
						hisChgOrdMap.put("remarkOld", remarkOld2);
						hisChgOrdMap.put("remarkNew", remarkNew2);
						hisChgOrdMap.put("emailOld", emailOld2);
						hisChgOrdMap.put("emailNew", emailNew2);
						hisChgOrdMap.put("isEStatementOld", isEStatementOld2);
						hisChgOrdMap.put("isEStatementNew", isEStatementNew2);
						hisChgOrdMap.put("isSMSOld", isSMSOld2);
						hisChgOrdMap.put("isSMSNew", isSMSNew2);
						hisChgOrdMap.put("isPostOld", isPostOld2);
						hisChgOrdMap.put("isPostNew", isPostNew2);
						hisChgOrdMap.put("typeId", typeId2);
						hisChgOrdMap.put("sysHisRemark", sysHisRemark2);
						hisChgOrdMap.put("emailAddtionalNew", emailAddtionalNew2);
						hisChgOrdMap.put("emailAddtionalOld", emailAddtionalOld2);
						billingGroupMapper.insHistory(hisChgOrdMap);
						//인서트 셋팅  끝
						
						Map<String, Object> updChangeMap = new HashMap<String, Object>();
						updChangeMap.put("newGrpFlag2", "Y");
	        			updChangeMap.put("custBillStusId", "8");
	        			updChangeMap.put("userId", userId);
	        			updChangeMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
	        			billingGroupMapper.updCustMaster(updChangeMap);
						
					}
						
					}
				}

			Map<String, Object> insBillGrpMap = new HashMap<String, Object>();
			insBillGrpMap.put("custBillSoId", String.valueOf(params.get("salesOrdId")));
			insBillGrpMap.put("custBillCustId", String.valueOf(params.get("custTypeId")));
			insBillGrpMap.put("custBillCntId", String.valueOf(params.get("custCntcId")));
			insBillGrpMap.put("custBillAddId", String.valueOf(params.get("custAddId")));
			insBillGrpMap.put("custBillStusId", "1");
			insBillGrpMap.put("custBillRem", String.valueOf(params.get("custBillRemark")));
			insBillGrpMap.put("userId", userId);
			insBillGrpMap.put("custBillPayTrm", "0");
			insBillGrpMap.put("custBillInchgMemId", "0");
			insBillGrpMap.put("custBillEmail", String.valueOf(params.get("email")));
			insBillGrpMap.put("custBillIsEstm", "0");
			insBillGrpMap.put("custBillIsSms", params.get("sms") != null ? String.valueOf(params.get("sms")) : "0");
			insBillGrpMap.put("custBillIsPost", params.get("post") != null ? String.valueOf(params.get("post")) : "0");
			
			int custBillIdSeq = billingGroupMapper.getSAL0024DSEQ();
			grpNo = billingGroupMapper.selectDocNo24Seq();
			insBillGrpMap.put("custBillIdSeq", custBillIdSeq);
			insBillGrpMap.put("grpNo", grpNo);
			billingGroupMapper.insBillGrpMaster(insBillGrpMap);
			
			Map<String, Object> updSalesMap = new HashMap<String, Object>();
			updSalesMap.put("userId", userId);
			updSalesMap.put("salesOrdId", String.valueOf(selectSalesOrderMs.get("salesOrdId")));
			updSalesMap.put("custBillId", custBillIdSeq);
			updSalesMap.put("newGrpFlag", "Y");
			//SALES ORDER MASTER UPDATE
			billingGroupMapper.updSalesOrderMaster(updSalesMap);
			
			String chkEstm = params.get("estm") != null ? String.valueOf(params.get("estm")) : "0";
			if(chkEstm.equals("1")  && !String.valueOf(params.get("email")).equals("") ){
				
				Map<String, Object> estmMap = new HashMap<String, Object>();
				estmMap.put("stusCodeId", "44");
				estmMap.put("custBillId", custBillIdSeq);
				estmMap.put("email", String.valueOf(params.get("email")));
				estmMap.put("cnfmCode", CommonUtils.getRandomNumber(10));
				estmMap.put("userId", userId);
				estmMap.put("defaultDate", defaultDate);
				estmMap.put("emailFailInd", "0");
				estmMap.put("emailFailDesc", "");
				estmMap.put("emailAdd", "");
				//estmReq 인서트
				billingGroupMapper.insEstmReq(estmMap);
			}
		}
		
		return grpNo;
	}

	@Override
	public boolean saveNewAddr(Map<String, Object> params, SessionVO sessionVO) {
		
		String defaultDate = "1900-01-01";
		int userId = sessionVO.getUserId();
		params.put("defaultDate", defaultDate);
		params.put("userId", userId);
		
		//베이직인포 조회.
		EgovMap selectBasicInfo = billingGroupMapper.selectBasicInfo(params);
		String custBillAddIdOld = selectBasicInfo.get("custBillAddId") != null ? String.valueOf(selectBasicInfo.get("custBillAddId")) : "" ;
		String custBillId = selectBasicInfo.get("custBillId") != null ?  String.valueOf(selectBasicInfo.get("custBillId")) : "";
				
		if(selectBasicInfo != null && Integer.parseInt(custBillId) > 0){
				
			//인서트 셋팅 시작
			String salesOrderIDOld = "0";
			String salesOrderIDNew = "0";
			String contactIDOld = "0";
			String contactIDNew = "0";
			String addressIDOld = custBillAddIdOld;
			String addressIDNew = String.valueOf(params.get("custAddId"));
			String statusIDOld = "0";
			String statusIDNew = "0";
			String remarkOld = "";
			String remarkNew = "";
			String emailOld = "";
			String emailNew = "";
			String isEStatementOld = "0";
			String isEStatementNew = "0";
			String isSMSOld = "0";
			String isSMSNew = "0";
			String isPostOld = "0";
			String isPostNew = "0";
			String typeId = "1042";
			String sysHisRemark = "[System] Change Mailing Address";
			String emailAddtionalNew = "";
			String emailAddtionalOld = "";
					
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
			//히스토리테이블 인서트
			billingGroupMapper.insHistory(insHisMap);
					
			//마스터테이블 업데이트
			Map<String, Object> updCustMap = new HashMap<String, Object>();
			updCustMap.put("userId", userId);
			updCustMap.put("addrFlag", "Y");
			updCustMap.put("addressIDNew", String.valueOf(params.get("custAddId")));
			updCustMap.put("custBillId", custBillId);
			billingGroupMapper.updCustMaster(updCustMap);
					
					
			List<EgovMap> selectSalesOrderM = billingGroupMapper.selectSalesOrderM(params);
			for(int i = 0 ; i < selectSalesOrderM.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)selectSalesOrderM.get(i);
				String salesOrdId = String.valueOf(map.get("salesOrdId"));
						
				Map<String, Object> updSalesMap = new HashMap<String, Object>();
				updSalesMap.put("salesOrdId", salesOrdId);
				updSalesMap.put("addressIDNew", String.valueOf(params.get("custAddId")));
				updSalesMap.put("addrFlag", "Y");
				//SALES ORDER MASTER UPDATE
				billingGroupMapper.updSalesOrderMaster(updSalesMap);
			}
			
			return true;
			
		}else{
			
			return false;
		}
	}

	@Override
	public boolean saveNewContPerson(Map<String, Object> params, SessionVO sessionVO) {
		
		String defaultDate = "1900-01-01";
		int userId = sessionVO.getUserId();
		params.put("defaultDate", defaultDate);
		params.put("userId", userId);
		
		EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(params);
		String custBillCntId = selectCustBillMaster.get("custBillCntId") != null ?  String.valueOf(selectCustBillMaster.get("custBillCntId")) : "" ;
		String custBillId = selectCustBillMaster.get("custBillId") != null ? String.valueOf(selectCustBillMaster.get("custBillId")) : "" ;
		
		if(selectCustBillMaster != null && Integer.parseInt(custBillId) > 0){
			
			//인서트 셋팅 시작
			String salesOrderIDOld = "0";
			String salesOrderIDNew = "0";
			String contactIDOld = custBillCntId;
			String contactIDNew = String.valueOf(params.get("custCntcId"));;
			String addressIDOld = "0";
			String addressIDNew = "0";
			String statusIDOld = "0";
			String statusIDNew = "0";
			String remarkOld = "";
			String remarkNew = "";
			String emailOld = "";
			String emailNew = "";
			String isEStatementOld = "0";
			String isEStatementNew = "0";
			String isSMSOld = "0";
			String isSMSNew = "0";
			String isPostOld = "0";
			String isPostNew = "0";
			String typeId = "1043";
			String sysHisRemark = "[System] Change Contact Person";
			String emailAddtionalNew = "";
			String emailAddtionalOld = "";
			
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
			
					
			//마스터테이블 업데이트
			Map<String, Object> updCustMap = new HashMap<String, Object>();
			updCustMap.put("contPerFlag", "Y");
			updCustMap.put("custBillId", custBillId);
			updCustMap.put("custBillCntId", String.valueOf(params.get("custCntcId")));
			updCustMap.put("userId", userId);
			billingGroupMapper.updCustMaster(updCustMap);
			
			//히스토리테이블 인서트
			billingGroupMapper.insHistory(insHisMap);
			
			List<EgovMap> selectSalesOrderM = billingGroupMapper.selectSalesOrderM(params);
			for(int i = 0 ; i < selectSalesOrderM.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)selectSalesOrderM.get(i);
				String salesOrdId = String.valueOf(map.get("salesOrdId"));
				
				//SALES ORDER MASTER UPDATE
				Map<String, Object> updSalesMap = new HashMap<String, Object>();
				updSalesMap.put("salesOrdId", salesOrdId);
				updSalesMap.put("conPerFlag", "Y");
				updSalesMap.put("custBillCntId", String.valueOf(params.get("custCntcId")));
				billingGroupMapper.updSalesOrderMaster(updSalesMap);
			}
			
			return true;
			
		}else{
			
			return false;
			
		}
	}

	@Override
	public boolean saveNewReq(Map<String, Object> params, SessionVO sessionVO) {
		
		String defaultDate = "1900-01-01";
		int userId = sessionVO.getUserId();
		params.put("defaultDate", defaultDate);
		params.put("userId", userId);	
		
		//master 조회.
		List<EgovMap> reqMaster = billingGroupMapper.selectReqMaster(params);
		EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(params);
		String custBillEmail = selectCustBillMaster.get("custBillEmail") != null ? String.valueOf(selectCustBillMaster.get("custBillEmail")) : "";
		String custBillIsEstm = selectCustBillMaster.get("custBillIsEstm") != null ? String.valueOf(selectCustBillMaster.get("custBillIsEstm")) : "";
		String custBillIsSms = selectCustBillMaster.get("custBillIsSms") != null ? String.valueOf(selectCustBillMaster.get("custBillIsSms")) : "";
		String custBillIsPost = selectCustBillMaster.get("custBillIsPost") != null ? String.valueOf(selectCustBillMaster.get("custBillIsPost")) : "";
		String custBillId = selectCustBillMaster.get("custBillId") != null ? String.valueOf(selectCustBillMaster.get("custBillId")) : "0";

		//인서트 셋팅 시작
		String salesOrderIDOld = "0";
		String salesOrderIDNew = "0";
		String contactIDOld = "0";
		String contactIDNew = "0";
		String addressIDOld = "0";
		String addressIDNew = "0";
		String statusIDOld = "0";
		String statusIDNew = "0";
		String remarkOld = "";
		String remarkNew = "";
		String emailOld = custBillEmail;
		String emailNew = String.valueOf(params.get("reqEmail")).trim();;
		String isEStatementOld = custBillIsEstm;
		String isEStatementNew = custBillIsEstm;
		String isSMSOld = custBillIsSms;
		String isSMSNew = custBillIsSms;
		String isPostOld = custBillIsPost;
		String isPostNew = custBillIsPost;
		String typeId = "1047";
		String sysHisRemark = "[System] E-Statement Request";
		String emailAddtionalNew = "";
		String emailAddtionalOld = "";
		
		if(selectCustBillMaster != null && Integer.parseInt(custBillId) > 0){
			
			if(reqMaster.size() > 0){
				for(int i = 0 ; i < reqMaster.size() ; i++){
					Map<String, Object> map = (Map<String, Object>)reqMaster.get(i);
					params.put("reqId", String.valueOf(map.get("reqId")));
					params.put("stusCodeId", 10);
					//REQ마스터테이블 업데이트
					billingGroupMapper.updReqEstm(params);
				}
			}
			
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
			
			//히스토리테이블 인서트
			billingGroupMapper.insHistory(insHisMap);

			Map<String, Object> estmMap = new HashMap<String, Object>();
			estmMap.put("stusCodeId", "44");
			estmMap.put("custBillId", String.valueOf(params.get("custBillId")));
			estmMap.put("email", String.valueOf(params.get("reqEmail")));
			estmMap.put("cnfmCode", CommonUtils.getRandomNumber(10));
			estmMap.put("userId", userId);
			estmMap.put("defaultDate", defaultDate);
			estmMap.put("emailFailInd", "0");
			estmMap.put("emailFailDesc", "");
			estmMap.put("emailAdd", "");
			//estmReq 인서트
			billingGroupMapper.insEstmReq(estmMap);
			
			return true;
			
		}else{
			return false;
		}
	}

}
