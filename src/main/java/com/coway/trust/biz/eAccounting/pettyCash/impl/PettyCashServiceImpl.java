package com.coway.trust.biz.eAccounting.pettyCash.impl;

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
	public String selectNextIfKey() {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectNextIfKey();
	}

	@Override
	public int selectNextSeq(String ifKey) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectNextSeq(ifKey);
	}

	@Override
	public void insertPettyCashReqstInterface(Map<String, Object> params) {
		// TODO Auto-generated method stub
		pettyCashMapper.insertPettyCashReqstInterface(params);
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
	public void insertRqstApproveManagement(Map<String, Object> params) {
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
		pettyCashMapper.insertRqstApproveItems(params);
		
		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		pettyCashMapper.updateRqstAppvPrcssNo(params);
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
	public void insertPettyCashExp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		List<Object> gridDataList = (List<Object>) params.get("gridDataList");
		
		Map<String, Object> masterData = (Map<String, Object>) gridDataList.get(0);
		
		String clmNo = pettyCashMapper.selectNextExpClmNo();
		params.put("clmNo", clmNo);
		
		masterData.put("clmNo", clmNo);
		masterData.put("allTotAmt", params.get("allTotAmt"));
		masterData.put("userId", params.get("userId"));
		masterData.put("userName", params.get("userName"));
		
		LOGGER.debug("masterData =====================================>>  " + masterData);
		pettyCashMapper.insertPettyCashExp(masterData);
		
		String clamUn = null;
		
		for(int i = 0; i < gridDataList.size(); i++) {
			Map<String, Object> item = (Map<String, Object>) gridDataList.get(i);
			int clmSeq = pettyCashMapper.selectNextExpClmSeq(clmNo);
			item.put("clmNo", clmNo);
			item.put("clmSeq", clmSeq);
			item.put("userId", params.get("userId"));
			item.put("userName", params.get("userName"));
			LOGGER.debug("item =====================================>>  " + item);
			pettyCashMapper.insertPettyCashExpItem(item);
		}
	}

	@Override
	public List<EgovMap> selectExpenseItems(String clmNo) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectExpenseItems(clmNo);
	}

	@Override
	public EgovMap selectExpenseInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectExpenseInfo(params);
	}

	@Override
	public EgovMap selectExpenseInfoForAppv(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectExpenseInfoForAppv(params);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectAttachList(atchFileGrpId);
	}

	@Override
	public void updatePettyCashExp(Map<String, Object> params) {
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
				int clmSeq = pettyCashMapper.selectNextExpClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertPettyCashExpItem =====================================>>  " + hm);
				pettyCashMapper.insertPettyCashExpItem(hm);
				pettyCashMapper.updatePettyCashExpTotAmt(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;
			hm = (Map<String, Object>) updateList.get(0);
			hm.put("clmNo", params.get("clmNo"));
			hm.put("allTotAmt", params.get("allTotAmt"));
			hm.put("userId", params.get("userId"));
			hm.put("userName", params.get("userName"));
			LOGGER.debug("updatePettyCashExp =====================================>>  " + hm);
			pettyCashMapper.updatePettyCashExp(hm);
			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("updatePettyCashExpItem =====================================>>  " + hm);
				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
				pettyCashMapper.updatePettyCashExpItem(hm);
			}
		}
		
		LOGGER.info("추가 : {}", addList.toString());
		LOGGER.info("수정 : {}", updateList.toString());
	}

	@Override
	public void insertExpApproveManagement(Map<String, Object> params) {
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
				int appvItmSeq = webInvoiceMapper.selectNextAppvItmSeq(String.valueOf(params.get("appvPrcssNo")));
				hm.put("appvItmSeq", appvItmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveItems =====================================>>  " + hm);
				// TODO appvLineItemsTable Insert
				pettyCashMapper.insertExpApproveItems(hm);
			}
		}
		
		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		pettyCashMapper.updateExpAppvPrcssNo(params);
	}

	@Override
	public void deletePettyCashExpItem(Map<String, Object> params) {
		// TODO Auto-generated method stub
		pettyCashMapper.deletePettyCashExpItem(params);
	}

	@Override
	public void updatePettyCashExpTotAmt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		pettyCashMapper.updatePettyCashExpTotAmt(params);
	}

	@Override
	public List<EgovMap> selectExpenseItemGrp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectExpenseItemGrp(params);
	}
	
	

	

}
