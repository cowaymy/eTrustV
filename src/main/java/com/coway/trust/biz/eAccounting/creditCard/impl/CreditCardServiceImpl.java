package com.coway.trust.biz.eAccounting.creditCard.impl;

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
	public List<EgovMap> selectReimbursementItems(String clmNo) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectReimbursementItems(clmNo);
	}

	@Override
	public EgovMap selectReimburesementInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectReimburesementInfo(params);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return creditCardMapper.selectAttachList(atchFileGrpId);
	}
	
	

}
