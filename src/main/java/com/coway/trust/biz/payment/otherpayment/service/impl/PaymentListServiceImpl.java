package com.coway.trust.biz.payment.otherpayment.service.impl;

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

import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.payment.common.service.impl.CommonPaymentMapper;
import com.coway.trust.biz.payment.otherpayment.service.PaymentListService;
import com.coway.trust.web.payment.otherpayment.controller.PaymentListController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("paymentListService")
public class PaymentListServiceImpl extends EgovAbstractServiceImpl implements PaymentListService {

	private static final Logger LOGGER = LoggerFactory.getLogger(PaymentListServiceImpl.class);

	@Resource(name = "paymentListMapper")
	private PaymentListMapper paymentListMapper;

	@Resource(name = "commonPaymentMapper")
	private CommonPaymentMapper commonPaymentMapper;

	@Autowired
	private FileService fileService;

	@Autowired
	private FileMapper fileMapper;

	/**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap> selectGroupPaymentList(Map<String, Object> params) {
		return paymentListMapper.selectGroupPaymentList(params);
	}

	/**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap> selectPaymentListByGroupSeq(Map<String, Object> params) {
		return paymentListMapper.selectPaymentListByGroupSeq(params);
	}

	/**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap> selectRequestDCFByGroupSeq(Map<String, Object> params) {
		return paymentListMapper.selectRequestDCFByGroupSeq(params);
	}

	@Override
	public int invalidDCF(Map<String, Object> params) {
		return paymentListMapper.invalidDCF(params);
	}

	@Override
	public int invalidFT(Map<String, Object> params) {
		return paymentListMapper.invalidFT(params);
	}

	/**
	 * Payment List - Request DCF 정보 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public EgovMap selectReqDcfInfo(Map<String, Object> params) {
		return paymentListMapper.selectReqDcfInfo(params);
	}

	@Override
	public int invalidReverse(Map<String, Object> params) {
		return paymentListMapper.invalidReverse(params);
	}

	 /**
	 * Payment List - Request DCF
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public EgovMap requestDCF(Map<String, Object> params) {

		EgovMap returnMap = new EgovMap();

		if (paymentListMapper.invalidDCF(params) > 0) {
			returnMap.put("error", "DCF Invalid for ('AER', 'ADR', 'AOR', 'EOR')");
		} else if (paymentListMapper.invalidReverse(params) > 0) {
			returnMap.put("error", "Payment has Active or Completed reverse request.");
		} else {
			//DCF Request 등록
			paymentListMapper.requestDCF(params);

			//Group Payment 정보 수정
			params.put("revStusId", "1");
			paymentListMapper.updateGroupPaymentRevStatus(params);

			returnMap.put("returnKey", params.get("dcfReqId"));
		}

		return returnMap;


	}

	/**
	 * Payment List - Request DCF 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap> selectRequestDCFList(Map<String, Object> params) {
		return paymentListMapper.selectRequestDCFList(params);
	}


	/**
	 * Payment List - Reject DCF
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public void rejectDCF(Map<String, Object> params) {

		//DCF Reject 처리
		params.put("dcfStusId", "6");
		paymentListMapper.updateStatusDCF(params);

		//Group Payment 정보 수정
		params.put("revStusId", "6");
		paymentListMapper.rejectGroupPaymentRevStatus(params);

	}

	/**
	 * Payment List - Approval DCF 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public Map<String, Object> approvalDCF(Map<String, Object> params) {
		//Approval DCF 처리 프로시저 호출
		//Map<String, Object> returnMap = new HashMap<String, Object>();
		//paymentListMapper.approvalDCF(params);

		//LOGGER.debug("returnMap : {} ", returnMap);
		int count = paymentListMapper.dcfDuplicates(params);
		if (count > 0) {
			Map<String, Object> returnMap = new HashMap<String, Object>();
			returnMap.put("error", "DCF has already been approved before.");
			return returnMap;
		}
		return paymentListMapper.approvalDCF(params);


	}

	/**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap> selectFTOldData(Map<String, Object> params) {
		return paymentListMapper.selectFTOldData(params);
	}

	/**
	 * Request Fund Transfer
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
    public EgovMap requestFT(Map<String, Object> paramMap, List<Object> paramList ) {

    	LOGGER.debug("params : {} ", paramMap);

		EgovMap returnMap = new EgovMap();

    	int count = paymentListMapper.invalidFT(paramMap);

    	if (count > 0) {
    		returnMap.put("error", "FT Invalid for 'EOR'");
    	} else if (paymentListMapper.invalidReverse(paramMap) > 0) {
			returnMap.put("error", "Payment has Active or Completed reverse request.");
		} else {
    		//Payment 임시테이블(PAY0240T) 시퀀스 조회
    		Integer seq = commonPaymentMapper.getPayTempSEQ();


    		//임시정보 count
    		int isSource = commonPaymentMapper.countTmpPaymentInfoFT(paramMap);

    		//기존에 PAY0240T에 데이터가 없으면 PAY0064D/PAY0065D에서 데이터를 가져온다.
    		if(isSource == 0){
    			//payment 임시정보 등록
    			paramMap.put("seq", seq);
    			commonPaymentMapper.insertTmpPaymentInfoFT2(paramMap);

    		}else{
    			//payment 임시정보 등록
    			paramMap.put("seq", seq);
    			commonPaymentMapper.insertTmpPaymentInfoFT(paramMap);

    		}

    		//billing 임시정보 등록
    		if (paramList.size() > 0) {
    			Map<String, Object> hm = null;
    			for (Object map : paramList) {
    				hm = (HashMap<String, Object>) map;
    				hm.put("seq", seq);
    				commonPaymentMapper.insertTmpBillingInfo(hm);
    			}
    		}

    		//Request F/T 정보 등록
    		paymentListMapper.requestFT(paramMap);

    		//Group Payment 정보 수정
    		paramMap.put("ftStusId", "1");
    		paymentListMapper.updateGroupPaymentFTStatus(paramMap);


    		//WOR 번호 조회
    		returnMap.put("returnKey", paramMap.get("ftReqId"));
    	}

		return returnMap;

    }

    /**
	 * Payment List - Request FT 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap> selectRequestFTList(Map<String, Object> params) {
		return paymentListMapper.selectRequestFTList(params);
	}

	/**
	 * Payment List - Request FT 상세정보 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public EgovMap selectReqFTInfo(Map<String, Object> params) {
		return paymentListMapper.selectReqFTInfo(params);
	}


	/**
	 * Payment List - Reject FT
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public void rejectFT(Map<String, Object> params) {

		//DCF Reject 처리
		params.put("ftStusId", "6");
		paymentListMapper.updateStatusFT(params);

		//Group Payment 정보 수정
    	paymentListMapper.updateGroupPaymentFTStatus(params);

	}

	/**
	 * Payment List - Approval FT 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public int approvalFT(Map<String, Object> params) {
		//Approval DCF 처리 프로시저 호출
		int count = paymentListMapper.ftDuplicates(params);
		if (count > 0) {
			return 0;
		}
		paymentListMapper.approvalFT(params);
		return 1;
	}

	/* CELESTE 20230306 [S] */
	@Override
	public void insertAttachment(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
	    LOGGER.debug("params =====================================>>  " + params.toString());
	    LOGGER.debug("list.size : {}", list.size());
	    int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get("userId"));
		params.put("fileGroupKey", fileGroupKey);
	}

	/*public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, Map<String, Object> params, String seq) {
	    LOGGER.debug("insertFile :: Start");

	    int atchFlId = Integer.parseInt(params.get("atchFileGroupId").toString());

	    FileGroupVO fileGroupVO = new FileGroupVO();

	    Map<String, Object> flInfo = new HashMap<String, Object>();
	    flInfo.put("atchFileId", atchFlId);
	    flInfo.put("atchFileName", flVO.getAtchFileName());
	    flInfo.put("fileSubPath", flVO.getFileSubPath());
	    flInfo.put("physiclFileName", flVO.getPhysiclFileName());
	    flInfo.put("fileExtsn", flVO.getFileExtsn());
	    flInfo.put("fileSize", flVO.getFileSize());
	    flInfo.put("filePassword", flVO.getFilePassword());
	    flInfo.put("fileUnqKey", params.get("claimUn"));
	    flInfo.put("fileKeySeq", seq);

	    paymentListMapper.insertFileDetail(flInfo);

	    fileGroupVO.setAtchFileGrpId(fileGroupKey);
	    fileGroupVO.setAtchFileId(atchFlId);
	    fileGroupVO.setChenalType(flType.getCode());
	    fileGroupVO.setCrtUserId(Integer.parseInt(params.get("userId").toString()));
	    fileGroupVO.setUpdUserId(Integer.parseInt(params.get("userId").toString()));

	    fileMapper.insertFileGroup(fileGroupVO);

	    LOGGER.debug("insertFile :: End");
	  }*/

	@Override
	public List<EgovMap> selectRefundOldData(Map<String, Object> params) {
		return paymentListMapper.selectRefundOldData(params);
	}

	@Override
	public int invalidRefund(Map<String, Object> params) {
		return paymentListMapper.invalidRefund(params);
	}

	@Override
	public int invalidStatus(Map<String, Object> params) {
		return paymentListMapper.invalidStatus(params);
	}

	@Override
	public List<EgovMap> selectInvalidORType(Map<String, Object> params) {
		params.put("ind", params.get("type"));
		return paymentListMapper.selectInvalidORType(params);
	}

	@Override
	public EgovMap requestRefund(Map<String, Object> paramMap, List<Object> paramList , List<Object> apprList) {

    	LOGGER.debug("params : {} ", paramMap); //formInfo
    	LOGGER.debug("params : {} ", paramList); //gridList
    	LOGGER.debug("params : {} ", apprList); //apprList

		EgovMap returnMap = new EgovMap();

		String[] groupSeq = paramMap.get("groupSeq").toString().replace("\"","").split(",");
		String[] payId = paramMap.get("payId").toString().replace("\"","").split(",");
		String[] appTypeId = paramMap.get("appTypeId").toString().replace("\"","").split(",");

		paramMap.put("groupSeq", groupSeq);
		paramMap.put("payId", payId);
		paramMap.put("appTypeId", appTypeId);

		String userId = paramMap.get("userId").toString();
		String userName = paramMap.get("userName").toString();

    	int count = paymentListMapper.invalidRefund(paramMap);
    	List<EgovMap> invalidTypeList = paymentListMapper.selectInvalidORType(paramMap);

    	if (count > 0) {
    		returnMap.put("error", "Refund Invalid for " + invalidTypeList);
    	} else if (paymentListMapper.invalidStatus(paramMap) > 0) {
			returnMap.put("error", "Payment has Active or Completed Refund request.");
		} else {

			int refundReqId = paymentListMapper.getNextSeq();
			paramMap.put("refundReqId", refundReqId);

    		//temporary information count
			/*int isSource = commonPaymentMapper.countTmpPaymentInfoFT(paramMap);

    		//If there is no data in PAY0240T, data is imported from PAY0064D/PAY0065D.
    		if(isSource == 0){
    			//payment 임시정보 등록
    			paramMap.put("seq", seq);
    			commonPaymentMapper.insertTmpPaymentInfoFT2(paramMap);

    		}else{
    			//payment 임시정보 등록
    			paramMap.put("seq", seq);
    			commonPaymentMapper.insertTmpPaymentInfoFT(paramMap);
    		}

    		//Registration of billing temporary information
    		if (paramList.size() > 0) {
    			Map<String, Object> hm = null;
    			for (Object map : paramList) {
    				hm = (HashMap<String, Object>) map;
    				hm.put("seq", seq);
    				commonPaymentMapper.insertTmpBillingInfo(hm);
    			}
    		}*/

    		//Insert new refund master
    		paymentListMapper.requestRefundM(paramMap);

    		if (paramList.size() > 0) {
    			int seq = 1;
    			Map hm = null;
    			for (Object map : paramList) {
    				hm = (HashMap<String, Object>) map;
    				String ldgrType;
    				hm.put("refundReqId", refundReqId);
    				hm.put("refundSeq", seq);
    				hm.put("userId", userId);
    				String salesOrdId = paymentListMapper.getSalesOrdId(hm.get("salesOrdNo").toString());
    				hm.put("salesOrdId", salesOrdId);
    				hm.put("refundMode", paramMap.get("refundMode"));
    				/*if(hm.get("appType") != null){
    					String appType = hm.get("appType").toString();

    					switch (appType) {
    				      case "RENTAL":
    				    	  ldgrType = "1";
    				    	  hm.put("ldgrType", ldgrType);
    				        break;
    				      case "OUT":
    				    	  ldgrType = "2";
    				    	  hm.put("ldgrType", ldgrType);
    				        break;
    				      case "MEMBERSHIP":
    				    	  ldgrType = "3";
    				    	  hm.put("ldgrType", ldgrType);
    				        break;
    				      case "AS":
    				    	  ldgrType = "4";
    				    	  hm.put("ldgrType", ldgrType);
    				        break;
    				      case "OUT_MEM":
    				    	  ldgrType = "5";
    				    	  hm.put("ldgrType", ldgrType);
    				        break;
    				      case "HP":
    				    	  ldgrType = "6";
    				    	  hm.put("ldgrType", ldgrType);
    				        break;
    				    }
    				}*/
    				LOGGER.debug("requestRefundD =====================================>>  " + hm);
    				paymentListMapper.requestRefundDOld(hm); //insert old refund details
    				paymentListMapper.requestRefundDNew(hm); //insert new refund details //REFUND DOES NOT HAVE NEW ORDER TO KEY-IN
    				seq++;
    			}
    		}

    		// insert approval master
    		String appvPrcssNo = paymentListMapper.getNextApprSeq();
    		if(apprList.size() > 0) {
    			EgovMap apprMap = new EgovMap();
    			apprMap.put("appvPrcssNo", appvPrcssNo);
    			apprMap.put("refundReqId", refundReqId);
    			apprMap.put("userId", userId);
    			apprMap.put("userName", userName);
    			apprMap.put("appvPrcssStus", "P");
    			apprMap.put("appvLineCnt", apprList.size());
    			apprMap.put("appvLinePrcssCnt", 0);
    			LOGGER.debug("insertApproveMaster =====================================>>  " + apprMap);
    			paymentListMapper.insertApproveMaster(apprMap);
    		}

    		// insert approval details
    		if(apprList.size() > 0) {
    			Map hm = null;
    			List<String> appvLineUserId = new ArrayList<>();
    			int apprCount = apprList.size();
    			for(Object map : apprList) {
    				hm = (HashMap<String, Object>) map;
    				hm.put("refundReqId", refundReqId);
    				hm.put("userId", userId);
    				hm.put("appvPrcssStus", "P");
    				hm.put("apprCount", apprCount);
    				hm.put("appvPrcssNo", appvPrcssNo);
    				LOGGER.debug("insertApproveDetail =====================================>>  " + hm);
    				paymentListMapper.insertApproveDetail(hm);
    			}

    			// insert notification

    			Map ntf = (HashMap<String, Object>) apprList.get(0);
    			ntf.put("refundReqId", refundReqId);

    			EgovMap ntfDtls = new EgovMap();
    			ntfDtls = (EgovMap) paymentListMapper.getNtfUser(ntf);

    			ntf.put("code", "REF");
    			ntf.put("codeName", "Refund");
    			ntf.put("refundReqId", refundReqId);
    			ntf.put("appvStus", "R");
    			ntf.put("rejctResn", "Pending Approval.");
    			ntf.put("reqstUserId", ntfDtls.get("userName"));
    			ntf.put("userId", ntfDtls.get("userId"));

    			LOGGER.debug("ntf =====================================>>  " + ntf);
    			paymentListMapper.insertNotification(ntf);
    		}


    		/*//Edit Group Payment Information
    		paramMap.put("ftStusId", "1");
    		paymentListMapper.updateGroupPaymentFTStatus(paramMap);*/


    		//WOR Number Lookup
    		//returnMap.put("returnKey", paramMap.get("ftReqId"));
    		returnMap.put("success", "Refund Request has submitted with Request No: REF" + refundReqId);
    	}

		return returnMap;

    }

	@Override
	public List<EgovMap> selectRequestRefundList(Map<String, Object> params) {
		return paymentListMapper.selectRequestRefundList(params);
	}

	@Override
	public List<EgovMap> selectRequestRefundByGroupSeq(Map<String, Object> params) {
		return paymentListMapper.selectRequestRefundByGroupSeq(params);
	}

	@Override
	public EgovMap selectReqRefundInfo(Map<String, Object> params) {
		EgovMap returnMap = new EgovMap();

		EgovMap reqRefundInfo = paymentListMapper.selectReqRefundInfo(params);
		returnMap.put("reqRefundInfo", reqRefundInfo);

		List<EgovMap> reqRefundApprovalItem = paymentListMapper.selectReqRefundApprovalItem(reqRefundInfo);
		EgovMap appvItem = reqRefundApprovalItem.get(0);
		String reqstUserFullName = (String) reqRefundInfo.get("userFullName");
		String reqstDt = (String) reqRefundInfo.get("refCrtDt");
		String approvalRemark = " [" + reqstDt + "], [Raised by: " + reqstUserFullName + "]: " + reqRefundInfo.get("reqRemark");
		String atchFileGrpId = reqRefundInfo.get("atchFileGrpId").toString();
		String atchFileId = reqRefundInfo.get("atchFileId").toString();

		if(atchFileGrpId != null) {
			List<EgovMap> attachList = paymentListMapper.selectAttachList(atchFileGrpId);
			returnMap.put("attachList", attachList);
		}

		for(int i = 0; i < reqRefundApprovalItem.size(); i++) {
			EgovMap appvLine = reqRefundApprovalItem.get(i);
			String appvStus = (String) appvLine.get("appvStus");
//			String appvLineUserId = (String) appvLine.get("appvLineUserId");
			String appvLineUserName = (String) appvLine.get("appvLineUserName");
			String appvDt = (String) appvLine.get("appvDt");
			String pendingDt = (String) appvLine.get("currDt");
			String appvRemark = (String) appvLine.get("rejctResn");
			if("R".equals(appvStus) || "T".equals(appvStus)) {
				//approvalRemark += " <br/> - Pending By " + appvLineUserName;
				approvalRemark += " \n [" + pendingDt + "], [Pending By: " + appvLineUserName + "] ";
			} else if ("A".equals(appvStus)) {
				//approvalRemark += "<br> - Approval By " + appvLineUserName + " [" + appvDt + "]";
				approvalRemark += " \n [" + appvDt + "], [Approval By: " + appvLineUserName + "]: " + appvRemark ;
			} else if ("J".equals(appvStus)) {
				//approvalRemark += "<br> - Reject By " + appvLineUserName + " [" + appvDt + "]";
				approvalRemark += " \n [" + appvDt + "], [Reject By: " + appvLineUserName + "]: " + appvRemark ;
			}
		}
		returnMap.put("approvalRemark", approvalRemark);
		return returnMap;
	}

	@Override
	public List<EgovMap> selectReqRefundApprovalItem(Map<String, Object> params) {
		return paymentListMapper.selectReqRefundApprovalItem(params);
	}

	@Override
	public Map<String, Object> approvalRefund(Map<String, Object> params) {
		//Approval DCF 처리 프로시저 호출
		//Map<String, Object> returnMap = new HashMap<String, Object>();
		//paymentListMapper.approvalDCF(params);

		//LOGGER.debug("returnMap : {} ", returnMap);
		Map<String, Object> returnMap = new HashMap<String, Object>();
		LOGGER.debug("params =====================================>>  " + params);
		String[] groupSeq = params.get("groupSeq").toString().replace("\"","").split(",");
		params.put("groupSeq", groupSeq);
		int count = paymentListMapper.refundDuplicates(params);
		if (count > 0) {
			returnMap.put("error", "Refund has already been approved before.");
			return returnMap;
		}

		Map<String, Object> items =  new HashMap<String, Object>();
		items.put("reqId", params.get("reqId").toString());
		items.put("memCode", params.get("memCode").toString());
		EgovMap selectRequestRefundAppvDetails = paymentListMapper.selectRequestRefundAppvDetails(items);
		String remark = (String) params.get("remark");
		String appvPrcssNo = selectRequestRefundAppvDetails.get("appvPrcssNo").toString();
		int appvLineSeq = Integer.parseInt(selectRequestRefundAppvDetails.get("appvLineSeq").toString());
		int appvLineCnt = paymentListMapper.selectAppvLineCnt(appvPrcssNo);
		int appvLinePrcssCnt = paymentListMapper.selectAppvLinePrcssCnt(appvPrcssNo);
		params.put("appvLinePrcssCnt", appvLinePrcssCnt + 1);
		params.put("appvPrcssNo", appvPrcssNo);
		params.put("appvLineSeq", appvLineSeq);
		params.put("appvPrcssStus", "P");
		params.put("appvStus", "A");
		params.put("userId", params.get("userId"));
		params.put("remark", remark);

		LOGGER.debug("now params =====================================>>  " + params);
		paymentListMapper.updateStatusRefundM(params);
		paymentListMapper.updateStatusRefundD(params);

		//Update Approval Detail Table When the approval cycle is not the last
		if(appvLineCnt > appvLineSeq) {
			params.put("appvStus", "R");
			params.put("appvLineSeq", appvLineSeq + 1);
			params.put("remark", "");
			LOGGER.debug("next params =====================================>>  " + params);
			paymentListMapper.updateStatusRefundD(params);

			Map<String, Object> ntf = new HashMap<String, Object>();
			String refundReqId = paymentListMapper.selectRefundReqId(appvPrcssNo);
			ntf.put("memCode", params.get("memCode"));
			ntf.put("refundReqId", refundReqId);

			EgovMap ntfDtls = paymentListMapper.getNtfUser(ntf);

			ntf.put("code", "REF");
			ntf.put("codeName", "Refund");
			ntf.put("refundReqId", refundReqId);
			ntf.put("appvStus", "R");
            ntf.put("rejctResn", "Pending Approval.");
			ntf.put("reqstUserId", ntfDtls.get("userName"));
			ntf.put("userId", ntfDtls.get("userId"));
			paymentListMapper.insertNotification(ntf);

            LOGGER.debug("ntf =====================================>>  " + ntf);

            paymentListMapper.insertNotification(ntf);
            returnMap.put("msg", "You have successfully approved the Refund Request. Notification has been sent to the next Approver.");
		}

		//Update Approval Detail Table When the approval cycle is the last
		if(appvLineCnt == appvLinePrcssCnt + 1) {
			paymentListMapper.updateLastAppvLine(params);
			paymentListMapper.updateStatusRefundD(params);
			returnMap.put("msg", "Refund Request has been successfully approved. <br>*Forward to Finance AR for refund process.");
		}

		LOGGER.debug("params =====================================>>  " + params);
		returnMap.put("success", "success");
		return returnMap;
	}

	/*@Override
	public void rejectRefund(Map<String, Object> params) {

		//Refund Reject
		params.put("refStusId", "J");
		paymentListMapper.updateStatusDCF(params);
		paymentListMapper.updateStatusDCF(params);

		//Group Payment 정보 수정
		params.put("revStusId", "6");
		paymentListMapper.rejectGroupPaymentRevStatus(params);

	}*/

	@Override
	public void rejectRefund(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		List<Object> oldInfoGridList = (List<Object>) params.get("oldInfoGridList");
		String rejctResn = (String) params.get("rejctResn");
		for (int i = 0; i < oldInfoGridList.size(); i++) {
			Map<String, Object> oldInfoDet = (Map<String, Object>) oldInfoGridList.get(i);
			String appvPrcssNo = (String) oldInfoDet.get("appvPrcssNo");
			int appvLineCnt = paymentListMapper.selectAppvLineCnt(appvPrcssNo);
			int appvLinePrcssCnt = paymentListMapper.selectAppvLinePrcssCnt(appvPrcssNo);
			oldInfoDet.put("appvLinePrcssCnt", appvLinePrcssCnt + 1);
			oldInfoDet.put("appvPrcssStus", "J");
			oldInfoDet.put("appvStus", "J");
			oldInfoDet.put("rejctResn", rejctResn);
			oldInfoDet.put("userId", params.get("userId"));

			LOGGER.debug("rejection oldInfoDet =====================================>>  " + oldInfoDet);
			paymentListMapper.updateStatusRefundM(oldInfoDet);
			paymentListMapper.updateStatusRefundD(oldInfoDet);


			Map<String, Object> ntf = new HashMap<String, Object>();
			String refundReqId = paymentListMapper.selectRefundReqId(appvPrcssNo);
			ntf.put("memCode", params.get("userName"));
			ntf.put("refundReqId", refundReqId);

			EgovMap ntfDtls = paymentListMapper.getNtfUser(ntf);

			ntf.put("code", "REF");
			ntf.put("codeName", "Refund");
			ntf.put("refundReqId", refundReqId);
			ntf.put("appvStus", "J");
			ntf.put("rejctResn", rejctResn);
			ntf.put("reqstUserId", ntfDtls.get("userName"));
			ntf.put("userId", ntfDtls.get("userId"));
			paymentListMapper.insertNotification(ntf);
		}
	}

	@Override
	public EgovMap selectAttachmentInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return paymentListMapper.selectAttachmentInfo(params);
	}

	@Override
	public String selectAllowFlg(Map<String, Object> params) {
		return paymentListMapper.selectAllowFlg(params);
	}
	/* CELESTE 20230306 [E] */

}
