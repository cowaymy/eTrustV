package com.coway.trust.biz.eAccounting.ctDutyAllowance.impl;

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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.ctDutyAllowance.CtDutyAllowanceApplication;
import com.coway.trust.biz.eAccounting.ctDutyAllowance.CtDutyAllowanceService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ctDutyAllowanceService")
public class CtDutyAllowanceServiceImpl implements CtDutyAllowanceService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "ctDutyAllowanceMapper")
	private CtDutyAllowanceMapper ctDutyAllowanceMapper;

	@Resource(name = "ctDutyAllowanceApplication")
	private CtDutyAllowanceApplication ctDutyAllowanceApplication;

	@Autowired
	private WebInvoiceMapper webInvoiceMapper;

	@Override
	public List<EgovMap> selectCtDutyAllowanceList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.selectCtDutyAllowanceList(params);
	}

	@Override
	public List<EgovMap> selectTaxCodeCtDutyAllowanceFlag() {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.selectTaxCodeCtDutyAllowanceFlag();
	}

	@Override
	public List<EgovMap> selectSearchInsOrderNo(Map<String, Object> params) throws Exception {

		return ctDutyAllowanceMapper.selectSearchInsOrderNo(params);
	}

	@Override
	public List<EgovMap> selectSearchAsOrderNo(Map<String, Object> params) throws Exception {

		return ctDutyAllowanceMapper.selectSearchAsOrderNo(params);
	}

	@Override
	public List<EgovMap> selectSearchPrOrderNo(Map<String, Object> params) throws Exception {

		return ctDutyAllowanceMapper.selectSearchPrOrderNo(params);
	}

	@Override
	public List<EgovMap> selectSupplier(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.selectSupplier(params);
	}

	@Override
	public String selectCtDutyAllowanceMainSeq(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.selectNextClmNo(params);
	}

	@Override
	public String selectCtDutyAllowanceSubSeq(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.selectNextSubClmNo(params);
	}

	@Override
	public void updateCtDutyAllowanceMainSeq(Map<String, Object> params) {
		// TODO Auto-generated method stub
		ctDutyAllowanceMapper.updateClmNo(params);
	}

	@Override
	public void insertCtDutyAllowanceExp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		List<Object> gridDataList = (List<Object>) params.get("gridDataList");

		Map<String, Object> masterData = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		String clmNo = ctDutyAllowanceMapper.selectNextClmNo(params);
		params.put("clmNo", clmNo);

		ctDutyAllowanceMapper.updateClmNo(params);

		masterData.put("clmNo", clmNo);
		masterData.put("userId", params.get("userId"));
		masterData.put("userName", params.get("userName"));
		masterData.put("appvPrcssNo", "");
		masterData.put("totAmt", params.get("totAmt"));

		LOGGER.debug("masterData =====================================>>  " + masterData);
		ctDutyAllowanceMapper.insertCtDutyAllowanceExp(masterData);

		for(int i = 0; i < gridDataList.size(); i++) {
			Map<String, Object> item = (Map<String, Object>) gridDataList.get(i);
			int clmSeq = ctDutyAllowanceMapper.selectNextClmSeq(clmNo);
			item.put("clmNo", clmNo);
			item.put("clmSeq", clmSeq);
			item.put("userId", params.get("userId"));
			item.put("userName", params.get("userName"));
			LOGGER.debug("insertSmGmClaimExpItem =====================================>>  " + item);
			ctDutyAllowanceMapper.insertCtDutyAllowanceExpItem(item);
			// Expense Type Name == Car Mileage Expense
	        //$("#expTypeName").val() == "Car Mileage Expense"
	        // WebInvoice Test는 Test
			LOGGER.debug("expGrp =====================================>>  " + item.get("expGrp"));
			/*if("1".equals(item.get("expGrp"))) {
				LOGGER.debug("insertSmGmClaimExpMileage =====================================>>  " + item);
				ctDutyAllowanceMapper.insertCtDutyAllowanceExpMileage(item);
			}*/
		}
	}

	@Override
	public List<EgovMap> selectCtDutyAllowanceItems(String clmNo) {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.selectCtDutyAllowanceItems(clmNo);
	}

	@Override
	public void updateCtDutyAllowanceExp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		ctDutyAllowanceMapper.updateCtDutyAllowanceMain(params);

		// TODO editGridDataList GET
		List<Object> addList = (List<Object>) params.get("add"); // 추가 리스트 얻기
		List<Object> updateList = (List<Object>) params.get("update"); // 수정 리스트 얻기
		List<Object> removeList = (List<Object>) params.get("remove"); // 수정 리스트 얻기

		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("allTotAmt", params.get("allTotAmt"));
				int clmSeq = ctDutyAllowanceMapper.selectNextClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertStaffClaimExpItem =====================================>>  " + hm);
				ctDutyAllowanceMapper.insertCtDutyAllowanceExpItem(hm);
				ctDutyAllowanceMapper.updateCtDutyAllowanceExpTotAmt(hm);
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
			ctDutyAllowanceMapper.updateCtDutyAllowanceExp(hm);
			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("updateStaffClaimExpItem =====================================>>  " + hm);
				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
				ctDutyAllowanceMapper.updateCtDutyAllowanceExpItem(hm);
			}
		}

		if (removeList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : removeList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("allTotAmt", params.get("allTotAmt"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("removeStaffClaimExpItem =====================================>>  " + hm);
				ctDutyAllowanceMapper.deleteCtDutyAllowanceExpItem(hm);
				ctDutyAllowanceMapper.updateCtDutyAllowanceExpTotAmt(hm);
			}
		}

		LOGGER.info("추가 : {}", addList.toString());
		LOGGER.info("수정 : {}", updateList.toString());
		LOGGER.info("수정 : {}", removeList.toString());
	}

	@Override
	public int checkOnceAMonth(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.checkOnceAMonth(params);
	}

	/*


	@Override
	public EgovMap selectCtDutyAllowanceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.selectCtDutyAllowanceInfo(params);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.selectAttachList(atchFileGrpId);
	}


*/
	@Override
	public void deleteCtDutyAllowanceExpItem(Map<String, Object> params) {
		// TODO Auto-generated method stub
		ctDutyAllowanceMapper.deleteCtDutyAllowanceExpItem(params);
	}

	@Override
	public void updateCtDutyAllowanceExpTotAmt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		ctDutyAllowanceMapper.updateCtDutyAllowanceExpTotAmt(params);
	}

	@Override
	public List<EgovMap> selectCtDutyAllowanceItemGrp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.selectCtDutyAllowanceItemGrp(params);
	}

	@Override
	public void deleteCtDutyAllowanceItem(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		if(params.get("atchFileGrpId") != null && params.get("atchFileGrpId") != ""){
			ctDutyAllowanceApplication.deleteCtDutyAllowanceAttachBiz(FileType.WEB_DIRECT_RESOURCE, params);
		}

		if(CommonUtils.isEmpty(params.get("clmNo"))) {
			// Not Temp. Save
			// 저장된 파일만 삭제
			deleteCtDutyAllowanceExpItem(params);
		} else {
			// Temp. Save
			// 저장된 파일 삭제 및 테이블 데이터 삭제
			deleteCtDutyAllowanceExpItem(params);
			updateCtDutyAllowanceExpTotAmt(params);
		}
	}

	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		//List<Object> newGridList = (List<Object>) params.get("newGridList");

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
				ctDutyAllowanceMapper.insertApproveLineDetail(hm);
			}
		}

		/*if (newGridList.size() > 0) {
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
				ctDutyAllowanceMapper.insertApproveItems(hm);
			}
		}*/

		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		ctDutyAllowanceMapper.updateAppvPrcssNo(params);
	}

	@Override
	public List<EgovMap> selectMemberViewByMemCode(Map<String, Object> params){

		return ctDutyAllowanceMapper.selectMemberViewByMemCode(params);
	}

	@Override
	public List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return ctDutyAllowanceMapper.selectAppvInfoAndItems(params);
	}

	@Override
	public List<EgovMap> getBch(Map<String, Object> params) {
		return ctDutyAllowanceMapper.getBch(params);
	}

	@Override
	public void updateApprovalInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		List<Object> invoAppvGridList = (List<Object>) params.get("invoAppvGridList");
		for (int i = 0; i < invoAppvGridList.size(); i++) {
			Map<String, Object> invoAppvInfo = (Map<String, Object>) invoAppvGridList.get(i);
			String appvPrcssNo = (String) invoAppvInfo.get("appvPrcssNo");
			int appvLineSeq = (int) invoAppvInfo.get("appvLineSeq");
			int appvLineCnt = webInvoiceMapper.selectAppvLineCnt(appvPrcssNo);
			int appvLinePrcssCnt = webInvoiceMapper.selectAppvLinePrcssCnt(appvPrcssNo);
			invoAppvInfo.put("appvLinePrcssCnt", appvLinePrcssCnt + 1);
			invoAppvInfo.put("appvPrcssStus", "P");
			invoAppvInfo.put("appvStus", "A");
			invoAppvInfo.put("userId", params.get("userId"));
			LOGGER.debug("now invoAppvInfo =====================================>>  " + invoAppvInfo);
			webInvoiceMapper.updateAppvInfo(invoAppvInfo);
			webInvoiceMapper.updateAppvLine(invoAppvInfo);
			// TODO 다음 승인자 R처리
			if(appvLineCnt > appvLineSeq) {
				invoAppvInfo.put("appvStus", "R");
				invoAppvInfo.put("appvLineSeq", appvLineSeq + 1);
				LOGGER.debug("next invoAppvInfo =====================================>>  " + invoAppvInfo);
				webInvoiceMapper.updateAppvLine(invoAppvInfo);

				Map ntf = new HashMap<String, Object>();
	            ntf.put("clmNo", invoAppvInfo.get("clmNo"));

				/*EgovMap ntfDtls = (EgovMap) webInvoiceMapper.getClmDesc(invoAppvInfo);
				ntf.put("codeName", ntfDtls.get("codeDesc"));

				ntfDtls = (EgovMap) webInvoiceMapper.getNtfUser(invoAppvInfo);
				ntf.put("reqstUserId", ntfDtls.get("userName"));
				ntf.put("code", invoAppvInfo.get("clmNo").toString().substring(0, 2));
				ntf.put("appvStus", "R");
	            ntf.put("rejctResn", "Pending Approval.");

	            LOGGER.debug("ntf =====================================>>  " + ntf);*/

	            //webInvoiceMapper.insertNotification(ntf);
			}
			if(appvLineCnt == appvLinePrcssCnt + 1) {
				LOGGER.debug("last invoAppvInfo =====================================>>  " + invoAppvInfo);
				// 마지막 승인인 경우 재업데이트
				webInvoiceMapper.updateLastAppvLine(invoAppvInfo);
			}
		}
	}

	@Override
	public void updateRejectionInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		List<Object> invoAppvGridList = (List<Object>) params.get("invoAppvGridList");
		String rejctResn = (String) params.get("rejctResn");
		for (int i = 0; i < invoAppvGridList.size(); i++) {
			Map<String, Object> invoAppvInfo = (Map<String, Object>) invoAppvGridList.get(i);
			String appvPrcssNo = (String) invoAppvInfo.get("appvPrcssNo");
			String vendorClmNo = (String) invoAppvInfo.get("clmNo");
			int appvLineCnt = webInvoiceMapper.selectAppvLineCnt(appvPrcssNo);
			int appvLinePrcssCnt = webInvoiceMapper.selectAppvLinePrcssCnt(appvPrcssNo);
			invoAppvInfo.put("appvLinePrcssCnt", appvLinePrcssCnt + 1);
			invoAppvInfo.put("appvPrcssStus", "J");
			invoAppvInfo.put("appvStus", "J");
			invoAppvInfo.put("rejctResn", rejctResn);
			invoAppvInfo.put("userId", params.get("userId"));
			invoAppvInfo.put("userId", params.get("userId"));

			/*LOGGER.debug("vendorClmNo =====================================>>  " + vendorClmNo);
			if(vendorClmNo.substring(0, 2).equals("V1"))
			{
				EgovMap ntfDtls = (EgovMap) webInvoiceMapper.getClmDesc(invoAppvInfo);
				String code = vendorClmNo.substring(0, 2);
				invoAppvInfo.put("code", code);
				invoAppvInfo.put("codeName", ntfDtls.get("codeDesc"));
			}*/
			LOGGER.debug("rejection invoAppvInfo =====================================>>  " + invoAppvInfo);
			webInvoiceMapper.updateAppvInfo(invoAppvInfo);
			webInvoiceMapper.updateAppvLine(invoAppvInfo);
			//webInvoiceMapper.insertNotification(invoAppvInfo);
		}
	}

}
