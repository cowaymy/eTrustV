package com.coway.trust.biz.eAccounting.ctClaim.impl;

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

import com.coway.trust.biz.eAccounting.ctClaim.CtClaimService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ctClaimService")
public class CtClaimServiceImpl implements CtClaimService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name = "ctClaimMapper")
	private CtClaimMapper ctClaimMapper;
	
	@Autowired
	private WebInvoiceMapper webInvoiceMapper;
	
	@Override
	public List<EgovMap> selectCtClaimList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctClaimMapper.selectCtClaimList(params);
	}

	@Override
	public List<EgovMap> selectTaxCodeCtClaimFlag() {
		// TODO Auto-generated method stub
		return ctClaimMapper.selectTaxCodeCtClaimFlag();
	}

	@Override
	public void insertCtClaimExp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		List<Object> gridDataList = (List<Object>) params.get("gridDataList");
		
		Map<String, Object> masterData = (Map<String, Object>) gridDataList.get(0);
		
		String clmNo = ctClaimMapper.selectNextClmNo();
		params.put("clmNo", clmNo);
		
		masterData.put("clmNo", clmNo);
		masterData.put("allTotAmt", params.get("allTotAmt"));
		masterData.put("userId", params.get("userId"));
		masterData.put("userName", params.get("userName"));
		
		LOGGER.debug("masterData =====================================>>  " + masterData);
		ctClaimMapper.insertCtClaimExp(masterData);
		
		for(int i = 0; i < gridDataList.size(); i++) {
			Map<String, Object> item = (Map<String, Object>) gridDataList.get(i);
			int clmSeq = ctClaimMapper.selectNextClmSeq(clmNo);
			item.put("clmNo", clmNo);
			item.put("clmSeq", clmSeq);
			item.put("userId", params.get("userId"));
			item.put("userName", params.get("userName"));
			LOGGER.debug("insertSmGmClaimExpItem =====================================>>  " + item);
			ctClaimMapper.insertCtClaimExpItem(item);
			// Expense Type Name == Car Mileage Expense
	        //$("#expTypeName").val() == "Car Mileage Expense"
	        // WebInvoice Test는 Test
			LOGGER.debug("expGrp =====================================>>  " + item.get("expGrp"));
			if("1".equals(item.get("expGrp"))) {
				LOGGER.debug("insertSmGmClaimExpMileage =====================================>>  " + item);
				ctClaimMapper.insertCtClaimExpMileage(item);
			}
		}
	}

	@Override
	public List<EgovMap> selectCtClaimItems(String clmNo) {
		// TODO Auto-generated method stub
		return ctClaimMapper.selectCtClaimItems(clmNo);
	}

	@Override
	public EgovMap selectCtClaimInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctClaimMapper.selectCtClaimInfo(params);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return ctClaimMapper.selectAttachList(atchFileGrpId);
	}

	@Override
	public void updateCtClaimExp(Map<String, Object> params) {
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
				int clmSeq = ctClaimMapper.selectNextClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertStaffClaimExpItem =====================================>>  " + hm);
				ctClaimMapper.insertCtClaimExpItem(hm);
				// Expense Type Name == Car Mileage Expense
		        //$("#expTypeName").val() == "Car Mileage Expense"
		        // WebInvoice Test는 Test
				LOGGER.debug("expGrp =====================================>>  " + hm.get("expGrp"));
				if("1".equals(hm.get("expGrp"))) {
					LOGGER.debug("insertStaffClaimExpMileage =====================================>>  " + hm);
					ctClaimMapper.insertCtClaimExpMileage(hm);
				}
				ctClaimMapper.updateCtClaimExpTotAmt(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;
			hm = (Map<String, Object>) updateList.get(0);
			hm.put("clmNo", params.get("clmNo"));
			hm.put("allTotAmt", params.get("allTotAmt"));
			hm.put("userId", params.get("userId"));
			hm.put("userName", params.get("userName"));
			LOGGER.debug("updateStaffClaimExp =====================================>>  " + hm);
			ctClaimMapper.updateCtClaimExp(hm);
			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("updateStaffClaimExpItem =====================================>>  " + hm);
				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
				ctClaimMapper.updateCtClaimExpItem(hm);
				// Expense Type Name == Car Mileage Expense
		        //$("#expTypeName").val() == "Car Mileage Expense"
		        // WebInvoice Test는 Test
				LOGGER.debug("expGrp =====================================>>  " + hm.get("expGrp"));
				if("1".equals(hm.get("expGrp"))) {
					LOGGER.debug("updateStaffClaimExpMileage =====================================>>  " + hm);
					ctClaimMapper.updateCtClaimExpMileage(hm);
				}
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
				ctClaimMapper.insertApproveItems(hm);
			}
		}
		
		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		ctClaimMapper.updateAppvPrcssNo(params);
	}

	@Override
	public void deleteCtClaimExpItem(Map<String, Object> params) {
		// TODO Auto-generated method stub
		ctClaimMapper.deleteCtClaimExpItem(params);
	}

	@Override
	public void deleteCtClaimExpMileage(Map<String, Object> params) {
		// TODO Auto-generated method stub
		ctClaimMapper.deleteCtClaimExpMileage(params);
	}

	@Override
	public void updateCtClaimExpTotAmt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		ctClaimMapper.updateCtClaimExpTotAmt(params);
	}

	@Override
	public List<EgovMap> selectCtClaimItemGrp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctClaimMapper.selectCtClaimItemGrp(params);
	}

}
