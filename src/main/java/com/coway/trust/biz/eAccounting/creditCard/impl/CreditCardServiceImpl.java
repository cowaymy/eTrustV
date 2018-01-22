package com.coway.trust.biz.eAccounting.creditCard.impl;

import java.sql.Date;
import java.util.ArrayList;
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

import com.coway.trust.biz.eAccounting.creditCard.CreditCardService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("creditCardService")
public class CreditCardServiceImpl implements CreditCardService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Resource(name = "creditCardMapper")
	private CreditCardMapper creditCardMapper;
	
	@Autowired
	private WebInvoiceMapper webInvoiceMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectCrditCardMgmtList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectCrditCardMgmtList(params);
	}

	@Override
	public List<EgovMap> selectBankCode() {
		// TODO Auto-generated method stub
		return creditCardMapper.selectBankCode();
	}
	
	@Override
	public int selectNextCrditCardSeq() {
		// TODO Auto-generated method stub
		return creditCardMapper.selectNextCrditCardSeq();
	}

	@Override
	public void insertCreditCard(Map<String, Object> params) {
		// TODO Auto-generated method stub
		creditCardMapper.insertCreditCard(params);
	}

	@Override
	public String selectNextIfKey() {
		// TODO Auto-generated method stub
		return creditCardMapper.selectNextIfKey();
	}

	@Override
	public int selectNextSeq(String ifKey) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectNextSeq(ifKey);
	}

	@Override
	public void insertCrditCardInterface(Map<String, Object> params) {
		// TODO Auto-generated method stub
		creditCardMapper.insertCrditCardInterface(params);
	}

	@Override
	public EgovMap selectCrditCardInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectCrditCardInfo(params);
	}

	@Override
	public void updateCreditCard(Map<String, Object> params) {
		// TODO Auto-generated method stub
		creditCardMapper.updateCreditCard(params);
	}

	@Override
	public void removeCreditCard(Map<String, Object> params) {
		// TODO Auto-generated method stub
		creditCardMapper.removeCreditCard(params);
	}

	@Override
	public List<EgovMap> selectReimbursementList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectReimbursementList(params);
	}

	@Override
	public List<EgovMap> selectTaxCodeCreditCardFlag() {
		// TODO Auto-generated method stub
		return creditCardMapper.selectTaxCodeCreditCardFlag();
	}

	@Override
	public EgovMap selectCrditCardInfoByNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectCrditCardInfoByNo(params);
	}

	@Override
	public void insertReimbursement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		List<Object> gridDataList = (List<Object>) params.get("gridDataList");
		
		Map<String, Object> masterData = (Map<String, Object>) gridDataList.get(0);
		
		String clmNo = creditCardMapper.selectNextClmNo();
		params.put("clmNo", clmNo);
		
		masterData.put("clmNo", clmNo);
		masterData.put("allTotAmt", params.get("allTotAmt"));
		masterData.put("userId", params.get("userId"));
		masterData.put("userName", params.get("userName"));
		
		LOGGER.debug("masterData =====================================>>  " + masterData);
		creditCardMapper.insertReimbursement(masterData);
		
		for(int i = 0; i < gridDataList.size(); i++) {
			Map<String, Object> item = (Map<String, Object>) gridDataList.get(i);
			int clmSeq = creditCardMapper.selectNextClmSeq(clmNo);
			item.put("clmNo", clmNo);
			item.put("clmSeq", clmSeq);
			item.put("userId", params.get("userId"));
			item.put("userName", params.get("userName"));
			LOGGER.debug("item =====================================>>  " + item);
			creditCardMapper.insertReimbursementItem(item);
		}
	}

	@Override
	public List<EgovMap> selectReimbursementItems(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectReimbursementItems(params);
	}

	@Override
	public EgovMap selectReimburesementInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectReimburesementInfo(params);
	}

	@Override
	public EgovMap selectReimburesementInfoForAppv(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectReimburesementInfoForAppv(params);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectAttachList(atchFileGrpId);
	}

	@Override
	public void updateReimbursement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		// TODO editGridDataList GET
		List<Object> addList = (List<Object>) params.get("add"); // 추가 리스트 얻기
		List<Object> updateList = (List<Object>) params.get("update"); // 수정 리스트 얻기
		
		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("allTotAmt", params.get("allTotAmt"));
				int clmSeq = creditCardMapper.selectNextClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertReimbursementItem =====================================>>  " + hm);
				creditCardMapper.insertReimbursementItem(hm);
				creditCardMapper.updateReimbursementTotAmt(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;
			hm = (Map<String, Object>) updateList.get(0);
			hm.put("clmNo", params.get("clmNo"));
			hm.put("allTotAmt", params.get("allTotAmt"));
			hm.put("userId", params.get("userId"));
			hm.put("userName", params.get("userName"));
			LOGGER.debug("updateReimbursement =====================================>>  " + hm);
			creditCardMapper.updateReimbursement(hm);
			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("updateReimbursementItem =====================================>>  " + hm);
				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
				creditCardMapper.updateReimbursementItem(hm);
			}
		}
		
		LOGGER.info("추가 : {}", addList.toString());
		LOGGER.info("수정 : {}", updateList.toString());
	}

	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		List<Object> newGridList = (List<Object>) params.get("newGridList");

		params.put("appvLineCnt", apprGridList.size());
		
		LOGGER.debug("insertApproveManagement =====================================>>  " + params);
		webInvoiceMapper.insertApproveManagement(params);
		
		if (apprGridList.size() > 0) {
			Map hm = null;
			
			for (Object map : apprGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveLineDetail =====================================>>  " + hm);
				// TODO appvLineDetailTable Insert
				webInvoiceMapper.insertApproveLineDetail(hm);
			}
		}
		
		if (newGridList.size() > 0) {
			Map hm = null;
			
			// biz처리
			for (Object map : newGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				//int appvItmSeq = webInvoiceMapper.selectNextAppvItmSeq(String.valueOf(params.get("appvPrcssNo")));
				//hm.put("appvItmSeq", appvItmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveItems =====================================>>  " + hm);
				// TODO appvLineItemsTable Insert
				creditCardMapper.insertApproveItems(hm);
			}
		}
		
		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		creditCardMapper.updateAppvPrcssNo(params);
	}

	@Override
	public void deleteReimbursement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		creditCardMapper.deleteReimbursement(params);
	}

	@Override
	public void updateReimbursementTotAmt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		creditCardMapper.updateReimbursementTotAmt(params);
	}

	@Override
	public List<EgovMap> selectCreditCardNoToMgmt() {
		// TODO Auto-generated method stub
		return creditCardMapper.selectCreditCardNoToMgmt();
	}

	@Override
	public List<EgovMap> selectReimbursementItemGrp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectReimbursementItemGrp(params);
	}

	@Override
	public List<EgovMap> selectReimbursementItemGrpForAppv(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectReimbursementItemGrpForAppv(params);
	}
	
	
	

}
