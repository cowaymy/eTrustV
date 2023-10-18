package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

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
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ibm.icu.text.SimpleDateFormat;

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
		paramMap.put("ind", "REF");
		paramMap.put("type", "REF");

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

    				SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    				Date requestDate = null;
					Timestamp timestamp = null;

    				if(hm.get("payItmRefDt").toString().contains("/")){
						try {
							// convert string to datetime
							requestDate = dateFormat.parse((String) hm.get("payItmRefDt"));
						} catch (ParseException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					} else{
						//if frontend pass date value in timestamp format
	                	timestamp = new Timestamp(Long.parseLong(hm.get("payItmRefDt").toString()));
	                    requestDate = new Date(timestamp.getTime());
	                }

    				hm.put("payItmRefDt", requestDate);

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
    			ntf.put("userId", userId);

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

		Map<String, Object> items =  new HashMap<String, Object>();
		items.put("reqId", params.get("reqNo"));
		items.put("memCode", params.get("memCode").toString());
		EgovMap selectRequestRefundAppvDetails = paymentListMapper.selectRequestRefundAppvDetails(items);

		String allowAppvFlg = "N";
		if(selectRequestRefundAppvDetails !=null && selectRequestRefundAppvDetails.get("appvStus").toString().equals("R")){
			allowAppvFlg = "Y";
		}

		returnMap.put("allowAppvFlg", allowAppvFlg);

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
		items.put("reqId", params.get("reqNo").toString());
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
			//ntf.put("memCode", params.get("memCode"));
			ntf.put("appvPrcssNo", appvPrcssNo);
			ntf.put("appvLineSeq", params.get("appvLineSeq"));
			ntf.put("refundReqId", refundReqId);

			EgovMap ntfDtls = paymentListMapper.getNtfUser(ntf);

			ntf.put("code", "REF");
			ntf.put("codeName", "Refund");
			ntf.put("refundReqId", refundReqId);
			ntf.put("appvStus", "R");
            ntf.put("rejctResn", "Pending Approval.");
			ntf.put("reqstUserId", ntfDtls.get("userName"));
			ntf.put("userId", params.get("userId"));
			paymentListMapper.insertNotification(ntf);

            LOGGER.debug("ntf =====================================>>  " + ntf);

//            paymentListMapper.insertNotification(ntf);
            returnMap.put("msg", "You have successfully approved the Refund Request. Notification has been sent to the next Approver.");
		}

		//Update Approval Detail Table When the approval cycle is the last
		if(appvLineCnt == appvLinePrcssCnt + 1) {
			paymentListMapper.updateLastAppvLine(params);
			paymentListMapper.updateStatusRefundD(params);
			/*returnMap.put("msg", "Refund Request has been successfully approved. <br>*Forward to Finance AR for refund process.");*/ //comment due to last approver is not fixed
			returnMap.put("msg", "Refund Request has been successfully approved.");
		}

		LOGGER.debug("params =====================================>>  " + params);
		returnMap.put("success", "success");
		return returnMap;
	}

	@Override
	public void rejectRefund(Map<String, Object> params) {
		LOGGER.debug("params =====================================>>  " + params);

//		String[] reqNo = params.get("reqNo").toString().replace("\"","").split(",");
//		params.put("reqNo", reqNo);
		EgovMap data = paymentListMapper.selectReqRefundInfo(params);

		String appvPrcssNo = data.get("appvPrcssNo").toString();
		int appvLineCnt = paymentListMapper.selectAppvLineCnt(appvPrcssNo);
		int appvLinePrcssCnt = paymentListMapper.selectAppvLinePrcssCnt(appvPrcssNo);

		params.put("appvStus", "J");
		params.put("appvPrcssStus", "J");
 		params.put("appvLinePrcssCnt", appvLinePrcssCnt+1);
 		params.put("appvLineSeq", appvLinePrcssCnt+1);
 		params.put("rejctResn", params.get("remark"));
 		params.put("userId", params.get("userId"));
 		params.put("appvPrcssNo", appvPrcssNo);

		paymentListMapper.updateStatusRefundM(params);
		paymentListMapper.updateStatusRefundD(params);

		Map<String, Object> ntf = new HashMap<String, Object>();
		String refundReqId = paymentListMapper.selectRefundReqId(appvPrcssNo);
//		ntf.put("memCode", params.get("userName"));
//		ntf.put("refundReqId", refundReqId);
//		ntf.put("appvLineSeq", params.get("appvLineSeq"));
//
//		EgovMap ntfDtls = paymentListMapper.getNtfUser(ntf);

		ntf.put("code", "REF");
		ntf.put("codeName", "Refund");
		ntf.put("refundReqId", refundReqId);
		ntf.put("appvStus", "J");
		ntf.put("rejctResn", params.get("rejctResn"));
		ntf.put("reqstUserId", data.get("userName"));
		ntf.put("userId", params.get("userId"));

		paymentListMapper.insertNotification(ntf);
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

	/*@Override
	public void rejectRefund(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		List<Object> oldInfoGridList = (List<Object>)params.get("oldInfoGridList");
		String rejctResn = (String) params.get("remark");
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
*/
	@Override
	public EgovMap selectAttachmentInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return paymentListMapper.selectAttachmentInfo(params);
	}

	@Override
	public EgovMap selectAllowFlg(Map<String, Object> params) {
		return paymentListMapper.selectAllowFlg(params);
	}
	/* CELESTE 20230306 [E] */

	/* BOI DCF*/
	@Override
	public EgovMap selectReqDcfNewInfo(Map<String, Object> params) {
		return paymentListMapper.selectReqDcfNewInfo(params);
	}

	@Override
	public List<EgovMap> selectReqDcfNewAppv(Map<String, Object> params) {
		return paymentListMapper.selectReqDcfNewAppv(params);
	}

	@Override
	public List<EgovMap> selectRequestNewDCFByGroupSeq(Map<String, Object> params) {
		return paymentListMapper.selectRequestNewDCFByGroupSeq(params);
	}

	@Override
	public EgovMap selectDcfInfo(Map<String, Object> params) {
		return paymentListMapper.selectDcfInfo(params);
	}

	@Override
	public EgovMap requestDCF2(Map<String, Object> params) throws JsonParseException, JsonMappingException, IOException {

		EgovMap returnMap = new EgovMap();

		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> dcfInfoResult = mapper.readValue(params.get("dcfInfo").toString(), new TypeReference<Map<String, Object>>(){});
		List<Map<String, Object>> oldRequestDcfGridResult = mapper.readValue(params.get("oldRequestDcfGrid").toString(), new TypeReference<List<Map<String, Object>>>(){});
    	List<Map<String, Object>> newRequestDcfGridResult = mapper.readValue(params.get("newRequestDcfGrid").toString(), new TypeReference<List<Map<String, Object>>>(){});
    	Map<String, Object> cashPayInfoFormResult = mapper.readValue(params.get("cashPayInfoForm").toString(), new TypeReference<Map<String, Object>>(){});
    	Map<String, Object> chequePayInfoFormResult = mapper.readValue(params.get("chequePayInfoForm").toString(), new TypeReference<Map<String, Object>>(){});
    	Map<String, Object> creditPayInfoFormResult = mapper.readValue(params.get("creditPayInfoForm").toString(), new TypeReference<Map<String, Object>>(){});
    	Map<String, Object> onlinePayInfoFormResult = mapper.readValue(params.get("onlinePayInfoForm").toString(), new TypeReference<Map<String, Object>>(){});
    	List<Map<String, Object>> apprGridListResult = mapper.readValue(params.get("apprGridList").toString(), new TypeReference<List<Map<String, Object>>>(){});

		//	REQUEST DCF INFO
    	int isRekeyIn = Integer.parseInt(dcfInfoResult.get("rekeyStus").toString());
    	if(isRekeyIn == 1){
    		int payType = Integer.parseInt(dcfInfoResult.get("payType").toString());
    		dcfInfoResult.put("newPayType", payType);

    		// Saving criteria follow Manual Key-In - CommonPaymentController - saveNormalPayment (105, 106, 108 Cash, Cheque, Online) - with Transaction ID
    		// Saving criteria follow Advance Key-In - AdvPaymentController - saveAdvPayment (105, 106, 108 Cash, Cheque, Online) - without Transaction ID
			// Saving criteria follow Credit Card Key-In - CommonPaymentController - savePayment (107 Credit card)
    		if(payType == 105 ){ // Cash

    			dcfInfoResult.put("bankChargeAmt", 0); // WILL HAVE NO AMOUNT, COZ UI DONT HAVE THIS FIELD
    			dcfInfoResult.put("slipNo", cashPayInfoFormResult.get("cashSlipNo"));
    			dcfInfoResult.put("bankType", cashPayInfoFormResult.get("cashBankType"));
    			dcfInfoResult.put("bankAcc", cashPayInfoFormResult.get("cashBankAcc"));
    			dcfInfoResult.put("vaAcc", cashPayInfoFormResult.get("cashVAAcc"));
    			dcfInfoResult.put("trxDate", cashPayInfoFormResult.get("cashTrxDate"));
    			dcfInfoResult.put("trxId", cashPayInfoFormResult.get("cashTrxId"));
    			dcfInfoResult.put("payItemIsLock", false);
    			dcfInfoResult.put("payItemIsThirdParty", false);
    			dcfInfoResult.put("payItemStatusId", 1);
    			dcfInfoResult.put("isFundTransfer", false);
     			dcfInfoResult.put("skipRecon", false);
     			dcfInfoResult.put("payItemCardTypeId", 0);
     			dcfInfoResult.put("payRoute", "WEB");

 				// IF TRX_ID IS NOT NULL, SAME PROCESS WITH MANUAL KEY IN;
     			// ELSE SAME PROCESS WITH ADVANCE KEY IN
     			dcfInfoResult.put("keyInScrn", (cashPayInfoFormResult.get("cashTrxId") != null && !cashPayInfoFormResult.get("cashTrxId").toString().isEmpty())? "NOR" : "ADV");

    		}else if(payType == 106){ // Cheque

    			dcfInfoResult.put("bankChargeAmt", 0);
    			dcfInfoResult.put("chqNo", chequePayInfoFormResult.get("chequeSlipNo"));
    			dcfInfoResult.put("bankType", chequePayInfoFormResult.get("chequeBankType"));
    			dcfInfoResult.put("bankAcc", chequePayInfoFormResult.get("chequeBankAcc"));
    			dcfInfoResult.put("vaAcc", chequePayInfoFormResult.get("chequeVAAcc"));
    			dcfInfoResult.put("trxDate", chequePayInfoFormResult.get("chequeTrxDate"));
    			dcfInfoResult.put("trxId", chequePayInfoFormResult.get("chequeTrxId"));
    			dcfInfoResult.put("payItemIsLock", false);
    			dcfInfoResult.put("payItemIsThirdParty", false);
    			dcfInfoResult.put("payItemStatusId", 1);
    			dcfInfoResult.put("isFundTransfer", false);
     			dcfInfoResult.put("skipRecon", false);
     			dcfInfoResult.put("payItemCardTypeId", 0);
     			dcfInfoResult.put("payRoute", "WEB");

     			// IF TRX_ID IS NOT NULL, SAME PROCESS WITH MANUAL KEY IN;
     			// ELSE SAME PROCESS WITH ADVANCE KEY IN
     			dcfInfoResult.put("keyInScrn", (chequePayInfoFormResult.get("chequeTrxId") != null && !chequePayInfoFormResult.get("chequeTrxId").toString().isEmpty()) ? "NOR" : "ADV");

    		}else if(payType == 108){ // Online

    		     dcfInfoResult.put("bankChargeAmt", onlinePayInfoFormResult.get("onlineBankChgAmt") != null ? onlinePayInfoFormResult.get("onlineBankChgAmt") : 0);
    		     dcfInfoResult.put("bankType", onlinePayInfoFormResult.get("onlineBankType"));
    		     dcfInfoResult.put("bankAcc", onlinePayInfoFormResult.get("onlineBankAcc") != null ? onlinePayInfoFormResult.get("onlineBankAcc") : 0);
    		     dcfInfoResult.put("vaAcc", onlinePayInfoFormResult.get("onlineVAAcc"));
    		     dcfInfoResult.put("trxDate", onlinePayInfoFormResult.get("onlineTrxDate"));
     			 dcfInfoResult.put("eft", onlinePayInfoFormResult.get("onlineEFT"));
    		     dcfInfoResult.put("trxId", onlinePayInfoFormResult.get("onlineTrxId"));
    		     dcfInfoResult.put("payItemIsLock", false);
    		     dcfInfoResult.put("payItemIsThirdParty", false);
    		     dcfInfoResult.put("payItemStatusId", 1);
    		     dcfInfoResult.put("isFundTransfer", false);
    		     dcfInfoResult.put("skipRecon", false);
    		     dcfInfoResult.put("payItemCardTypeId", 0);
    		     dcfInfoResult.put("payRoute", "WEB");

    		    // IF TRX_ID IS NOT NULL, SAME PROCESS WITH MANUAL KEY IN;
      			// ELSE SAME PROCESS WITH ADVANCE KEY IN
      			dcfInfoResult.put("keyInScrn", (onlinePayInfoFormResult.get("onlineTrxId") != null && !onlinePayInfoFormResult.get("onlineTrxId").toString().isEmpty()) ? "NOR" : "ADV");

    		} else if(payType == 107){ // Credit card

    			 String cardNo = creditPayInfoFormResult.get("creditCardNo1").toString() + creditPayInfoFormResult.get("creditCardNo2").toString() + creditPayInfoFormResult.get("creditCardNo3").toString() + creditPayInfoFormResult.get("creditCardNo4").toString();

    			 dcfInfoResult.put("cardMode", creditPayInfoFormResult.get("creditCardMode"));
    			 dcfInfoResult.put("issueBank", creditPayInfoFormResult.get("creditIssueBank"));
    			 dcfInfoResult.put("trxDate", creditPayInfoFormResult.get("creditTrxDate"));
    			 dcfInfoResult.put("cardNo", cardNo);
    			 dcfInfoResult.put("cardType", creditPayInfoFormResult.get("creditCardType"));
    			 dcfInfoResult.put("cardBrand", creditPayInfoFormResult.get("creditCardBrand"));
    			 dcfInfoResult.put("cardApprovalNo", creditPayInfoFormResult.get("creditApprNo"));
    			 dcfInfoResult.put("expDt", creditPayInfoFormResult.get("creditExpiryMonth") + "/" + creditPayInfoFormResult.get("creditExpiryYear"));
    			 dcfInfoResult.put("tenure", creditPayInfoFormResult.get("creditTenure"));
    			 dcfInfoResult.put("cardHolder", creditPayInfoFormResult.get("creditCardHolderName"));
    			 dcfInfoResult.put("merchantBank", creditPayInfoFormResult.get("creditMerchantBank"));
    			 dcfInfoResult.put("isOnline", "1299".equals(String.valueOf(creditPayInfoFormResult.get("creditCardMode"))) ? 0 : 1);
    			 dcfInfoResult.put("payItemIsLock", 0);
    			 dcfInfoResult.put("payItemIsThirdParty", 0);
    			 dcfInfoResult.put("payItemStatusId", 1);
    			 dcfInfoResult.put("isFundTransfer", 0);
    			 dcfInfoResult.put("skipRecon", 0);
    			 dcfInfoResult.put("payItemCardTypeId", creditPayInfoFormResult.get("creditCardType"));
    			 dcfInfoResult.put("payItmCardMode", creditPayInfoFormResult.get("creditCardMode"));
    			 dcfInfoResult.put("payRoute", "WEB");
          		 dcfInfoResult.put("keyInScrn", "CRC");
    		}
    	}

    	int keyInBranch = Integer.parseInt(params.get("keyInBranch").toString());
    	int userId = Integer.parseInt(params.get("userId").toString());

    	// GET PAY0344M SEQ
    	int nextSeq = paymentListMapper.getNextSeq();

    	// INSERT DCF REQUEST TO PAY0344M
    	dcfInfoResult.put("nextSeq", nextSeq);
    	dcfInfoResult.put("atchGrpId", params.get("fileGroupKey"));
    	dcfInfoResult.put("atchFileId", params.get("atchFileId"));
    	dcfInfoResult.put("keyInBranch", keyInBranch);
    	dcfInfoResult.put("userId", userId);
    	paymentListMapper.requestDcfInfo(dcfInfoResult);


		//DCF REQUEST AND INSERT TO PAY0345D
		Map<String, Object> oldRequestDcfGridList = null;
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		if(oldRequestDcfGridResult.size() > 0 ){
			for(int i = 0 ; i < oldRequestDcfGridResult.size() ; i++){
				oldRequestDcfGridList = oldRequestDcfGridResult.get(i);

				Date requestDate = null;
				Timestamp timestamp = null;
				if(oldRequestDcfGridResult.get(i).get("payItmRefDt").toString().contains("/")){
					try {
						// convert string to datetime
						requestDate = dateFormat.parse((String) oldRequestDcfGridResult.get(i).get("payItmRefDt"));
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				} else{
					//if frontend pass date value in timestamp format
                	timestamp = new Timestamp(Long.parseLong(oldRequestDcfGridResult.get(i).get("payItmRefDt").toString()));
                    requestDate = new Date(timestamp.getTime());
                }

				oldRequestDcfGridList.put("nextSeq", nextSeq);
				oldRequestDcfGridList.put("trxDt", requestDate);
				oldRequestDcfGridList.put("userId", userId);

				paymentListMapper.insertOldDcf(oldRequestDcfGridList);
			}
		}

		//INSERT PAY0346D IF REKEYSTUS = 1
		if(isRekeyIn == 1){
			Map<String, Object> newRequestDcfGridList= null;

			if(newRequestDcfGridResult.size() > 0 ){
			  for (int i = 0; i < newRequestDcfGridResult.size() ; i++) {
				  newRequestDcfGridList = newRequestDcfGridResult.get(i);

				  newRequestDcfGridList.put("nextSeq", nextSeq);
				  newRequestDcfGridList.put("userId", userId);
				  paymentListMapper.insertNewDcf(newRequestDcfGridList);
		      }
			}
		}


		// GET PAY0347M SEQ
    	String nextApprSeq = paymentListMapper.getNextApprSeq();

		//APPROVAL AND INSERT TO PAY0347M AND PAY0348D
    	if(apprGridListResult.size() > 0) {

    		EgovMap apprGridMasList = new EgovMap();
    		apprGridMasList.put("nextApprSeq", nextApprSeq);
    		apprGridMasList.put("nextSeq", nextSeq);
    		apprGridMasList.put("appvLineCnt", apprGridListResult.size());
    		apprGridMasList.put("userId", userId);
    		apprGridMasList.put("userName", params.get("userName").toString());

			LOGGER.debug("insertDcfApprMas =====================================>>  " + apprGridMasList);
			paymentListMapper.insertDcfApprMas(apprGridMasList);

    		Map<String, Object> apprGridDetList = null;
        	//APPROVAL DETAIL
			for(int i = 0 ; i < apprGridListResult.size() ; i++){
				apprGridDetList = apprGridListResult.get(i);
				apprGridDetList.put("nextApprSeq", nextApprSeq);
				apprGridDetList.put("userId", userId);

    			paymentListMapper.insertDcfApprDet(apprGridDetList);
			}
		}

    	//Send notification
    	EgovMap dcfNoti = new EgovMap();
//    	int nextNotiSeq = paymentListMapper.getNextNotiSeq();

    	dcfNoti.put("memCode", apprGridListResult.get(0).get("memCode").toString());
    	EgovMap userIdNoti = paymentListMapper.getNtfUser(dcfNoti);

//    	dcfNoti.put("nextNotiSeq", nextNotiSeq);
//    	dcfNoti.put("key", nextSeq);
//    	dcfNoti.put("keyStus", "R");
//    	dcfNoti.put("rem", dcfInfoResult.get("remark"));
//    	dcfNoti.put("userNameNoti", userIdNoti.get("userName"));
//    	dcfNoti.put("userIdNoti", userIdNoti.get("userId"));
//     	paymentListMapper.insertDcfNoti(dcfNoti);

    	dcfNoti.put("code", "DCF");
    	dcfNoti.put("codeName", "Data Change Request");
    	dcfNoti.put("refundReqId", nextSeq); // key
    	dcfNoti.put("appvStus", "R"); // keyStus
    	dcfNoti.put("rejctResn", dcfInfoResult.get("remark")); // rem
		dcfNoti.put("reqstUserId", userIdNoti.get("userName")); // userNameNoti
		dcfNoti.put("userId", userId); // userIdNoti

		paymentListMapper.insertNotification(dcfNoti);

		//Group Payment 정보 수정
		params.put("revStusId", "1");

		String[] groupSeqList = dcfInfoResult.get("groupSeq").toString().split(",");
		params.put("groupSeq",groupSeqList);

		paymentListMapper.updateGroupPaymentRevStatus(params);

    	returnMap.put("reqId", nextSeq);
		return returnMap;
	}

	@Override
	public void rejectNewDCF(Map<String, Object> params) {

		//DCF Reject 처리
		EgovMap data = paymentListMapper.selectDcfInfo(params);

		int appvLineCnt = Integer.parseInt(data.get("appvLineCnt").toString());
		int appvLinePrcssCnt = Integer.parseInt(data.get("appvLinePrcssCnt").toString()) + 1;

		//Update PAY0347M
		params.put("dcfStusId", "J");
 		params.put("appvLinePrcssCnt", appvLinePrcssCnt);
		paymentListMapper.updateStatusNewDCF(params);

 		//Update PAY0348D
 		params.put("appvPrcssNo", data.get("appvPrcssNo").toString());
		params.put("appvStus", "J");
 		params.put("rejctResn", params.get("remark").toString());
 		paymentListMapper.updateStatusNewDCFDet(params);

 		//Send Notification
		EgovMap dcfNoti = new EgovMap();
//    	int nextNotiSeq = paymentListMapper.getNextNotiSeq();

//		dcfNoti.put("userNameNoti", data.get("reqUserName"));
//    	dcfNoti.put("userIdNoti", data.get("reqUserId"));
//    	dcfNoti.put("nextNotiSeq", nextNotiSeq);
//    	dcfNoti.put("key", params.get("reqNo"));
//    	dcfNoti.put("keyStus", "J");
//    	dcfNoti.put("rem", params.get("remark").toString());
//     	paymentListMapper.insertDcfNoti(dcfNoti);

     	dcfNoti.put("code", "DCF");
    	dcfNoti.put("codeName", "Data Change Request");
    	dcfNoti.put("refundReqId", params.get("reqNo")); // key
    	dcfNoti.put("appvStus", "J"); // keyStus
    	dcfNoti.put("rejctResn", params.get("remark").toString()); // rem
		dcfNoti.put("reqstUserId", data.get("reqUserName")); // userNameNoti
		dcfNoti.put("userId", params.get("userId").toString()); // userIdNoti

		paymentListMapper.insertNotification(dcfNoti);

		//Group Payment 정보 수정
		params.put("revStusId", "6");
		paymentListMapper.rejectGroupPaymentRevStatus(params);

	}

	@Override
	public Map<String, Object> approvalNewDCF(Map<String, Object> params){
		//Approval DCF 처리 프로시저 호출
		Map<String, Object> returnMap = new HashMap<String, Object>();
		String returnMsg = "";

		//LOGGER.debug("returnMap : {} ", returnMap);
		int count = paymentListMapper.dcfDuplicates2(params);
		if (count > 0) {
			returnMap.put("message", "DCF has already been approved before.");
			return returnMap;
		}

		EgovMap data = paymentListMapper.selectDcfInfo(params);

		int appvLineCnt = Integer.parseInt(data.get("appvLineCnt").toString());
		int appvLinePrcssCnt = Integer.parseInt(data.get("appvLinePrcssCnt").toString()) + 1;

		if(appvLineCnt == appvLinePrcssCnt){
			int dcfCount = paymentListMapper.selectDcfCount(params);
			int dcfMaxCount = paymentListMapper.getDcfMaxCount();

			if(dcfCount < dcfMaxCount){
    			// LAST APPROVER APPROVE AND START TO GENERATE ROR AND WOR
    			// GENERATE ROR (Rekey In = No / Yes) --  refer to previous confirm dcf process
				List<String> rorList = new ArrayList<>();
				List<String> worList = new ArrayList<>();
				double worAmt = 0.00;
				boolean isApprove = true;
				Map<String, String> error = new HashMap<String, String>();

				paymentListMapper.approvalNewDCF(params);

				if(!params.get("p2").toString().equals("1")){
					returnMsg = "DCF failed submission";

				}else{

					List<Object> ror= (List<Object>) params.get("p1");
					for (Object obj : ror) {
				         Map<String, Object> map = (Map<String, Object>) obj;
				         rorList.add((String) map.get("orNo"));
				    }

    				if(rorList.size() == 0){
    					isApprove = false;
    					returnMsg = "ROR is not generated. This request will be reject. Please contact FAR for further action.";
    					error.put("message", returnMsg);
    					error.put("reqId", params.get("reqNo").toString());
                        paymentListMapper.insertErrorRem(error);

    				}else {

    					returnMsg = "<b>ROR: </b>" + rorList.toString();

    					if(ror.size() == dcfCount){
    						// If amount of generated ROR is same as amount of selected old DCF, only will proceed to generate WOR
            				//GET DATA FROM PAY0344M
            				EgovMap payInfo = paymentListMapper.getPayInfo(params);
            				payInfo.put("itemRem",params.get("remark").toString());
            				int isRekeyIn = Integer.parseInt(payInfo.get("isRekeyIn").toString());

            				// GENERATE WOR (Rekey In = Yes)
            				if(isRekeyIn == 1){
            					// GET PAY0240T NEXT SEQ
            					int nextTmpSeq = commonPaymentMapper.getPayTempSEQ();
            					payInfo.put("nextTmpSeq", nextTmpSeq);

            					//GET DATA FROM PAY0346D
            					List<EgovMap> newDcfInfo = paymentListMapper.getNewDcfInfo(params);

            					Map<String, Object> dcf = null;
            					Map<String, Object> procedureInfo = new HashMap<String, Object>();

            					// CHECK PAY TYPE = CASH, CHEQUE, ONLINE OR CREDIT CARD
            					if(payInfo.get("newPayType").toString().equals("107")){ // Credit card

            						// Saving criteria follow Credit Card Key-In - CommonPaymentController - savePayment [insertTmpPaymentInfo] (107 Credit card)
            						//INSERT DATA FROM PAY0344M TO PAY0240T
            						paymentListMapper.insertTmpPaymentInfo(payInfo);

            						if(newDcfInfo.size() > 0){
            							for(int i = 0; i < newDcfInfo.size() ; i++){
            								dcf = newDcfInfo.get(i);
            								dcf.put("nextTmpSeq", nextTmpSeq);

            								//INSERT DATA FROM PAY0346D TO PAY0241T
            								paymentListMapper.insertTmpBillingInfo(dcf);

            								if("CARE_SRVC".equals(String.valueOf(dcf.get("appType")))){
            									dcf.put("userId", params.get("userId"));
            									dcf.put("ordId", dcf.get("salesOrdId").toString());
            									commonPaymentMapper.updateCareSalesMStatus(dcf);
            								}
            							}
            						}

            						 procedureInfo.put("reqNo", params.get("reqNo"));
            						 procedureInfo.put("seq", nextTmpSeq);
            						 procedureInfo.put("userid", params.get("userId"));
            						 procedureInfo.put("keyInPayRoute", payInfo.get("payRoute"));
            						 procedureInfo.put("keyInScrn", payInfo.get("keyInScrn"));

            						 paymentListMapper.processPayment(procedureInfo);

            						 List<EgovMap> wor = paymentListMapper.selectProcessPaymentResult(procedureInfo);

            						 for (Object obj : wor) {
            							 Map<String, Object> map = (Map<String, Object>) obj;
        						         worList.add((String) map.get("orNo"));
        						         worAmt += Double.parseDouble(map.get("totAmt").toString());
            						 }

        		    				if(worList.size() == 0){
            	    					returnMsg += "</br> No WOR is generated. Please proceed to key-in at corresponding page manually.";

            	    					error.put("message", returnMsg);
            	    					error.put("reqId", params.get("reqNo").toString());
            	                        paymentListMapper.insertErrorRem(error);

            	    				}else{

            	    					returnMsg += "</br><b>WOR: </b>" + worList;
            	    					if(worAmt != Double.parseDouble(payInfo.get("newTotalAmt").toString())){
            	    						returnMsg += "</br> WOR amount is not generated as expected. Please contact FAR for further action.";
            	    						error.put("message", returnMsg);
            	        					error.put("reqId", params.get("reqNo").toString());
            	                            paymentListMapper.insertErrorRem(error);
            	    					}

            	    				}


            					}else{ // Cash, Cheque and Online

            						// refer to manual key in for cash, cheque and online process (insertTmpNormalPaymentInfo)
            						// Saving criteria follow Manual Key-In - CommonPaymentController - saveNormalPayment (105, 106, 108 Cash, Cheque, Online) - with Transaction ID
            			    		// Saving criteria follow Advance Key-In - AdvPaymentController - saveAdvPayment (105, 106, 108 Cash, Cheque, Online) - without Transaction ID
            						// INSERT DATA FROM PAY0344M TO PAY0240T (TRX_ID FIELD IN CASH, CHEQUE AND ONLINE IS OPTIONAL)
            					    if(payInfo.containsKey("trxId")){

            						    String bankStateId = payInfo.get("trxId").toString();

            						    double newAmt = Double.parseDouble(payInfo.get("newTotalAmt").toString());
            						    if("108".equals(String.valueOf(payInfo.get("newPayType")))){
               				    		     if(payInfo.get("bankChrgAmt") != null){
               				    		    	 newAmt = Double.parseDouble(payInfo.get("newTotalAmt").toString()) - Double.parseDouble(payInfo.get("bankChrgAmt").toString());
               				    		     }
            						    }
            						    payInfo.put("newAmt", newAmt);

            					    	paymentListMapper.insertTmpNormalPaymentInfo(payInfo);

            					    	if(newDcfInfo.size() > 0){
            								for(int i = 0 ; i < newDcfInfo.size(); i++){

            									dcf = newDcfInfo.get(i);
            									dcf.put("nextTmpSeq", nextTmpSeq);

            									//INSERT DATA FROM PAY0346D TO PAY0241T
            									paymentListMapper.insertTmpBillingInfo(dcf);

            									if("CARE_SRVC".equals(String.valueOf(dcf.get("appType")))){
            										dcf.put("userId", params.get("userId"));
            										dcf.put("ordId", dcf.get("salesOrdId").toString());
            										commonPaymentMapper.updateCareSalesMStatus(dcf);
            									}

            									procedureInfo.put("appType", dcf.get("appType"));
            								}
            							}

            					    	procedureInfo.put("reqNo", params.get("reqNo"));
            					    	procedureInfo.put("seq", nextTmpSeq);
            						    procedureInfo.put("userid", params.get("userId"));
            						    procedureInfo.put("key", bankStateId);
            						    procedureInfo.put("keyInPayRoute", payInfo.get("payRoute"));
            						    procedureInfo.put("keyInScrn", payInfo.get("keyInScrn"));

            						    paymentListMapper.processNormalPayment(procedureInfo);

            					    }else{

            					    	if("105".equals(String.valueOf(payInfo.get("newPayType"))) || "106".equals(String.valueOf(payInfo.get("newPayType")))){
            					    		paymentListMapper.insertTmpPaymentNoTrxIdInfo(payInfo);

            					    	}else if("108".equals(String.valueOf(payInfo.get("newPayType")))){

                						    double newAmt = Double.parseDouble(payInfo.get("newTotalAmt").toString());
              				    		     if(payInfo.get("bankChrgAmt") != null){
              				    		    	 newAmt = Double.parseDouble(payInfo.get("newTotalAmt").toString()) - Double.parseDouble(payInfo.get("bankChrgAmt").toString());
              				    		     }
              				    		     payInfo.put("newAmt", newAmt);

            					    		paymentListMapper.insertTmpPaymentOnlineInfo(payInfo);
            					    	}

            					    	if(newDcfInfo.size() > 0){
            								for(int i = 0 ; i < newDcfInfo.size(); i++){

            									dcf = newDcfInfo.get(i);
            									dcf.put("nextTmpSeq", nextTmpSeq);

            									//INSERT DATA FROM PAY0346D TO PAY0241T
            									paymentListMapper.insertTmpBillingInfo(dcf);
            								}
            							}

            					    	procedureInfo.put("reqNo", params.get("reqNo"));
            					    	procedureInfo.put("seq", nextTmpSeq);
            						    procedureInfo.put("userid", params.get("userId"));
            						    procedureInfo.put("keyInPayRoute", payInfo.get("payRoute"));
            						    procedureInfo.put("keyInScrn", payInfo.get("keyInScrn"));

            					    	//payment 처리 프로시저 호출
            						    paymentListMapper.processPayment(procedureInfo);
            					    }

            					    List<EgovMap> wor = paymentListMapper.selectProcessPaymentResult(procedureInfo);

            					    for (Object obj : wor) {
            					    	Map<String, Object> map = (Map<String, Object>) obj;
            					    	worList.add((String) map.get("orNo"));
            					    	worAmt += Double.parseDouble(map.get("totAmt").toString());
               						}

           		    				if(worList.size() == 0){
               	    					returnMsg += "</br> No WOR is generated. Please proceed to key-in at corresponding page manually.";
               	    					error.put("message", returnMsg);
               	    					error.put("reqId", params.get("reqNo").toString());
               	                        paymentListMapper.insertErrorRem(error);
               	    				}else{

               	    					returnMsg += "</br><b>WOR: </b>" + worList.toString();
               	    					if(worAmt != Double.parseDouble(payInfo.get("newTotalAmt").toString())){
               	    						returnMsg += "</br> WOR amount is not generated as expected. Please contact FAR for further action.";
               	    						error.put("message", returnMsg);
                   	     					error.put("reqId", params.get("reqNo").toString());
                   	                        paymentListMapper.insertErrorRem(error);
               	    					}

               	    				}
            					}
        					}

    					}else{
    						// ROR is not generate same amount of request DCF
    						returnMsg += "</br> ROR is not generated as expected. Please contact FAR for further action.";
    						error.put("message", returnMsg);
        					error.put("reqId", params.get("reqNo").toString());
                            paymentListMapper.insertErrorRem(error);
    					}
    				}
				}

				if(isApprove == true){
					//Update PAY0348D
			 		params.put("appvPrcssNo", data.get("appvPrcssNo").toString());
					params.put("appvStus", "A");
					params.put("appvResn", params.get("remark").toString());
					paymentListMapper.updateStatusNewDCFDet(params);

    				//Update final status in PAY0347M
    				params.put("dcfStusId", "A");
    		 		params.put("appvLinePrcssCnt", appvLinePrcssCnt);
    				paymentListMapper.updateStatusNewDCF(params);


    				//Send Notification to requestor
    				EgovMap reqNoti = new EgovMap();
    				reqNoti.put("code", "DCF");
    				reqNoti.put("codeName", "Data Change Request");
    				reqNoti.put("refundReqId", params.get("reqNo")); // key
    				reqNoti.put("appvStus", "R"); // keyStus
    				reqNoti.put("rejctResn", params.get("remark").toString()); // rem
    				reqNoti.put("reqstUserId", data.get("reqUserName")); // userNameNoti
    				reqNoti.put("userId", params.get("userId")); // userIdNoti
    				paymentListMapper.insertNotification(reqNoti);

				}else{
					//Update PAY0348D
			 		params.put("appvPrcssNo", data.get("appvPrcssNo").toString());
					params.put("appvStus", "J");
					params.put("rejctResn", returnMsg);
					params.put("appvResn", params.get("remark").toString());
					paymentListMapper.updateStatusNewDCFDet(params);

    				//Update final status in PAY0347M
    				params.put("dcfStusId", "J");
    		 		params.put("appvLinePrcssCnt", appvLinePrcssCnt);
    				paymentListMapper.updateStatusNewDCF(params);


    				//Send Notification to requestor
    				EgovMap reqNoti = new EgovMap();
    				reqNoti.put("code", "DCF");
    				reqNoti.put("codeName", "Data Change Request");
    				reqNoti.put("refundReqId", params.get("reqNo")); // key
    				reqNoti.put("appvStus", "J"); // keyStus
    				reqNoti.put("rejctResn", params.get("remark").toString()); // rem
    				reqNoti.put("reqstUserId", data.get("reqUserName")); // userNameNoti
    				reqNoti.put("userId", params.get("userId")); // userIdNoti
    				paymentListMapper.insertNotification(reqNoti);
				}

			}else{
				//Update PAY0348D
		 		params.put("appvPrcssNo", data.get("appvPrcssNo").toString());
				params.put("appvStus", "A");
				params.put("appvResn", params.get("remark").toString());
				paymentListMapper.updateStatusNewDCFDet(params);

				//Update final status in PAY0347M
				params.put("dcfStusId", "A");
		 		params.put("appvLinePrcssCnt", appvLinePrcssCnt);
				paymentListMapper.updateStatusNewDCF(params);

				// dcfCount > dcfMaxCount, use batch to generate ROR and WOR
				params.put("batchStus", 1);
				paymentListMapper.updateDcfBatchStatus(params);
				returnMsg = "ROR and WOR for this request will be generated by Job";
//
//				//Send Notification to requestor
//				EgovMap reqNoti = new EgovMap();
//				reqNoti.put("code", "DCF");
//				reqNoti.put("codeName", "Data Change Request");
//				reqNoti.put("refundReqId", params.get("reqNo")); // key
//				reqNoti.put("appvStus", "R"); // keyStus
//				reqNoti.put("rejctResn", params.get("remark").toString()); // rem
//				reqNoti.put("reqstUserId", data.get("reqUserName")); // userNameNoti
//				reqNoti.put("userId", data.get("reqUserId")); // userIdNoti
//				paymentListMapper.insertNotification(reqNoti);
			}

		}else{

			//Update PAY0347M
			params.put("dcfStusId", "P");
			params.put("appvLinePrcssCnt", appvLinePrcssCnt);
			paymentListMapper.updateStatusNewDCF(params);

			//Update PAY0348D
	 		params.put("appvPrcssNo", data.get("appvPrcssNo").toString());
			params.put("appvStus", "A");
			params.put("appvResn", params.get("remark").toString());
			paymentListMapper.updateStatusNewDCFDet(params);

			EgovMap dcfNoti = new EgovMap();
//	    	int nextNotiSeq = paymentListMapper.getNextNotiSeq();
	    	dcfNoti = paymentListMapper.selectDcfAppvInfo(params);

	    	//Update next approval info
	    	dcfNoti.put("appvStus", "R");
	    	dcfNoti.put("userMemCode", dcfNoti.get("memCode"));
			dcfNoti.put("appvLineSeq", appvLinePrcssCnt + 1); // seems like not using this part, please double check this
			paymentListMapper.updateStatusNewDCFDet(dcfNoti);

			//Send Notification
	    	EgovMap userIdNoti = paymentListMapper.getNtfUser(dcfNoti);

		 	dcfNoti.put("code", "DCF");
	    	dcfNoti.put("codeName", "Data Change Request");
	    	dcfNoti.put("refundReqId", params.get("reqNo")); // key
	    	dcfNoti.put("appvStus", "R"); // keyStus
	    	dcfNoti.put("rejctResn", dcfNoti.get("rem")); // rem
			dcfNoti.put("reqstUserId", userIdNoti.get("userName")); // userNameNoti
			dcfNoti.put("userId", params.get("userId")); // userIdNoti
			paymentListMapper.insertNotification(dcfNoti);

			returnMsg = "Approved Successfully </br> Notification has been set to next Approver.";
		}

		returnMap.put("message", returnMsg);
		return returnMap;
	}

	public void insertRequestDcfAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get("userId"));
		params.put("fileGroupKey", fileGroupKey);
	}

	@Override
	public EgovMap checkBankStateMapStus(Map<String, Object> params) {
		return paymentListMapper.checkBankStateMapStus(params);
	}
	/* [END] BOI DCF*/

	@Override
	public List<EgovMap> selectRefundCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return paymentListMapper.selectRefundCodeList(params);
	}

	@Override
	public List<EgovMap> selectBankListCode() {
		// TODO Auto-generated method stub
		return paymentListMapper.selectBankListCode();
	}
}
