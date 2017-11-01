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
	
	

}
