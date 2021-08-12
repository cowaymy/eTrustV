package com.coway.trust.biz.logistics.adjustment.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.logistics.adjustment.CountStockAuditService;
import com.coway.trust.biz.logistics.adjustment.StockAuditService;
import com.coway.trust.biz.logistics.pointofsales.impl.PointOfSalesMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.logistics.LogisticsConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : StockAuditServiceImpl.java
 * @Description : Stock Audit Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 07.   KR-OHK        First creation
 * </pre>
 */
@Service("stockAuditService")
public class StockAuditServiceImpl implements StockAuditService {

	private static final Logger LOGGER = LoggerFactory.getLogger(StockAuditServiceImpl.class);

	@Resource(name = "stockAuditMapper")
	private StockAuditMapper stockAuditMapper;

    @Resource(name = "PointOfSalesMapper")
    private PointOfSalesMapper PointOfSalesMapper;

	@Resource(name = "countStockAuditMapper")
	private CountStockAuditMapper countStockAuditMapper;

	@Autowired
	private FileService fileService;

	@Autowired
    private CountStockAuditService countStockAuditService;

	@Override
	public List<EgovMap> selectLocCodeList(Map<String, Object> params) {
		return stockAuditMapper.selectLocCodeList(params);
	}

	@Override
	public int selectStockAuditListCnt(Map<String, Object> params) {
		return stockAuditMapper.selectStockAuditListCnt(params);
	}

	@Override
	public List<EgovMap> selectStockAuditList(Map<String, Object> params) {
		return stockAuditMapper.selectStockAuditList(params);
	}

	@Override
	public List<EgovMap> selectStockAuditListExcel(Map<String, Object> params) {
		return stockAuditMapper.selectStockAuditListExcel(params);
	}

	@Override
	public List<EgovMap> selectStockAuditLocDetail(Map<String, Object> params) {
		return stockAuditMapper.selectStockAuditLocDetail(params);
	}

	@Override
	public List<EgovMap> selectLocationList(Map<String, Object> params) {
		return stockAuditMapper.selectLocationList(params);
	}

	@Override
	public List<EgovMap> selectItemList(Map<String, Object> params) {
		return stockAuditMapper.selectItemList(params);
	}

	@Override
	public EgovMap selectStockAuditDocInfo(Map<String, Object> params) {
		return stockAuditMapper.selectStockAuditDocInfo(params);
	}

	@Override
	public List<EgovMap> selectStockAuditSelectedLocList(Map<String, Object> params) {
		return stockAuditMapper.selectStockAuditSelectedLocList(params);
	}

	@Override
	public List<EgovMap> selectStockAuditSelectedItemList(Map<String, Object> params) {
		return stockAuditMapper.selectStockAuditSelectedItemList(params);
	}

	@Override
	public List<EgovMap> selectLocInHisList(Map<String, Object> params) {
		return stockAuditMapper.selectLocInHisList(params);
	}

	@Override
	public List<EgovMap> selectItemInHisList(Map<String, Object> params) {
		return stockAuditMapper.selectItemInHisList(params);
	}

	@Override
	public List<EgovMap> selectOtherGIGRItemList(Map<String, Object> params) {
		return stockAuditMapper.selectOtherGIGRItemList(params);
	}

	@Override
	public EgovMap selectStockAuditDocDtTime(Map<String, Object> params) {
		return stockAuditMapper.selectStockAuditDocDtTime(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String createStockAuditDoc(Map<String, Object> params) {
		int procCnt = 0;

		Map<String, Object> locGridList = (Map<String, Object>) params.get("locGridList");
		Map<String, Object> itemGridList = (Map<String, Object>) params.get("itemGridList");
		List<Object> locGrid = (List<Object>)locGridList.get(AppConstants.AUIGRID_ALL);
		List<Object> itemGrid= (List<Object>)itemGridList.get(AppConstants.AUIGRID_ALL);

		List<Object> locType =   (List<Object>) params.get("locType");
		List<Object> locGrade =  (List<Object>) params.get("locGrade");
		List<Object> itemType =  (List<Object>) params.get("itemType");
		List<Object> catagoryType =  (List<Object>) params.get("catagoryType");

		String appvType = (String) params.get("appvType");

		if("save".equals(appvType)) {
			params.put("docStusCodeId", LogisticsConstants.DOC_SAVE); 			// Doc Status : Save
		} else if ("startAudit".equals(appvType)) {
			params.put("docStusCodeId", LogisticsConstants.DOC_START_AUDIT); // Doc Status : Start Audit
		}

		String stockAuditNo = "";
		if(CommonUtils.isEmpty(params.get("insStockAuditNo"))) {
			stockAuditNo = stockAuditMapper.getStockAuditNo();
		} else {
			stockAuditNo =  (String)params.get("insStockAuditNo");
		}
		params.put("stockAuditNo", stockAuditNo);

		if(CommonUtils.isEmpty(params.get("stockAuditNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Stock Audit No is required.");
		}
		if(CommonUtils.isEmpty(params.get("docStusCodeId"))) {
			throw new ApplicationException(AppConstants.FAIL, "Doc Status is required.");
		}
		if(CommonUtils.isEmpty(params.get("insDocStartDt"))) {
			throw new ApplicationException(AppConstants.FAIL, "Stock Audit Start Date is required.");
		}
		if(CommonUtils.isEmpty(params.get("insDocEndDt"))) {
			throw new ApplicationException(AppConstants.FAIL, "Stock Audit End Date is required.");
		}
		if(CommonUtils.isEmpty(params.get("serialChkYn"))) {
			throw new ApplicationException(AppConstants.FAIL, "Serial Check is required.");
		}
		if(locType == null || locType.size() == 0) {
			throw new ApplicationException(AppConstants.FAIL, "Location Type is required.");
		}
		if(locGrade == null || locGrade.size() == 0) {
			throw new ApplicationException(AppConstants.FAIL, "Location Grade is required.");
		}
		if(itemType == null || itemType.size() == 0) {
			throw new ApplicationException(AppConstants.FAIL, "Item Type is required.");
		}
		if(catagoryType == null || catagoryType.size() == 0) {
			throw new ApplicationException(AppConstants.FAIL, "Category Type is required.");
		}
		if(CommonUtils.isEmpty(params.get("stockAuditReason"))) {
			throw new ApplicationException(AppConstants.FAIL, "Stock Audit Reason is required.");
		}
		if(params.get("stockAuditReason").toString().getBytes().length > 2000) {
			throw new ApplicationException(AppConstants.FAIL, "Please input the Stock Audit Reason below or less than 2000 bytes.");
		}
		if(CommonUtils.isNotEmpty(params.get("rem")) && params.get("rem").toString().getBytes().length > 500) {
			throw new ApplicationException(AppConstants.FAIL, "Please input the Remark below or less than 500 bytes.");
		}
		if(locGrid == null || locGrid.size() == 0) {
			throw new ApplicationException(AppConstants.FAIL, "No Location is selected.");
		}
		if(itemGrid == null || itemGrid.size() == 0) {
			throw new ApplicationException(AppConstants.FAIL, "No item is selected");
		}
		if(CommonUtils.isEmpty(params.get("userId"))) {
			throw new ApplicationException(AppConstants.FAIL, "User Id is required.");
		}

		params.put("locStusCodeId", LogisticsConstants.LOC_UNREG); // Loc Status : Unregisterd
		params.put("locType", locType);
		params.put("locStkGrad", locGrade);
		params.put("itmType", itemType);
		params.put("ctgryType", catagoryType);

		if (locGrid.size() > 0) {
			List<Object> list = new ArrayList<Object>();
			for (int i = 0; i < locGrid.size(); i++) {
				Map<String, Object> getMap = (Map<String, Object>) locGrid.get(i);

				list.add(getMap.get("adjwhLocId"));
			}
			params.put("adjwhLocId", list);
		}

		if (itemGrid.size() > 0) {
			List<Object> list = new ArrayList<Object>();
			for (int i = 0; i < itemGrid.size(); i++) {
				Map<String, Object> getMap = (Map<String, Object>) itemGrid.get(i);

				list.add(getMap.get("adjstkId"));
			}
			params.put("adjstkId", list);
		}

		if(!CommonUtils.isEmpty(params.get("insStockAuditNo"))) { // Edit
			// Check update date&time
			EgovMap updDtMap = stockAuditMapper.selectStockAuditDocDtTime(params);
			if(!updDtMap.get("updDtTime").toString().equals(params.get("hidUpdDtTime"))) {
				throw new ApplicationException(AppConstants.FAIL, "The data you have selected is already updated.");
			}

			// Check Status
    		EgovMap docStusMap = stockAuditMapper.selectStockAuditDocStatus(params);
    		if(!LogisticsConstants.DOC_SAVE.equals(docStusMap.get("docStusCodeId").toString())) {
    			throw new ApplicationException(AppConstants.FAIL, "Please check the status.<br />[ Current Doc Status : " + docStusMap.get("docStusCodeName") +  " ]");
    		}
		} else { // New
    		// Check progress
    		if (locGrid.size() > 0) {
    			for (int i = 0; i < locGrid.size(); i++) {
    				Map<String, Object> getMap = (Map<String, Object>) locGrid.get(i);
    				params.put("whLocId", getMap.get("adjwhLocId"));

    				EgovMap procMap = stockAuditMapper.selectStockAuditProcInfo(params);
    				if(procMap != null && Integer.parseInt(String.valueOf(procMap.get("procCnt"))) > 0 ) {
    					throw new ApplicationException(AppConstants.FAIL, "There is an item in progress for Stock Audit.<br /> [ Location : "+ procMap.get("locInfo")  +  " ]");
    				}
    			}
    		}
		}

		// Stock Aduit Doc table insert
		procCnt = stockAuditMapper.insertStockAuditDoc(params);
		if(procCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Stock Audit Doc.1");
		}

		// Stock Aduit Loc table insert
		procCnt = stockAuditMapper.deleteStockAuditLoc(params);
		procCnt = stockAuditMapper.insertStockAuditLoc(params);
		/*if(procCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Stock Audit Doc.2");
		}*/

		// Stock Aduit Loc Item table insert
		procCnt = stockAuditMapper.deleteStockAuditItem(params);
		procCnt = stockAuditMapper.insertStockAuditItem(params);
		/*if(procCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Stock Audit Doc.3");
		}*/

		// LOC_TYPE, CTGRY_TYPE, ITM_TYPE, LOC_STK_GRAD update
		procCnt = stockAuditMapper.updateStockAuditDoc(params);

		// Doc Status : Start Audit
		if(LogisticsConstants.DOC_START_AUDIT.equals(params.get("docStusCodeId").toString())) {
			EgovMap movLoc = stockAuditMapper.getMovQty(params);

			//LOGGER.debug("createStockAuditDoc@@@@@@@@@@@@@ movLoc : " + movLoc.get("movLoc"));

			if(movLoc != null && !CommonUtils.isEmpty((String)movLoc.get("movLoc"))) {
				throw new ApplicationException(AppConstants.FAIL, "There is a moving inventory in the location.<br />[" + movLoc.get("movLoc")+"]");
			}

			// doc status update
    		procCnt = stockAuditMapper.updateDocStusCode(params);
    		if(procCnt == 0) {
    			throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Stock Audit Doc.4");
    		}

    		// System Qty update
    		procCnt = stockAuditMapper.updateSysQty(params);
    		if(procCnt == 0) {
    			throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Stock Audit Doc.5");
    		}
		}

		return stockAuditNo;
	}

	@Override
	public EgovMap startStockAudit(Map<String, Object> params) {
		int procCnt = 0;

		if(CommonUtils.isEmpty(params.get("insStockAuditNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Stock Audit No is required.");
		}
		if(CommonUtils.isEmpty(params.get("userId"))) {
			throw new ApplicationException(AppConstants.FAIL, "User Id is required.");
		}

		params.put("stockAuditNo", params.get("insStockAuditNo"));
		params.put("docStusCodeId", LogisticsConstants.DOC_START_AUDIT); // Doc Status : Start Audit

		// Check update date&time
		EgovMap updDtMap = stockAuditMapper.selectStockAuditDocDtTime(params);
		if(!updDtMap.get("updDtTime").toString().equals(params.get("hidUpdDtTime"))) {
			throw new ApplicationException(AppConstants.FAIL, "The data you have selected is already updated.");
		}

		// Check Status
		EgovMap docStusMap = stockAuditMapper.selectStockAuditDocStatus(params);
		if(!LogisticsConstants.DOC_SAVE.equals(docStusMap.get("docStusCodeId").toString())) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the status.<br />[ Current Doc Status : " + docStusMap.get("docStusCodeName") +  " ]");
		}

		// Mov Qty Check
		EgovMap movLoc = stockAuditMapper.getMovQty(params);
		//LOGGER.debug("createStockAuditDoc@@@@@@@@@@@@@ movLoc : " + movLoc.get("movLoc"));

		if(movLoc != null && !CommonUtils.isEmpty((String)movLoc.get("movLoc"))) {
			throw new ApplicationException(AppConstants.FAIL, "There is a moving inventory in the location.<br />[ " + movLoc.get("movLoc")+" ]");
		}

		// doc status update
    	procCnt = stockAuditMapper.updateDocStusCode(params);
    	if(procCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "ERROR :Start Stock Audit.1");
		}

    	// System Qty update
    	procCnt = stockAuditMapper.updateSysQty(params);
    	if(procCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "ERROR :Start Stock Audit.2");
		}

		return movLoc;
	}

	@Override
	public void saveDocAppvInfo(Map<String, Object> params) {
		int procCnt = 0;

		String appvType =  (String)params.get("appvType");

		if(CommonUtils.isEmpty(params.get("stockAuditNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Stock Audit No is required.");
		}
		if(CommonUtils.isEmpty(params.get("userId"))) {
			throw new ApplicationException(AppConstants.FAIL, "User Id is required.");
		}

		// 3차 승인요청인 경우 모든 로케이션 2차 승인이 완료된 상태인지 체크 / appv3ReqstOpinion 길이 체크 500
		if("3ReqAprv".equals(appvType)) {

			// Check Status
			EgovMap docStusMap = stockAuditMapper.selectStockAuditDocStatus(params);
			if(!LogisticsConstants.DOC_START_AUDIT.equals(docStusMap.get("docStusCodeId").toString())) {
    			throw new ApplicationException(AppConstants.FAIL, "Please check the status.<br />[ Current Doc Status : " + docStusMap.get("docStusCodeName") +  " ]");
    		}

			// Compapre 2nd approval count
			EgovMap apvrMap = stockAuditMapper.selectStockAuditAprvCnt(params);
			if (!apvrMap.get("allCnt").equals(apvrMap.get("aprv2Cnt"))) {
				throw new ApplicationException(AppConstants.FAIL, "You can request for 3rd approval only if all of the 2nd approval is completed.");
			}

			if(CommonUtils.isEmpty(params.get("appv3ReqstOpinion"))) {
    			throw new ApplicationException(AppConstants.FAIL, "3rd Request approval Opinion is required.");
    		}
    		if(params.get("appv3ReqstOpinion").toString().getBytes().length > 500) {
    			throw new ApplicationException(AppConstants.FAIL, "Please input the 3rd Request approval Opinion below or less than 500 bytes.");
    		}
		}

		if("aprv3".equals(appvType) || "rejt3".equals(appvType) || "comp".equals(appvType)) {
    		// Check Status
    		EgovMap docStusMap = stockAuditMapper.selectStockAuditDocStatus(params);

    		if("aprv3".equals(appvType) || "rejt3".equals(appvType)) {
        		if(!LogisticsConstants.DOC_3REQ_APRV.equals(docStusMap.get("docStusCodeId").toString())) {
        			throw new ApplicationException(AppConstants.FAIL, "Please check the status.<br />[ Current Doc Status : " + docStusMap.get("docStusCodeName") +  " ]");
        		}
        		if(CommonUtils.isEmpty(params.get("appv3Opinion"))) {
        			throw new ApplicationException(AppConstants.FAIL, "3rd Opinion is required.");
        		}
        		if(params.get("appv3Opinion").toString().getBytes().length > 500) {
        			throw new ApplicationException(AppConstants.FAIL, "Please input the 3rd Opinion below or less than 500 bytes.");
        		}
    		} else {
    			if(!LogisticsConstants.DOC_OTHER.equals(docStusMap.get("docStusCodeId").toString())) {
        			throw new ApplicationException(AppConstants.FAIL, "Please check the status.<br />[ Current Doc Status : " + docStusMap.get("docStusCodeName") +  " ]");
        		}
    		}
    	}

		if("3ReqAprv".equals(appvType)) {
			params.put("docStusCodeId", LogisticsConstants.DOC_3REQ_APRV);	// Doc Status : 3rd Request approval
		} else if("aprv3".equals(appvType)) {
			params.put("docStusCodeId", LogisticsConstants.DOC_3APRV);			// Doc Status : 3st Approve
			params.put("locStusCodeId", LogisticsConstants.LOC_APRV3);			// Loc Status : 3st Approve
		} else if("rejt3".equals(appvType)) {
			params.put("docStusCodeId", LogisticsConstants.DOC_3REJT);			// Doc Status : 3st Reject
			params.put("locStusCodeId", LogisticsConstants.LOC_REJT3);				// Loc Status : 3st Reject
		} else if("comp".equals(appvType)) {
			params.put("docStusCodeId", LogisticsConstants.DOC_COMP);			// Doc Status : Complete
			params.put("locStusCodeId", LogisticsConstants.LOC_COMP);				// Loc Status : Complete
		}

		procCnt = stockAuditMapper.saveDocAppvInfo(params);
		if(procCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "ERROR :Approve Stock Audit Doc.1");
		}

		if("aprv3".equals(appvType) || "rejt3".equals(appvType) || "comp".equals(appvType)) {
			procCnt = stockAuditMapper.updateLocStusCode(params);
			if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Approve Stock Audit Doc.2");
			}
		}

		if("aprv3".equals(appvType)) { // transaction type update
			procCnt = stockAuditMapper.updateOtherTrnscType(params);
			if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Approve Stock Audit Doc.3");
			}

		}

		// Send SMS
		if("rejt3".equals(params.get("appvType"))) {
			params.put("smsMessage", "3rd Approval is rejected. Please register Count-StockAudit.");
			countStockAuditService.stockAuditSendSms(params);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveAppv2Info(Map<String, Object> params) {
		int procCnt = 0;
		String appvType = (String)params.get("appvType");

		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		if(CommonUtils.isEmpty(params.get("stockAuditNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Stock Audit No is required.");
		}
		if(CommonUtils.isEmpty(params.get("userId"))) {
			throw new ApplicationException(AppConstants.FAIL, "User Id is required.");
		}

		if("aprv2".equals(appvType)) {
			params.put("locStusCodeId", LogisticsConstants.LOC_APRV2);	// Loc Status : 2st Approve
		} else if("rejt2".equals(appvType)) {
			params.put("locStusCodeId", LogisticsConstants.LOC_REJT2);		// Loc Status : 2st Reject
		}

		params.put("reuploadYn", formMap.get("reuploadYn"));
		params.put("atchFileGrpId", formMap.get("atchFileGrpId"));

		procCnt = stockAuditMapper.saveDocAppvInfo(params);
		if(procCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "ERROR :Approve Stock Audit Loc.1");
		}

		for (Object obj : checkList)
		{
			// Check status
			params.put("whLocId", ((Map<String, Object>) obj).get("whLocId"));
			params.put("appv2Opinion", ((Map<String, Object>) obj).get("appv2Opinion"));
			EgovMap locStusMap = countStockAuditMapper.selectStockAuditLocStatus(params);
			String locStusCodeId = locStusMap.get("locStusCodeId").toString();

			if( ("aprv2".equals(appvType) && !LogisticsConstants.LOC_APRV1.equals(locStusCodeId)) ||
			    ("rejt2".equals(appvType) && !LogisticsConstants.LOC_APRV1.equals(locStusCodeId)) ) {
				throw new ApplicationException(AppConstants.FAIL, "Please check the status.<br />[ Current Doc Status : " + locStusMap.get("locStusCodeName") +  " ]");
			}

			if("rejt2".equals(appvType)) {
				if(CommonUtils.isEmpty(params.get("appv2Opinion"))) {
					throw new ApplicationException(AppConstants.FAIL, "2nd Opinion is required.");
				}
				if(params.get("appv2Opinion").toString().getBytes().length > 500) {
					throw new ApplicationException(AppConstants.FAIL, "Please input the 2nd Opinion below or less than 500 bytes.");
				}
			} else {
				if(CommonUtils.isNotEmpty(params.get("appv2Opinion")) && params.get("appv2Opinion").toString().getBytes().length > 500) {
					throw new ApplicationException(AppConstants.FAIL, "Please input the 2nd Opinion below or less than 500 bytes.");
				}
			}

			((Map<String, Object>) obj).put("locStusCodeId", params.get("locStusCodeId"));
			((Map<String, Object>) obj).put("appvType", appvType);
			((Map<String, Object>) obj).put("userId", params.get("userId"));

			procCnt = countStockAuditMapper.saveAppvInfo((Map<String, Object>) obj);
			if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Approve Stock Audit Loc.2");
			}
		}

		// Send SMS
		if("rejt2".equals(appvType)) {
			params.put("smsMessage", "2nd Approval is rejected. Please register Count-StockAudit.");
			countStockAuditService.stockAuditSendSms(params);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveOtherGiGr(Map<String, Object> params) {
		int procCnt = 0;
		String returnValue[] = null;
		String reVal = "";
		String reuploadYn = (String)params.get("reuploadYn");

		if(CommonUtils.isEmpty(params.get("stockAuditNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Stock Audit No is required.");
		}
		if(CommonUtils.isEmpty(params.get("reqstDt"))) {
			throw new ApplicationException(AppConstants.FAIL, "Request Date is required.");
		}
		if(CommonUtils.isNotEmpty(params.get("otherRem")) && params.get("otherRem").toString().getBytes().length > 4000) {
			throw new ApplicationException(AppConstants.FAIL, "Please input the Remark below or less than 4000 bytes.");
		}
		if(CommonUtils.isEmpty(params.get("userId"))) {
			throw new ApplicationException(AppConstants.FAIL, "User Id is required.");
		}

		// Check Status
		EgovMap docStusMap = stockAuditMapper.selectStockAuditDocStatus(params);
		if(!LogisticsConstants.DOC_3APRV.equals(docStusMap.get("docStusCodeId").toString())) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the status.<br />[ Current Doc Status : " + docStusMap.get("docStusCodeName") +  " ]");
		}

		if("N".equals(reuploadYn)) {
			params.put("docStusCodeId", LogisticsConstants.DOC_COMP);			// Doc Status : Complete
			params.put("locStusCodeId", LogisticsConstants.LOC_COMP);				// Loc Status : Complete
		} else if("Y".equals(reuploadYn)) {
			params.put("docStusCodeId", LogisticsConstants.DOC_OTHER);			// Doc Status : Other GI / GR
			params.put("locStusCodeId", LogisticsConstants.LOC_OTHER);			// Loc Status : Other GI / GR
		}

		List<EgovMap> reqstNoList = stockAuditMapper.getOtherGiGrReqstNo(params);

		if(reqstNoList.size() > 0 ) {

    		for (int i = 0 ; i < reqstNoList.size() ; i++) {

    			Map<String, Object> getMap = (Map<String, Object>)reqstNoList.get(i);

    			if(CommonUtils.isEmpty(getMap.get("stockAuditNo"))) {
    				throw new ApplicationException(AppConstants.FAIL, "Location Id is required.");
    			}
    			if(CommonUtils.isEmpty(getMap.get("whLocId"))) {
    				throw new ApplicationException(AppConstants.FAIL, "Location Id is required.");
    			}
    			if(CommonUtils.isEmpty(getMap.get("otherReqstNo"))) {
    				throw new ApplicationException(AppConstants.FAIL, "Other Request No is required.");
    			}
    			if(CommonUtils.isEmpty(getMap.get("otherTrnscType"))) {
    				throw new ApplicationException(AppConstants.FAIL, "Other GI / GR Transaction Type is required.");
    			}
    			if(CommonUtils.isEmpty(getMap.get("whLocStkGrad"))) {
    				throw new ApplicationException(AppConstants.FAIL, "Location Stock Grade is required.");
    			}

    			params.put("otherReqstNo", getMap.get("otherReqstNo"));
    			params.put("stockAuditNo", getMap.get("stockAuditNo"));
    			params.put("whLocId", getMap.get("whLocId"));
    			params.put("otherTrnscType", getMap.get("otherTrnscType"));
    			params.put("whLocStkGrad", getMap.get("whLocStkGrad"));
    			params.put("otherReason", getMap.get("otherReason"));

    			procCnt = stockAuditMapper.updateOtherGiGrReqstInfo(params);
    			if(procCnt == 0) {
    				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Stock Audit Other GI/GR.1");
    			}
    		}

    		// Status update
    		procCnt = stockAuditMapper.saveDocAppvInfo(params);
    		if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Stock Audit Other GI/GR.2");
			}

    		procCnt = stockAuditMapper.updateLocStusCode(params);
    		if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Stock Audit Other GI/GR.3");
			}

    		procCnt = stockAuditMapper.insertLOG0047M(params);
    		if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Stock Audit Other GI/GR.4");
			}

    		procCnt = stockAuditMapper.insertLOG0048D(params);
    		if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Stock Audit Other GI/GR.5");
			}

    		EgovMap reqstMap = stockAuditMapper.getOtherTargetReqstNo(params);
    		String otherReqstNo = (String)reqstMap.get("otherReqstNo");
    		String otherTrnscType = (String)reqstMap.get("otherTrnscType");

    		LOGGER.debug("$$$$$$$$$$$$$$$saveOtherGiGr reqstMap:::::::::::::::::[" + reqstMap+ "]");
    		LOGGER.debug("$$$$$$$$$$$$$$$saveOtherGiGr otherReqstNo:::::::::::::::::[" + otherReqstNo+ "]");
    		LOGGER.debug("$$$$$$$$$$$$$$$saveOtherGiGr otherTrnscType:::::::::::::::::[" + otherTrnscType+ "]");

    		//재고 이동 프로시저
    		Map<String, Object> GiMap = new HashMap<String, Object>();

    		String[] delvcd = otherReqstNo.split("∈");
    	    GiMap.put("parray", delvcd);
    	    GiMap.put("gtype", otherTrnscType);
    	    GiMap.put("doctext", params.get("otherRem"));
    	    GiMap.put("gipfdate", params.get("reqstDt"));
    	    GiMap.put("giptdate", params.get("reqstDt"));
    	    GiMap.put("prgnm", "AD Other GI/GR");
    	    GiMap.put("refdocno", "");
    	    GiMap.put("salesorder", "");
    	    GiMap.put("userId", params.get("userId"));

    		stockAuditMapper.SP_LOGISTIC_DELIVERY_SERIAL(GiMap);

    		reVal = (String) GiMap.get("rdata");

            returnValue = reVal.split("∈");
            LOGGER.debug("$$$$$$$$$$$$$$$GIRequestIssue [" + returnValue[0]+ "]");
            LOGGER.debug("$$$$$$$$$$$$$$$GIRequestIssue [" + returnValue[1]+ "]");

    	    if(!"000".equals(returnValue[0])) {
    		    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + returnValue[0]+ ":" + returnValue[1]);
    	    }

    	    // Barcode Save Start
    	    Map<String, Object> adMap = new HashMap<String, Object>();

    	    adMap.put("delvryGrDt", params.get("reqstDt"));
    	    adMap.put("reqstNo", params.get("stockAuditNo"));
    	    adMap.put("trnscType", "AD");
    	    adMap.put("ioType", "O");
    	    adMap.put("userId", params.get("userId"));

    	    stockAuditMapper.SP_LOGISTIC_BARCODE_SAVE_AD(adMap);

    	    String errCode = (String)adMap.get("pErrcode");
      	    String errMsg = (String)adMap.get("pErrmsg");

      	    LOGGER.debug(">>>>>>>>>>>SP_LOGISTIC_BARCODE_SAVE_AD ERROR CODE : " + errCode);
      	    LOGGER.debug(">>>>>>>>>>>SP_LOGISTIC_BARCODE_SAVE_AD ERROR MSG: " + errMsg);

      	    // pErrcode : 000  = Success, others = Fail
      	    if(!"000".equals(errCode)){
      		    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
      	    }
      	    // Barcode Save End
		} else {
			throw new ApplicationException(AppConstants.FAIL, "There is no Other GI/GR Data.");
		}

  	    return returnValue[1];
	}

	@Override
	public void updateStockAuditAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		String updateFileIds = (String) params.get("updateFileIds");
		String deleteFileIds = (String) params.get("deleteFileIds");
		String fileGroupId = (String) params.get("fileGroupKey");
		int userId = (int) params.get("userId");
		String[] updateFileId = null;
		String[] deleteFileId = null;

		if (StringUtils.isNotEmpty(updateFileIds)) {
			updateFileId = CommonUtils.getDelimiterValues(updateFileIds);
		}

		if (StringUtils.isNotEmpty(deleteFileIds)) {
			deleteFileId = CommonUtils.getDelimiterValues(deleteFileIds);
		}

		int fileCnt = 0;

		if (deleteFileId != null) {
			for (String fileId : deleteFileId) {
				if (StringUtils.isNotEmpty(fileId)) {
					fileService.removeFileByFileId(type, Integer.parseInt(fileId));
				}
			}
		}

		if (StringUtils.isNotEmpty(fileGroupId)) {
			for (FileVO fileVO : list) {
				if (updateFileId != null && fileCnt <= updateFileId.length - 1) {
					if (StringUtils.isNotEmpty(updateFileId[fileCnt])) {
						fileService.changeFile(Integer.parseInt(fileGroupId), Integer.parseInt(updateFileId[fileCnt]),
								fileVO, type, userId);
					}
				} else {
					fileService.insertFile(Integer.parseInt(fileGroupId), fileVO, type, userId);
				}

				fileCnt++;
			}
		} else {
			if (list.size() > 0) {
				fileService.insertFiles(list, type, userId);
			}
		}
	}
}
