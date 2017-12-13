package com.coway.trust.biz.payment.reconciliation.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.coway.trust.biz.payment.reconciliation.service.AccountReconciliationService;
import com.coway.trust.cmmn.model.SessionVO;
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

@Service("accountReconciliationService")
public class AccountReconciliationServiceImpl extends EgovAbstractServiceImpl implements AccountReconciliationService {

	@Resource(name = "accountReconciliationMapper")
	private AccountReconciliationMapper accountReconciliationMapper;
	
	private static final Logger logger = LoggerFactory.getLogger(AccountReconciliationServiceImpl.class);

	@Override
	public List<EgovMap> selectJournalMasterList(Map<String, Object> params) {
		return accountReconciliationMapper.selectJournalMasterList(params);
	}

	@Override
	public List<EgovMap> selectJournalMasterView(Map<String, Object> params) {
		return accountReconciliationMapper.selectJournalMasterView(params);
	}

	@Override
	public List<EgovMap> selectJournalDetailList(Map<String, Object> params) {
		return accountReconciliationMapper.selectJournalDetailList(params);
	}

	@Override
	public String selectGrossTotal(Map<String, Object> params) {
		return accountReconciliationMapper.selectGrossTotal(params);
	}
	
	@Override
	public String selectCRCStatementGrossTotal(Map<String, Object> params) {
		return accountReconciliationMapper.selectCRCStatementGrossTotal(params);
	}

	@Transactional
	public boolean updJournalPassEntry(Map<String, Object> params, SessionVO sessionVO) {
		Map<String, Object> route = new HashMap<String, Object>();
		int routeResult = 0;
		int route2Result = 0;
		int transResult = 0;
		
		int fTrnscCrditAmt =  (int)Double.parseDouble((String)params.get("fTrnscCrditAmt"));
		int fTrnscDebtAmt =  (int)Double.parseDouble((String)params.get("fTrnscDebtAmt"));
		
		route.put("glBatchNo", 0);
		route.put("glBatchTypeDesc", "");
		route.put("glBatchTotal", fTrnscCrditAmt  == 0 ? -1 * fTrnscDebtAmt : fTrnscCrditAmt);
		route.put("glReceiptNo", String.valueOf(params.get("lblRefNo")));
		route.put("glReceiptTypeId", 1033);
		route.put("glReceiptBranchId", 42);
		route.put("glReceiptSettleAccId", String.valueOf(params.get("fBankJrnlAccId")));
		route.put("glReceiptAccountId", String.valueOf(params.get("fBankJrnlAccId")));
		route.put("glReceiptItemId", 0);
		route.put("glReceiptItemModeId", 0);
		route.put("glReverseReceiptItemId", 0);
		
		if(String.valueOf(params.get("journalEntryAccount")).equals("203")){
			
			route.put("glReceiptItemAmount", fTrnscCrditAmt  == 0 ? fTrnscDebtAmt : fTrnscCrditAmt);
			
		}else{
			
			route.put("glReceiptItemAmount", fTrnscCrditAmt  == 0 ? -1 * fTrnscDebtAmt : -1 * fTrnscCrditAmt);
		}
		
		route.put("glReceiptItemCharges", 0);
		route.put("glReceiptItemRCLStatus", "Y");
		route.put("glJournalNo", String.valueOf(params.get("lblRefNo")));
		route.put("glAuditReference", String.valueOf(params.get("fTrnscId")));
		route.put("glConversionStatus", "N");
		routeResult = accountReconciliationMapper.insAccGLRoutes(route);
		
		Map<String, Object> route2 = new HashMap<String, Object>();
		route2.put("glBatchNo", 0);
		route2.put("glBatchTypeDesc", "");
		route2.put("glBatchTotal", fTrnscCrditAmt  == 0 ? fTrnscDebtAmt : fTrnscCrditAmt);
		route2.put("glReceiptNo", String.valueOf(params.get("lblRefNo")));
		route2.put("glReceiptTypeId", 1033);
		route2.put("glReceiptBranchId", 42);
		route2.put("glReceiptSettleAccId", String.valueOf(params.get("journalEntryAccount")));
		route2.put("glReceiptAccountId", String.valueOf(params.get("journalEntryAccount")));
		route2.put("glReceiptItemId", 0);
		route2.put("glReceiptItemModeId", 0);
		route2.put("glReverseReceiptItemId", 0);
		route2.put("glReceiptItemAmount", fTrnscCrditAmt  == 0 ?  fTrnscDebtAmt : fTrnscCrditAmt);
		route2.put("glReceiptItemCharges", 0);
		route2.put("glReceiptItemRCLStatus", "Y");
		route2.put("glJournalNo", String.valueOf(params.get("lblRefNo")));
		route2.put("glAuditReference", String.valueOf(params.get("fTrnscId")));
		route2.put("glConversionStatus", "N");
		route2Result = accountReconciliationMapper.insAccGLRoutes(route2);
		
		Map<String, Object> transMap = new HashMap<String, Object>();
		transMap.put("fTransactionId", String.valueOf(params.get("fTrnscId")));
		transMap.put("fTransactionInstruction", String.valueOf(params.get("fRemark")).trim());
		transMap.put("fTransactionIsMatch", true);
		transMap.put("fTransactionUpdateBy", sessionVO.getUserId());
		transResult = accountReconciliationMapper.updJournalTrans(transMap);
		
		if(routeResult > 0&& route2Result > 0 &&transResult > 0){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public boolean updJournalExclude(Map<String, Object> params, SessionVO sessionVO) {
		int transResult = 0;
		
		Map<String, Object> transMap = new HashMap<String, Object>();
		transMap.put("fTransactionId", String.valueOf(params.get("fTrnscId")));
		transMap.put("fTransactionInstruction", String.valueOf(params.get("remark")).trim());
		transMap.put("fTransactionIsMatch", true);
		transMap.put("fTransactionUpdateBy", sessionVO.getUserId());
		transResult = accountReconciliationMapper.updJournalTrans(transMap);
		
		if(transResult > 0)
			return true;
		else
			return false;
	}

	@Override
	public String selectOrderIDByOrderNo(Map<String, Object> params) {
		return accountReconciliationMapper.selectOrderIDByOrderNo(params);
	}

	@Override
	public Map<String, Object> selectOutStandingView(Map<String, Object> param) {
		return accountReconciliationMapper.selectOutStandingView(param);
	}

	@Override
	public List<EgovMap> selectASInfoList(Map<String, Object> params) {
		return accountReconciliationMapper.selectASInfoList(params);
	}
}
