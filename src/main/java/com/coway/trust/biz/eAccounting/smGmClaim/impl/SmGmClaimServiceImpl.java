package com.coway.trust.biz.eAccounting.smGmClaim.impl;

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

import com.coway.trust.biz.eAccounting.smGmClaim.SmGmClaimService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.web.eAccounting.csv.SmGmEntitlementVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("smGmClaimService")
public class SmGmClaimServiceImpl implements SmGmClaimService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "smGmClaimMapper")
	private SmGmClaimMapper smGmClaimMapper;

	@Autowired
	private WebInvoiceMapper webInvoiceMapper;

	@Override
	public List<EgovMap> selectSmGmClaimList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectSmGmClaimList(params);
	}

	@Override
	public String selectNextSubClmNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectNextSubClmNo();
	}

	@Override
	public List<EgovMap> selectTaxCodeSmGmClaimFlag() {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectTaxCodeSmGmClaimFlag();
	}

	@Override
	public void insertSmGmClaimExp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		List<Object> gridDataList = (List<Object>) params.get("gridDataList");

		Map<String, Object> masterData = (Map<String, Object>) gridDataList.get(0);

		String clmNo = smGmClaimMapper.selectNextClmNo();
		params.put("clmNo", clmNo);

		masterData.put("clmNo", clmNo);
		masterData.put("allTotAmt", params.get("allTotAmt"));
		masterData.put("userId", params.get("userId"));
		masterData.put("userName", params.get("userName"));

		LOGGER.debug("masterData =====================================>>  " + masterData);
		smGmClaimMapper.insertSmGmClaimExp(masterData);

		for(int i = 0; i < gridDataList.size(); i++) {
			Map<String, Object> item = (Map<String, Object>) gridDataList.get(i);
			int clmSeq = smGmClaimMapper.selectNextClmSeq(clmNo);
			item.put("clmNo", clmNo);
			item.put("clmSeq", clmSeq);
			item.put("userId", params.get("userId"));
			item.put("userName", params.get("userName"));
			LOGGER.debug("insertSmGmClaimExpItem =====================================>>  " + item);
			smGmClaimMapper.insertSmGmClaimExpItem(item);
			// Expense Type Name == Car Mileage Expense
	        //$("#expTypeName").val() == "Car Mileage Expense"
	        // WebInvoice Test는 Test
			/*LOGGER.debug("expGrp =====================================>>  " + item.get("expGrp"));
			if("1".equals(item.get("expGrp"))) {
				LOGGER.debug("insertSmGmClaimExpMileage =====================================>>  " + item);
				smGmClaimMapper.insertSmGmClaimExpMileage(item);
			}*/
		}
	}

	@Override
	public List<EgovMap> selectSmGmClaimItems(String clmNo) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectSmGmClaimItems(clmNo);
	}

	@Override
	public EgovMap selectSmGmClaimInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectSmGmClaimInfo(params);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectAttachList(atchFileGrpId);
	}

	@Override
	public void updateSmGmClaimExpMain(Map<String, Object> params) {
		smGmClaimMapper.updateSmGmClaimExp(params);
	}

	@Override
	public void updateSmGmClaimExp(Map<String, Object> params) {
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
				int clmSeq = smGmClaimMapper.selectNextClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertStaffClaimExpItem =====================================>>  " + hm);
				smGmClaimMapper.insertSmGmClaimExpItem(hm);
				// Expense Type Name == Car Mileage Expense
		        //$("#expTypeName").val() == "Car Mileage Expense"
		        // WebInvoice Test는 Test
				LOGGER.debug("expGrp =====================================>>  " + hm.get("expGrp"));
				if("1".equals(hm.get("expGrp"))) {
					LOGGER.debug("insertStaffClaimExpMileage =====================================>>  " + hm);
					smGmClaimMapper.insertSmGmClaimExpMileage(hm);
				}
				smGmClaimMapper.updateSmGmClaimExpTotAmt(hm);
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
			smGmClaimMapper.updateSmGmClaimExp(hm);
			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("updateStaffClaimExpItem =====================================>>  " + hm);
				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
				smGmClaimMapper.updateSmGmClaimExpItem(hm);
				// Expense Type Name == Car Mileage Expense
		        //$("#expTypeName").val() == "Car Mileage Expense"
		        // WebInvoice Test는 Test
				LOGGER.debug("expGrp =====================================>>  " + hm.get("expGrp"));
				if("1".equals(hm.get("expGrp"))) {
					LOGGER.debug("updateStaffClaimExpMileage =====================================>>  " + hm);
					smGmClaimMapper.updateSmGmClaimExpMileage(hm);
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
				smGmClaimMapper.insertApproveItems(hm);
			}
		}

		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		smGmClaimMapper.updateAppvPrcssNo(params);
	}

	@Override
	public void deleteSmGmClaimExpItem(Map<String, Object> params) {
		// TODO Auto-generated method stub
		smGmClaimMapper.deleteSmGmClaimExpItem(params);
	}

	@Override
	public void deleteSmGmClaimExpMileage(Map<String, Object> params) {
		// TODO Auto-generated method stub
		smGmClaimMapper.deleteSmGmClaimExpMileage(params);
	}

	@Override
	public void updateSmGmClaimExpTotAmt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		smGmClaimMapper.updateSmGmClaimExpTotAmt(params);
	}

	@Override
	public List<EgovMap> selectSmGmClaimItemGrp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectSmGmClaimItemGrp(params);
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

	@Override
	public String selectEntId(Map<String, Object> params) {
		return smGmClaimMapper.selectEntId(params);
	}

	@Override
	public Map<String, Object> insertEntitlementDetail(Map<String, Object> params) {

		Map<String, Object> result = new HashMap<String, Object>();

		List<SmGmEntitlementVO> vos = (List<SmGmEntitlementVO>) params.get("excelFile");

		//insert history
		Map<String, Object> paramVerify = new HashMap<String, Object>();
		String month = vos.get(0).getMonth().toString();

//		if(adjYearMonth.length() == 6){
//      	  if(!adjYearMonth.startsWith("0") && adjYearMonth.contains("/")){
//      		 adjYearMonth = "0" + adjYearMonth.substring(0,1) + "/" + adjYearMonth.substring(2);
//      	  }else{
//      		  adjYearMonth = adjYearMonth.substring(0,2) + "/" + adjYearMonth.substring(2);
//      	  }
//
//        }else if(adjYearMonth.length() == 5){
//      	  adjYearMonth = "0" + adjYearMonth.substring(0,1) + "/" + adjYearMonth.substring(1);
//        }

		if(month.length() == 5){
			month = "0" + month;
		}

		paramVerify.put("month",month);

		int cnt = smGmClaimMapper.checkIsExist(paramVerify);
		if(cnt > 0){
			smGmClaimMapper.insertEntitlementHistory(paramVerify);
			smGmClaimMapper.deleteEntitlementDetail(paramVerify);
		}

		//insert main
		String entId = smGmClaimMapper.selectEntId(params);
		result.put("entId", entId);
		for (SmGmEntitlementVO vo : vos) {
			Map map = new HashMap();

			map.put("entId",entId);
			String vmonth = vo.getMonth().toString();
			if(vmonth.length() == 5){
				vmonth = "0" + vmonth;
			}
			map.put("clmMonth",vmonth);
			map.put("level",vo.getLevel());
			map.put("memCode",vo.getHpCode());
			map.put("entAmt",Integer.parseInt(vo.getEntitlement()));
			map.put("crtUser",params.get("userId"));
			map.put("stus","1");

			smGmClaimMapper.insertEntitlementDetail(map);
		}

		return result;
	}

	@Override
	public List<EgovMap> selectSmGmEntitlementList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectSmGmEntitlementList(params);
	}

	@Override
	public EgovMap selectMemberEntitlement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectMemberEntitlement(params);
	}

	@Override
	public List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectAppvInfoAndItems(params);
	}

	@Override
	public EgovMap selectClaimInfoForAppv(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectClaimInfoForAppv(params);
	}

	@Override
	public List<EgovMap> selectClaimItemGrpForAppv(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.selectClaimItemGrpForAppv(params);
	}

	@Override
	public int checkOnceAMonth(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return smGmClaimMapper.checkOnceAMonth(params);
	}
}
