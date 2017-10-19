package com.coway.trust.biz.eAccounting.webInvoice.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("webInvoiceService")
public class WebInvoiceServiceImpl implements WebInvoiceService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;
	
	@Resource(name = "webInvoiceMapper")
	private WebInvoiceMapper webInvoiceMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectWebInvoiceList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceList(params);
	}
	
	@Override
	public List<EgovMap> selectApproveList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectApproveList(params);
	}

	@Override
	public EgovMap selectWebInvoiceInfo(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceInfo(clmNo);
	}
	
	@Override
	public List<EgovMap> selectAppvInfoAndItems(String appvPrcssNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAppvInfoAndItems(appvPrcssNo);
	}

	@Override
	public List<EgovMap> selectWebInvoiceItems(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceItems(clmNo);
	}
	
	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAttachList(atchFileGrpId);
	}
	
	@Override
	public EgovMap selectAttachmentInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAttachmentInfo(params);
	}

	@Override
	public void insertWebInvoiceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		
		LOGGER.debug("insertWebInvoiceInfo =====================================>>  " + params);
		
		webInvoiceMapper.insertWebInvoiceInfo(params);
		
		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");
		
		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기
		
		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", (String) params.get("clmNo"));
				int clmSeq = webInvoiceMapper.selectNextClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("userId", params.get("userId"));
				LOGGER.debug("insertWebInvoiceDetail =====================================>>  " + params);
				webInvoiceMapper.insertWebInvoiceDetail(hm);
			}
		}

		
		LOGGER.info("추가 : {}", addList.toString());
	}
	
	@Override
	public void updateWebInvoiceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.updateWebInvoiceInfo(params);
		
		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");
		
		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기
		List<Object> updateList = (List<Object>) gridData.get("update"); // 수정 리스트 얻기
		List<Object> removeList = (List<Object>) gridData.get("remove"); // 제거 리스트 얻기
		
		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				int clmSeq = webInvoiceMapper.selectNextClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("userId", params.get("userId"));
				webInvoiceMapper.insertWebInvoiceDetail(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;
			
			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
				webInvoiceMapper.updateWebInvoiceDetail(hm);
			}
		}
		if (removeList.size() > 0) {
			Map hm = null;
			
			for (Object map : removeList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				// TODO biz처리 (clmNo, clmSeq 값으로 delete 처리)
				webInvoiceMapper.deleteWebInvoiceDetail(hm);
			}
		}
		
		LOGGER.info("추가 : {}", addList.toString());
		LOGGER.info("수정 : {}", updateList.toString());
		LOGGER.info("삭제 : {}", removeList.toString());
	}
	
	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		List<Object> newGridList = (List<Object>) params.get("newGridList");
		
		params.put("appvLineCnt", apprGridList.size());
		
		webInvoiceMapper.insertApproveManagement(params);
		
		if (apprGridList.size() > 0) {
			Map hm = null;
			
			for (Object map : apprGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				hm.put("userId", params.get("userId"));
				params.put("userName", params.get("userName"));
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
				hm.put("invcNo", params.get("invcNo"));
				hm.put("invcDt", params.get("invcDt"));
				hm.put("invcType", params.get("invcType"));
				hm.put("memAccId", params.get("memAccId"));
				hm.put("payDueDt", params.get("payDueDt"));
				hm.put("costCentr", params.get("costCentr"));
				hm.put("costCentrName", params.get("costCentrName"));
				hm.put("atchFileGrpId", params.get("atchFileGrpId"));
				hm.put("userName", params.get("userName"));
				// TODO appvLineItemsTable Insert
				webInvoiceMapper.insertApproveItems(hm);
			}
		}
		
		webInvoiceMapper.updateAppvPrcssNo(params);
	}

	@Override
	public void updateApprovalInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<Object> invoAppvGridList = (List<Object>) params.get("invoAppvGridList");
		for (int i = 0; i < invoAppvGridList.size(); i++) {
			Map<String, Object> invoAppvInfo = (Map<String, Object>) invoAppvGridList.get(i);
			if("R".equals(invoAppvInfo.get("appvPrcssStusCode"))) {
				String appvPrcssNo = (String) invoAppvInfo.get("appvPrcssNo");
				int appvLineSeq = (int) invoAppvInfo.get("appvLineSeq");
				int appvLineCnt = webInvoiceMapper.selectAppvLineCnt(appvPrcssNo);
				int appvLinePrcssCnt = webInvoiceMapper.selectAppvLinePrcssCnt(appvPrcssNo);
				invoAppvInfo.put("appvLinePrcssCnt", appvLinePrcssCnt + 1);
				invoAppvInfo.put("appvPrcssStus", "P");
				invoAppvInfo.put("appvStus", "A");
				invoAppvInfo.put("userId", params.get("userId"));
				webInvoiceMapper.updateAppvInfo(invoAppvInfo);
				webInvoiceMapper.updateAppvLine(invoAppvInfo);
				LOGGER.debug("now invoAppvInfo =====================================>>  " + invoAppvInfo);
				// TODO 다음 승인자 R처리
				if(appvLineCnt > appvLineSeq) {
					invoAppvInfo.put("appvStus", "R");
					invoAppvInfo.put("appvLineSeq", appvLineSeq + 1);
					webInvoiceMapper.updateAppvLine(invoAppvInfo);
					LOGGER.debug("next invoAppvInfo =====================================>>  " + invoAppvInfo);
				}
				if(appvLineCnt == appvLinePrcssCnt + 1) {
					// 마지막 승인인 경우 재업데이트
					webInvoiceMapper.updateLastAppvLine(invoAppvInfo);
					LOGGER.debug("last invoAppvInfo =====================================>>  " + invoAppvInfo);
					// TODO 인터페이스 생성
					String ifKey = webInvoiceMapper.selectNextIfKey();
					// appvPrcssNo의 items get
					List<EgovMap> appvInfoAndItems = webInvoiceMapper.selectAppvInfoAndItems(appvPrcssNo);
					for(int j = 0; j < appvInfoAndItems.size(); j++) {
						Map<String, Object> invoAppvItems = (Map<String, Object>) appvInfoAndItems.get(j);
						int seq = webInvoiceMapper.selectNextSeq(ifKey);
						invoAppvItems.put("ifKey", ifKey);
						invoAppvItems.put("seq", seq);
						invoAppvItems.put("userId", params.get("userId"));
						webInvoiceMapper.insertEccInterface(invoAppvItems);
						LOGGER.debug("invoAppvItems =====================================>>  " + invoAppvItems);
					}
				}
			}
		}
	}

	@Override
	public void updateRejectionInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<Object> invoAppvGridList = (List<Object>) params.get("invoAppvGridList");
		String rejctResn = (String) params.get("rejctResn");
		for (int i = 0; i < invoAppvGridList.size(); i++) {
			Map<String, Object> invoAppvInfo = (Map<String, Object>) invoAppvGridList.get(i);
			if("R".equals(invoAppvInfo.get("appvPrcssStusCode"))) {
				String appvPrcssNo = (String) invoAppvInfo.get("appvPrcssNo");
				int appvLineCnt = webInvoiceMapper.selectAppvLineCnt(appvPrcssNo);
				int appvLinePrcssCnt = webInvoiceMapper.selectAppvLinePrcssCnt(appvPrcssNo);
				invoAppvInfo.put("appvLinePrcssCnt", appvLinePrcssCnt + 1);
				invoAppvInfo.put("appvPrcssStus", "J");
				invoAppvInfo.put("appvStus", "J");
				invoAppvInfo.put("rejctResn", rejctResn);
				invoAppvInfo.put("userId", params.get("userId"));
				webInvoiceMapper.updateAppvInfo(invoAppvInfo);
				webInvoiceMapper.updateAppvLine(invoAppvInfo);
				LOGGER.debug("rejct invoAppvInfo =====================================>>  " + invoAppvInfo);
			}
		}
	}

	@Override
	public List<EgovMap> selectSupplier(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectSupplier(params);
	}

	@Override
	public List<EgovMap> selectCostCenter(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectCostCenter(params);
	}
	
	@Override
	public List<EgovMap> selectTaxCodeWebInvoiceFlag() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectTaxCodeWebInvoiceFlag();
	}
	
	@Override
	public String selectNextClmNo() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectNextClmNo();
	}

	@Override
	public String selectNextAppvPrcssNo() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectNextAppvPrcssNo();
	}

	@Override
	public String selectNextIfKey() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectNextIfKey();
	}

	@Override
	public List<Object> budgetCheck(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<Object> list = new ArrayList<Object>();
		List<Object> newGridList = (List<Object>) params.get("newGridList");
		for(int i = 0; i < newGridList.size(); i++) {
			Map<String, Object> data = (Map<String, Object>) newGridList.get(i);
			data.put("year", params.get("year"));
			data.put("month", params.get("month"));
			data.put("costCentr", params.get("costCentr"));
			LOGGER.debug("data =====================================>>  " + data);
			String yN = webInvoiceMapper.budgetCheck(data);
			LOGGER.debug("yN =====================================>>  " + yN);
			if("N".equals(yN)) {
				list.add(data.get("clmSeq"));
			}
		}
		
		LOGGER.debug("list =====================================>>  " + list);
		LOGGER.debug("list.size() =====================================>>  " + list.size());
		
		return list;
	}

	@Override
	public String getAppvPrcssStus(List<EgovMap> appvInfoAndItems) {
		// TODO Auto-generated method stub
		LOGGER.debug("appvInfoAndItems =====================================>>  " + appvInfoAndItems);
		
		EgovMap appvInfo = appvInfoAndItems.get(0);
		String reqstUserId = (String) appvInfo.get("reqstUserId");
		String reqstDt = (String) appvInfo.get("reqstDt");
		int appvLinePrcssCnt = Integer.parseInt(String.valueOf(appvInfo.get("appvLinePrcssCnt")));
		String appvPrcssStus = "- Request By " + reqstUserId + " [" + reqstDt + "]";
		if(appvLinePrcssCnt == 0) {
			String appvLineUserId = (String) appvInfo.get("appvLineUserId");
			appvPrcssStus += "<br> - Pending By " + appvLineUserId;
		} else {
			for(int i = 0; i < appvInfoAndItems.size(); i++) {
				EgovMap appvLine = appvInfoAndItems.get(i);
				String appvStus = (String) appvLine.get("appvStus");
				String appvLineUserId = (String) appvInfo.get("appvLineUserId");
				String appvDt = (String) appvInfo.get("appvDt");
				if("R".equals(appvStus)) {
					appvPrcssStus += "<br> - Pending By " + appvLineUserId;
				} else if ("A".equals(appvStus)) {
					appvPrcssStus += "<br> - Approval By " + appvLineUserId + " [" + appvDt + "]";
				} else if ("J".equals(appvStus)) {
					appvPrcssStus += "<br> - Reject By " + appvLineUserId + " [" + appvDt + "]";
				}
			}
		}
		return appvPrcssStus;
	}
	
	
	
	

}
