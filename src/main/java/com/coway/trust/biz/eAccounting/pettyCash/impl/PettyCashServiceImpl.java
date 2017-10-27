package com.coway.trust.biz.eAccounting.pettyCash.impl;

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

import com.coway.trust.biz.eAccounting.pettyCash.PettyCashService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("pettyCashService")
public class PettyCashServiceImpl implements PettyCashService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Autowired
	private WebInvoiceMapper webInvoiceMapper;
	
	@Resource(name = "pettyCashMapper")
	private PettyCashMapper pettyCashMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectCustodianList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectCustodianList(params);
	}

	@Override
	public String selectUserNric(String memAccId) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectUserNric(memAccId);
	}

	@Override
	public void insertCustodian(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		pettyCashMapper.insertCustodian(params);
	}

	@Override
	public EgovMap selectCustodianInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectCustodianInfo(params);
	}

	@Override
	public void updateCustodian(Map<String, Object> params) {
		// TODO Auto-generated method stub
		pettyCashMapper.updateCustodian(params);
	}

	@Override
	public void deleteCustodian(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		pettyCashMapper.deleteCustodian(params);
	}

	@Override
	public List<EgovMap> selectRequestList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectRequestList(params);
	}
	
	@Override
	public String selectNextRqstClmNo() {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectNextRqstClmNo();
	}

	@Override
	public void insertPettyCashReqst(Map<String, Object> params) {
		// TODO Auto-generated method stub
		pettyCashMapper.insertPettyCashReqst(params);
	}
	
	@Override
	public EgovMap selectRequestInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectRequestInfo(params);
	}
	
	@Override
	public void updatePettyCashReqst(Map<String, Object> params) {
		// TODO Auto-generated method stub
		pettyCashMapper.updatePettyCashReqst(params);
	}

	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		
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
		
		int appvItmSeq = webInvoiceMapper.selectNextAppvItmSeq(String.valueOf(params.get("appvPrcssNo")));
		params.put("appvItmSeq", appvItmSeq);
		LOGGER.debug("insertApproveItems =====================================>>  " + params);
		// TODO appvLineItemsTable Insert
		pettyCashMapper.insertApproveItems(params);
		
		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		pettyCashMapper.updateAppvPrcssNo(params);
	}

	@Override
	public List<EgovMap> selectExpenseList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectExpenseList(params);
	}

	@Override
	public List<EgovMap> selectTaxCodePettyCashFlag() {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectTaxCodePettyCashFlag();
	}

	@Override
	public String selectNextExpClmNo() {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectNextExpClmNo();
	}

	@Override
	public void insertPettyCashExp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		pettyCashMapper.insertPettyCashExp(params);
	}
	
	@Override
	public int selectNextExpClmSeq(String clmNo) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectNextExpClmSeq(clmNo);
	}

	@Override
	public void insertPettyCashExpItem(Map<String, Object> params) {
		// TODO Auto-generated method stub
		pettyCashMapper.insertPettyCashExpItem(params);
	}

	@Override
	public void updateExpTotAmt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		pettyCashMapper.updateExpTotAmt(params);
	}
	
	

	

}
