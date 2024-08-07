package com.coway.trust.biz.sales.ownershipTransfer.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billinggroup.service.impl.BillingGroupMapper;
import com.coway.trust.biz.sales.ccp.impl.CcpCalculateMapper;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.sales.order.impl.OrderRequestMapper;
import com.coway.trust.biz.sales.ownershipTransfer.OwnershipTransferService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ownershipTransferService")
public class OwnershipTransferServiceImpl implements OwnershipTransferService {

	private static final Logger LOGGER = LoggerFactory.getLogger(OwnershipTransferServiceImpl.class);

	@Resource(name = "ownershipTransferMapper")
	private OwnershipTransferMapper ownershipTransferMapper;

	@Resource(name = "orderRegisterMapper")
	private OrderRegisterMapper orderRegisterMapper;

	@Resource(name = "orderRequestMapper")
	private OrderRequestMapper orderRequestMapper;

	@Resource(name = "billingGroupMapper")
	private BillingGroupMapper billingGroupMapper;

	@Resource(name = "ccpCalculateMapper")
	private CcpCalculateMapper ccpCalculateMapper;

	@Override
	public List<EgovMap> selectStatusCode() {
		return ownershipTransferMapper.selectStatusCode();
	}

	@Override
	public List<EgovMap> selectRootList(Map<String, Object> params) throws Exception {
		return ownershipTransferMapper.selectRootList(params);
	}

	@Override
	public List<EgovMap> rootCodeList(Map<String, Object> params) {
		return ownershipTransferMapper.rootCodeList(params);
	}

	@Override
	public int saveRequest(Map<String, Object> params, SessionVO sessionVO) {
		LOGGER.debug("OwnershipTransferServiceImpl :: saveRequest");
		LOGGER.info("params : {}", params);

		// Obtain ROT sequence number
		int rotID = ownershipTransferMapper.getRootID();
		params.put("rotID", rotID);

		int flg = rotID;

		EgovMap rotDocNoMap = ownershipTransferMapper.selectDocNo();
		String rotDocNo = "";

		rotDocNo = rotDocNoMap.get("c2").toString() + rotDocNoMap.get("c1").toString();
		LOGGER.debug("rotDocNo :: " + rotDocNo);

		// Get Order Info
		EgovMap ordDetailsM = orderRegisterMapper.selectSalesOrderM(params);
		EgovMap ordDetailsD = orderRequestMapper.selectSalesOrderD(params);

		// Processing insert fields - Start
		// ***************************************************************************************************
		// Master table data preparation - Start
		int mCnt = 0;
		Map<String, Object> mParam = new HashMap<String, Object>();
		mParam.put("rotID", rotID);
		mParam.put("rotDocNo", rotDocNo);
		mParam.put("rotOrdID", (String) params.get("salesOrdId"));
		mParam.put("rotOrdNo", (String) params.get("salesOrdNo"));
		mParam.put("rotStus", "1");
		mParam.put("userID", sessionVO.getUserId());
		// Master table data preparation - End

		// Insert Master Table
		mCnt = ownershipTransferMapper.insertSAL0275M(mParam);
		// ***************************************************************************************************

		// ***************************************************************************************************
		// Detail table data preparation - Start
		// SAL0276D Data
		// To migrate to SAL0004D upon approve Ownership Transfer
		int dCnt = 0;
		Map<String, Object> dParam = new HashMap<String, Object>();
		dParam.put("rotID", rotID);
		dParam.put("rotDocNo", rotDocNo);
		dParam.put("rotOrdID", params.get("salesOrdId"));
		dParam.put("rotOrdNo", params.get("salesOrdNo"));
		// ************************************************************
		// SAL0004D insert values on approve
		dParam.put("rotRsn", params.get("rotReason"));
		dParam.put("rotReqAS", params.get("rotReqAS"));
		dParam.put("rotReqRebill", params.get("rotReqRebill"));
		dParam.put("rotReqInvcGrp", params.get("rotReqInvoiceGrp"));
		dParam.put("rotAppType", CommonUtils.intNvl(ordDetailsM.get("appTypeId")));
		dParam.put("rotStkID", CommonUtils.intNvl(ordDetailsD.get("itmStkId")));
		dParam.put("rotPrcID", CommonUtils.intNvl(ordDetailsD.get("itmPrcId")));
		dParam.put("rotPV", CommonUtils.isNotEmpty(ordDetailsM.get("totPv")) ? (BigDecimal) ordDetailsM.get("totPv")
				: BigDecimal.ZERO);
		dParam.put("rotAmt", CommonUtils.isNotEmpty(ordDetailsM.get("totAmt")) ? (BigDecimal) ordDetailsM.get("totAmt")
				: BigDecimal.ZERO);
		dParam.put("rotPromoID", CommonUtils.intNvl(ordDetailsD.get("promoId")));
		dParam.put("rotDefRentAmt", CommonUtils.isNotEmpty(ordDetailsM.get("defRentAmt"))
				? (BigDecimal) ordDetailsM.get("defRentAmt") : BigDecimal.ZERO);
		dParam.put("rotRem", "");
		dParam.put("userID", sessionVO.getUserId());
		dParam.put("rotOldCustID", params.get("hiddenCurrentCustID"));
		dParam.put("rotAtchGrpId", params.get("atchFileGrpId"));
		// ************************************************************
		// SAL0001D update value on approved
		dParam.put("rotNewCustID", params.get("txtHiddenCustID")); // SAL0004D insert
		dParam.put("rotCntID", CommonUtils.intNvl(params.get("txtHiddenContactID")));
		dParam.put("rotAddID", CommonUtils.intNvl(params.get("txtHiddenAddressID")));

		if (CommonUtils.intNvl(params.get("hiddenAppTypeID")) == SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
			// Check Existing/New billing group option
			String indicator = "";
			if (params.get("btnBillGroup") != null) {
				indicator = params.get("btnBillGroup").toString();
			} else {
				indicator = params.get("grpOpt").toString();
			}

			if ("new".equals(indicator)) {
				dParam.put("rotBillID", "0");
			} else {
				// Existing Rental Billing Group
				dParam.put("rotBillID", CommonUtils.intNvl(params.get("txtHiddenBillGroupID")));
			}
		} else {
			dParam.put("rotBillID", "0");
		}
		// Detail table data preparation - End
		dParam.put("requestorCode", (String) params.get("Request_requestorInfo"));
		dParam.put("rotReqBrnchID", (String) params.get("Request_rotReqBrnch"));
		// Insert Detail Table
		dCnt = ownershipTransferMapper.insertSAL0276D(dParam);
		// ***************************************************************************************************

		// ***************************************************************************************************
		// ROT RentPaySet data preparation - Start
		int rpsID = 0;
		int rpsCnt = 0;
		Map<String, Object> rpsParam = new HashMap<String, Object>();
		if (SalesConstants.APP_TYPE_CODE_ID_RENTAL == CommonUtils.intNvl(ordDetailsM.get("appTypeId"))) {
			rpsID = ownershipTransferMapper.getRentPaySetID(params);
			int paymode = CommonUtils.intNvl(params.get("cmbRentPaymode"));

			String isThirdParty = "";
			if (params.containsKey("btnThirdParty")) {
				isThirdParty = params.get("btnThirdParty").toString();
			}

			rpsParam.put("rotID", rotID);
			rpsParam.put("rentPayId", rpsID);
			rpsParam.put("rotOrdID", params.get("salesOrdId"));
			rpsParam.put("modeId", paymode);
			rpsParam.put("custCrcId", paymode == 131 ? CommonUtils.intNvl(params.get("txtHiddenRentPayCRCID")) : 0);
			rpsParam.put("custAccId", paymode == 132 ? CommonUtils.intNvl(params.get("txtHiddenRentPayBankAccID")) : 0);
			rpsParam.put("bankId", paymode == 131 ? CommonUtils.intNvl(params.get("hiddenRentPayCRCBankID"))
					: paymode == 132 ? CommonUtils.intNvl(params.get("hiddenRentPayBankAccBankID")) : 0);
			rpsParam.put("ddDates", SalesConstants.DEFAULT_DATE);
			rpsParam.put("stusCodeId", SalesConstants.STATUS_ACTIVE);
			rpsParam.put("is3rdParty", "Y".equals(isThirdParty) ? SalesConstants.IS_TRUE : SalesConstants.IS_FALSE);
			rpsParam.put("custId", "Y".equals(isThirdParty) ? CommonUtils.intNvl(params.get("txtHiddenThirdPartyID"))
					: CommonUtils.intNvl(params.get("txtHiddenCustID")));
			rpsParam.put("editTypeId", "0");
			rpsParam.put("nricOld", params.get("txtRentPayIC"));
			rpsParam.put("failResnId", "0");
			rpsParam.put("issuNric",
					CommonUtils.isNotEmpty(params.get("txtRentPayIC").toString().trim()) ? params.get("txtRentPayIC")
							: "Y".equals(isThirdParty) ? params.get("txtThirdPartyNRIC") : params.get("txtCustIC"));
			rpsParam.put("aeonCnvr", SalesConstants.IS_FALSE);
			rpsParam.put("rem", "");
			rpsParam.put("userID", sessionVO.getUserId());
			rpsParam.put("payTrm", "0");
			rpsParam.put("svcCntrctId", "0");
			rpsParam.put("gracePeriod", "0");
			rpsParam.put("deductAccId", "0");

			// Insert ROT RentPaySet SAL0279D
			rpsCnt = ownershipTransferMapper.insertSAL0279D(rpsParam);
		}
		// ROT RentPaySet data preparation - End
		// ***************************************************************************************************

		// ***************************************************************************************************
		// ROT CCP Data Preparation - Start
		int ccpStatusId = 1;
		int ccpCnt = 0;
		String ccpRemark = "";

		int rotCcpId = ownershipTransferMapper.getRotCcpId();
		Map<String, Object> ccpParam = new HashMap<String, Object>();

		if (CommonUtils.intNvl(params.get("nationNmOwnt")) == 14
				&& CommonUtils.intNvl(params.get("hiddenCustTypeID")) == SalesConstants.CUST_TYPE_CODE_ID_IND) {
			ccpStatusId = 5;
			ccpRemark = "CCP Korean Bypass.";
		}

		ccpParam.put("rotID", rotID);
		ccpParam.put("ccpId", rotCcpId);
		ccpParam.put("ccpSalesOrdId", params.get("salesOrdId"));
		ccpParam.put("ccpSchemeTypeId",
				CommonUtils.intNvl(params.get("hiddenCustTypeID")) == SalesConstants.CUST_TYPE_CODE_ID_IND
						? SalesConstants.CCP_SCHEME_TYPE_CODE_ID_ICS : SalesConstants.CCP_SCHEME_TYPE_CODE_ID_CCS);
		ccpParam.put("ccpTypeId", "972");
		ccpParam.put("ccpIncomeRangeId", "0");
		ccpParam.put("cppTotScrePoint", BigDecimal.ZERO);
		ccpParam.put("ccpStusId", ccpStatusId);
		ccpParam.put("ccpResnId", "0");
		ccpParam.put("ccpRem", ccpRemark);
		ccpParam.put("ccpRjStusId", "0");
		ccpParam.put("userID", sessionVO.getUserId());
		ccpParam.put("ccpIsLou", SalesConstants.IS_FALSE);
		ccpParam.put("ccpIsSaman", SalesConstants.IS_FALSE);
		ccpParam.put("ccpIsSync", SalesConstants.IS_FALSE);
		ccpParam.put("ccpPncRem", "");
		ccpParam.put("ccpHasGrnt", SalesConstants.IS_FALSE);
		ccpParam.put("ccpIsHold", SalesConstants.IS_FALSE);
		ccpParam.put("ccpAgmReq", SalesConstants.IS_FALSE);
		ccpParam.put("ccpTemplate", SalesConstants.IS_FALSE);
		ccpCnt = ownershipTransferMapper.insertSAL0277D(ccpParam);
		// ROT CCP Data Preparation - End
		// ***************************************************************************************************

		// ***************************************************************************************************
		// ROT Installation staging data preparation - Start
		int instCnt = 0;
		int instId = ownershipTransferMapper.getInstID(params);
		String preInstDate = params.get("dpPreferInstDate").toString();

		Map<String, Object> instParam = new HashMap<String, Object>();
		instParam.put("rotID", rotID);
		instParam.put("installID", instId);
		instParam.put("salesOrdId", params.get("salesOrdId"));
		instParam.put("addId", CommonUtils.intNvl(params.get("txtHiddenInstAddressID")));
		instParam.put("cntId", CommonUtils.intNvl(params.get("txtHiddenInstContactID")));
		try {
			instParam.put("preCalLDt", CommonUtils.getAddDay(preInstDate, -1, SalesConstants.DEFAULT_DATE_FORMAT1));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		instParam.put("preDt", preInstDate);
		instParam.put("preTm", this.convert24Tm((String) params.get("tpPreferInstTime")));
		instParam.put("instct", params.get("txtInstSpecialInstruction"));
		instParam.put("brnchId", CommonUtils.intNvl(params.get("cmbDSCBranch").toString()));
		instParam.put("userID", sessionVO.getUserId());

		// Insert ROT Installation
		instCnt = ownershipTransferMapper.insertSAL0282D(instParam);
		// ROT Installation staging data preparation - End
		// ***************************************************************************************************

		// ***************************************************************************************************
		// ROT Rental Bill Grouping staging data preparation - Start
		int custBillCnt_New = 0;
		int custBillCnt_Upd = 0;
		int custBillCnt_Ex = 0;

		Map<String, Object> billParam = new HashMap<String, Object>();
		if ("new".equals(params.get("grpOpt").toString())) {
			billParam.put("rotID", rotID);
			// billParam.put("custBillId", custBillId);
			billParam.put("custBillSoId", params.get("salesOrdId"));
			billParam.put("custBillCustId", params.get("txtHiddenCustID"));
			billParam.put("custBillCntId", params.get("txtHiddenContactID"));
			billParam.put("custBillAddId", params.get("txtHiddenAddressID"));
			billParam.put("custBillStusId", SalesConstants.STATUS_ACTIVE);
			billParam.put("custBillRem", params.get("txtBillGroupRemark").toString());
			// billParam.put("custBillGrpNo", "");
			billParam.put("userID", sessionVO.getUserId());
			billParam.put("custBillPayTrm", "0");
			billParam.put("custBillInchgMemId", "0");
			/*
			 * billParam.put("custBillEmail", ""); billParam.put("custBillIsEstm", SalesConstants.IS_FALSE);
			 * billParam.put("custBillIsSms", CommonUtils.intNvl(params.get("hiddenCustTypeID")) ==
			 * SalesConstants.CUST_TYPE_CODE_ID_IND ? SalesConstants.IS_TRUE : SalesConstants.IS_FALSE);
			 * billParam.put("custBillIsPost", CommonUtils.intNvl(params.get("hiddenCustTypeID")) ==
			 * SalesConstants.CUST_TYPE_CODE_ID_IND ? SalesConstants.IS_TRUE : SalesConstants.IS_FALSE);
			 */
			billParam.put("custBillIsEstm", CommonUtils.intNvl(params.get("hiddenBillMthdEstm")) == 1 ? 1 : 0);
			billParam.put("custBillIsSms", CommonUtils.intNvl(params.get("hiddenBillMthdSms1")) == 1 ? 1 : 0);
			billParam.put("custBillIsSms2", CommonUtils.intNvl(params.get("hiddenBillMthdSms2")) == 1 ? 1 : 0);
			billParam.put("custBillIsPost", CommonUtils.intNvl(params.get("hiddenBillMthdPost")) == 1 ? 1 : 0);
			billParam.put("custBillIsWebPortal", CommonUtils.intNvl(params.get("hiddenBillGrpWeb")) == 1 ? 1 : 0);

			billParam.put("custBillEmail", params.get("billMthdEmailTxt1"));
			billParam.put("custBillEmailAdd", params.get("billMthdEmailTxt2"));
			billParam.put("custBillWebPortalUrl", params.get("billGrpWebUrl"));

		}

		// Insert into rental group billing staging if new billing group
		String billGroupDocNo = "";
		if (!billParam.isEmpty() && CommonUtils.intNvl(billParam.get("custBillSoId")) > 0) {
			// Get Billing Group ID
			int custBillId = ownershipTransferMapper.getCustBillID();
			billParam.put("custBillId", custBillId);

			// Get Billing Group Number
			billGroupDocNo = orderRegisterMapper.selectDocNo(DocTypeConstants.BILLGROUP_NO);
			billParam.put("custBillGrpNo", billGroupDocNo);
			billParam.put("ind", "_new");

			// custBillCnt = ownershipTransferMapper.insertSAL0280D(billParam);
			custBillCnt_New = ownershipTransferMapper.insertSAL0280D_new(billParam);

			// set custBillID to ordDetailsD (?)
			dParam.put("rotBillID", custBillId);
			// Update into ROT Master Detail table ROT_BILL_ID column
			custBillCnt_Upd = ownershipTransferMapper.updateSAL0276D_CustBill(dParam);
		}

		int curCustBillId = CommonUtils.intNvl(ordDetailsM.get("custBillId"));
		params.put("custBillId", curCustBillId);
		EgovMap billMap = billingGroupMapper.selectCustBillMaster(params);

		if (billMap != null) {
			if (CommonUtils.intNvl(billMap.get("custBillSoId")) == CommonUtils.intNvl(ordDetailsM.get("salesOrdId"))) {
				// Is main order in old group
				params.put("custBillId", CommonUtils.intNvl(billMap.get("custBillId")));
				params.put("custId", CommonUtils.intNvl(billMap.get("custBillCustId")));
				params.put("stusCodeId", 4);

				EgovMap ordDetailsM2 = orderRequestMapper.selectSalesOrderMOtran(params);

				Map<String, Object> tempParam = new HashMap<String, Object>();
				tempParam.put("rotID", rotID);
				if (ordDetailsM2 != null) {
					tempParam.put("custBillId", CommonUtils.intNvl(billMap.get("custBillId")));
					tempParam.put("custBillSoId", CommonUtils.intNvl(ordDetailsM2.get("salesOrdId")));
					tempParam.put("userId", sessionVO.getUserId());
					tempParam.put("ind", "4_ex");

					// Insert into SAL0280D current "CUST_BILL_ID" data from SAL0024D into SAL0280D with ROT_ID and
					// updated "CUST_BILL_SO_ID"
					// Data will be merge into SAL0024D on approval (Merge into; match update; unmatch insert)
					custBillCnt_Ex = ownershipTransferMapper.insertSAL0280D_ex(tempParam);
				} else {
					params.put("stusCodeId", 1);

					EgovMap ordDetailsM3 = orderRequestMapper.selectSalesOrderMOtran(params);

					if (ordDetailsM3 != null) {
						tempParam.put("custBillId", CommonUtils.intNvl(billMap.get("custBillId")));
						tempParam.put("custBillSoId", CommonUtils.intNvl(ordDetailsM3.get("salesOrdId")));
						tempParam.put("userId", sessionVO.getUserId());
						tempParam.put("ind", "1_ex");

						// Insert into SAL0280D current "CUST_BILL_ID" data from SAL0024D into SAL0280D with ROT_ID and
						// updated "CUST_BILL_SO_ID"
						// Data will be merge into SAL0024D on approval (Merge into; match update; unmatch insert)
						custBillCnt_Ex = ownershipTransferMapper.insertSAL0280D_ex(tempParam);
					}
				}
			}
		}
		// ROT Rental Bill Grouping staging data preparation - End
		// ***************************************************************************************************
		// Processing insert fields - End

		// Update ROT Doc No sequence
		int nextDocNo = Integer.parseInt(rotDocNoMap.get("c1").toString()) + 1;
		LOGGER.debug("nextDocNo :: " + Integer.toString(nextDocNo));

		params.put("nextDocNo", nextDocNo);
		int docNoCnt = ownershipTransferMapper.updateDocNo(params);

		LOGGER.debug("mCnt :: " + mCnt);
		LOGGER.debug("dCnt :: " + dCnt);
		LOGGER.debug("rpsCnt :: " + rpsCnt);
		LOGGER.debug("instCnt :: " + instCnt);
		LOGGER.debug("custBillCnt_New :: " + custBillCnt_New);
		LOGGER.debug("custBillCnt_Upd :: " + custBillCnt_Upd);
		LOGGER.debug("custBillCnt_Ex :: " + custBillCnt_Ex);
		LOGGER.debug("docNoCnt :: " + docNoCnt);

//		if (mCnt != 0 && dCnt != 0 && ccpCnt != 0 && instCnt != 0) {
//			// If Order Type = Rental and rpsCnt != 0 [Success]
//			if (SalesConstants.APP_TYPE_CODE_ID_RENTAL == CommonUtils.intNvl(ordDetailsM.get("appTypeId"))
//					&& rpsCnt != 0) {
//
//				// If rental billing group = new, insert SAL0280D > 0, update SAL0276D > 0
//				if ("new".equals(params.get("grpOpt").toString()) && (custBillCnt_New == 0 || custBillCnt_Upd == 0)) {
//					flg = 0;
//				}
//
//				if (billMap != null && custBillCnt_Ex == 0) {
//					flg = 0;
//				}
//			} else {
//				flg = 0;
//			}
//
//			// Else if Master Staging, Detail Master Staging, Installation Staging is empty
//		} else if (mCnt == 0 || dCnt == 0 || ccpCnt == 0 || instCnt == 0) {
//			flg = 0;
//		}

		return flg;
	}

	private String convert24Tm(String tm) {
		String ampm = "", HH = "", MI = "", cvtTM = "";

		if (CommonUtils.isNotEmpty(tm)) {
			ampm = CommonUtils.right(tm, 2);
			HH = CommonUtils.left(tm, 2);
			MI = tm.substring(3, 5);

			if ("PM".equals(ampm)) {
				cvtTM = String.valueOf(Integer.parseInt(HH) + 12) + ":" + MI + ":00";
			} else {
				cvtTM = HH + ":" + MI + ":00";
			}
		}
		return cvtTM;
	}

	@Override
	public List<EgovMap> getSalesOrdId(String params) {
		return ownershipTransferMapper.getSalesOrdId(params);
	}

	@Override
	public Map<String, Object> selectLoadIncomeRange(Map<String, Object> params) throws Exception {

		Map<String, Object> incMap = new HashMap<String, Object>();

		EgovMap ccpInfoMap = null;
		params.put("groupCode", params.get("ccpId"));
		ccpInfoMap = ownershipTransferMapper.getCcpByCcpId(params);

		if (ccpInfoMap == null) {
			incMap.put("rentPayModeId", "0");
			incMap.put("applicantTypeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); // individual
		} else {
			incMap.put("rentPayModeId", ccpInfoMap.get("modeId"));

			BigDecimal schemeTypeId = (BigDecimal) ccpInfoMap.get("ccpSchemeTypeId");

			if (schemeTypeId.intValue() == 1) {
				incMap.put("applicantTypeId", SalesConstants.APPLICANT_TYPE_ID_COMPANY); // company
			} else {
				incMap.put("applicantTypeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); // individual
			}
		}

		return incMap;
	}

	@Override
	public EgovMap selectCcpInfoByCcpId(Map<String, Object> params) throws Exception {

		return ownershipTransferMapper.selectCcpInfoByCcpId(params);
	}

	@Override
	public EgovMap selectRootDetails(Map<String, Object> params) {
		return ownershipTransferMapper.selectRootDetails(params);
	}

	@Override
	public List<EgovMap> selectRotCallLog(Map<String, Object> params) throws Exception {
		return ownershipTransferMapper.selectRotCallLog(params);
	}

	@Override
	public List<EgovMap> selectRotHistory(Map<String, Object> params) throws Exception {
		return ownershipTransferMapper.selectRotHistory(params);
	}

	@Override
	public int insCallLog(List<Object> addList, String userId) {
		int cnt = 0, cnt2=0;

		try{
    			for (Object obj : addList) {
        				((Map<String, Object>) obj).put("userId", userId);
        				cnt = ownershipTransferMapper.insCallLog((Map<String, Object>) obj);

        				EgovMap checkRootGrpId = ownershipTransferMapper.checkRootGrpId((Map<String, Object>) obj);

        				if(checkRootGrpId!=null){
        					((Map<String, Object>) obj).put("rotID",  checkRootGrpId.get("rotId").toString());
        					cnt2 = ownershipTransferMapper.insCallLog((Map<String, Object>) obj);

        					 if(cnt2<0){
        						 throw new Error("Error");
        	    			 }
        				}

        				if(cnt <0){
        					 throw new Error("Error");
           			    }
    			}
		}
		catch(Exception e){
			throw e;
		}

		return cnt;
	}

	@Override
	public List<EgovMap> getAttachments(Map<String, Object> params) {
		return ownershipTransferMapper.getAttachments(params);
	}

	@Override
	public EgovMap getAttachmentInfo(Map<String, Object> params) {
		return ownershipTransferMapper.getAttachmentInfo(params);
	}

	@Override
	public int saveRotCCP(Map<String, Object> params, SessionVO sessionVO) {
		LOGGER.debug("OwnershipTransferServiceImpl :: saveRotCCP");
		LOGGER.info("params : {}", params);

		params.put("rotId", params.get("ccpRotId"));
		params.put("saveCcpId", params.get("editCcpId"));
		params.put("userId", sessionVO.getUserId());
		params.put("userFullName", sessionVO.getUserFullname());
		params.put("userBranchId", sessionVO.getUserBranchId());

		/* ### Reject Status Params Setting #### */
		if (params.get("rejectStatusEdit") != null) {
			if (params.get("rejectStatusEdit").equals("12")) {
				params.put("statusEdit", "1");
				params.put("rejectStatusEdit", "0");
				params.put("updateCCPIssynch", "0");

			} else {
				if (null == params.get("statusEdit") || ("").equals(params.get("statusEdit"))) {
					params.put("statusEdit", "0");
				}

				if (null == params.get("rejectStatusEdit") || ("").equals(params.get("rejectStatusEdit"))) {
					params.put("rejectStatusEdit", "0");
				}
				params.put("updateCCPIssynch", "0");
			}
		}

		/* #### Total Score Point #### */
		if (null == params.get("ccpTotalScorePoint") || ("").equals(params.get("ccpTotalScorePoint"))) {
			params.put("ccpTotalScorePoint", "0");
		}

		/* #### Reason Code #### */
		if (null == params.get("reasonCodeEdit") || ("").equals(params.get("reasonCodeEdit"))) {
			params.put("reasonCodeEdit", "0");
		}

		/* #### Special Remark #### */
		if (null == params.get("spcialRem") || ("").equals(params.get("spcialRem"))) {
			params.put("spcialRem", "");
		}

		/* #### PNC Rem #### */
		if (null == params.get("pncRem") || ("").equals(params.get("pncRem"))) {
			params.put("pncRem", "");
		}

		/* #### Fico Score #### */
		if (null == params.get("ficoScore") || ("").equals(params.get("ficoScore"))) {
			params.put("ficoScore", "0");
		}

		params.put("hasGrnt", "0");



		// Call CcpCalculateServiceImpl.calSave()
		int cnt = 0;
		try {
			cnt = this.calSave(params);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return cnt;
	}

	@Transactional
	/*
	 * Function copied from CcpCalculateServiceImpl.calSave Function amended to cater ROT flow
	 */
	public int calSave(Map<String, Object> params) throws Exception {
		LOGGER.debug("OwnershipTransferServiceImpl :: calSave");
		LOGGER.info("params : {}", params);

		List<EgovMap> ccpDesList = null;
		EgovMap desMap = null;
		EgovMap cancelMap = null;
		EgovMap itmMap = null;
		EgovMap accMap = null;

		double totalOutstanding = 0;
		BigDecimal tempoVal = null;

		String logseq = "";
		String InsSeq = "";
		String resultSeq = "";
		String callSeq = "";

		int cnt = 0;

		// save rot reason after validation into sal0276D
//		ownershipTransferMapper.updateSAL0276D_rotReason(params);


		// 1. Update ROT CCP Decision :: SAL0277D
		LOGGER.info("==========================================");
		LOGGER.info("1. Update ROT CCP Decision Master :: Start");
		LOGGER.info("==========================================");

		// Tranlate :: saveCustTypeId = 969 / 970
		// Individual :: 964
		if (SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL.equals(String.valueOf(params.get("saveCustTypeId")))) {
			params.put("saveCustTypeId", SalesConstants.CCP_SCHEME_TYPE_CODE_ID_ICS);
		} else {
			params.put("saveCustTypeId", SalesConstants.CCP_SCHEME_TYPE_CODE_ID_CCS);
		}

		LOGGER.info("1. Update SAL0277D");
		ownershipTransferMapper.updateCcpDecision(params);

		LOGGER.info("========================================");
		LOGGER.info("1. Update ROT CCP Decision Master :: End");
		LOGGER.info("========================================");

		ccpDesList = ownershipTransferMapper.getCcpDecisionList(params);

		LOGGER.info("==========================================");
		LOGGER.info("2. Update ROT CCP Decision Detail :: Start");
		LOGGER.info("==========================================");
		if (ccpDesList != null && ccpDesList.size() > 0) {
			for (int idx = 0; idx < ccpDesList.size(); idx++) {
				desMap = ccpDesList.get(idx);
				if (!(SalesConstants.CCP_ITM_STUS_UPD).equals(desMap.get("ccpItmStusId"))) {
					// CCP_ITM_STUS_UPD = 8
					desMap.put("ccpItmStusId", SalesConstants.CCP_ITM_STUS_UPD);
					LOGGER.info("2. Update SAL0283D");
					cnt = ownershipTransferMapper.updateCcpDecisionStatus(desMap);
				}
			}
		}
		LOGGER.info("========================================");
		LOGGER.info("2. Update ROT CCP Decision Detail :: End");
		LOGGER.info("========================================");

		LOGGER.info("==========================================");
		LOGGER.info("3. Insert ROT CCP Decision Detail :: Start");
		LOGGER.info("==========================================");
		// CCP_ITM_STUS_INS = 1
		params.put("insCcpItmStusId", SalesConstants.CCP_ITM_STUS_INS); // 1

		// ORD
		if (null != params.get("saveOrdUnit") && null != params.get("saveOrdCount")
				&& null != params.get("saveOrdPoint")) {
			params.put("insCcpScreEventId", params.get("saveOrdUnit"));
			params.put("insCcpItmScreUnit", params.get("saveOrdCount"));
			params.put("insCcpItmPointScre", params.get("saveOrdPoint"));

			LOGGER.info("3.1. Insert SAL0283D :: ORD");
			ownershipTransferMapper.insertCcpDecision(params);
		}

		// ROS
		if (null != params.get("saveRosUnit") && null != params.get("saveRosCount")
				&& null != params.get("saveRosPoint")) {
			params.put("insCcpScreEventId", params.get("saveRosUnit"));
			params.put("insCcpItmScreUnit", params.get("saveRosCount"));
			params.put("insCcpItmPointScre", params.get("saveRosPoint"));

			LOGGER.info("3.2. Insert SAL0283D :: ROS");
			ownershipTransferMapper.insertCcpDecision(params);
		}

		// SUS
		if (null != params.get("saveSusUnit") && null != params.get("saveSusCount")
				&& null != params.get("saveSusPoint")) {
			params.put("insCcpScreEventId", params.get("saveSusUnit"));
			params.put("insCcpItmScreUnit", params.get("saveSusCount"));
			params.put("insCcpItmPointScre", params.get("saveSusPoint"));

			LOGGER.info("3.3. Insert SAL0283D :: SUS");
			ownershipTransferMapper.insertCcpDecision(params);
		}

		// CUST
		if (null != params.get("saveCustUnit") && null != params.get("saveCustCount")
				&& null != params.get("saveCustPoint")) {
			params.put("insCcpScreEventId", params.get("saveCustUnit"));
			params.put("insCcpItmScreUnit", params.get("saveCustCount"));
			params.put("insCcpItmPointScre", params.get("saveCustPoint"));

			LOGGER.info("3.4. Insert SAL0283D :: CUST");
			ownershipTransferMapper.insertCcpDecision(params);
		}

		LOGGER.info("========================================");
		LOGGER.info("3. Insert ROT CCP Decision Detail :: End");
		LOGGER.info("========================================");

		// ROT CCP Reject
		if (("10").equals(params.get("rejectStatusEdit")) || ("17").equals(params.get("rejectStatusEdit"))
				|| ("18").equals(params.get("rejectStatusEdit"))) {
			LOGGER.info("====================================");
			LOGGER.info("4. ROT CCP Status :: Reject :: Start");
			LOGGER.info("====================================");

			params.put("rotStus", "6");

			LOGGER.info("4. Update SAL0277D status :: Reject");
			ownershipTransferMapper.updateSAL0277D_stus(params);

			LOGGER.info("====================================");
			LOGGER.info("4. ROT CCP Status :: Reject :: End");
			LOGGER.info("====================================");
		}

		// ROT CCP Approve
		if (("5").equals(params.get("statusEdit")) || ("13").equals(params.get("statusEdit"))
				|| ("14").equals(params.get("statusEdit"))) {
			LOGGER.info("=====================================");
			LOGGER.info("4. ROT CCP Status :: Approve :: Start");
			LOGGER.info("=====================================");

			/*
			 * On Approval :: 1. Update ROT CCP Status to approved 2. Insert into SAL0004D (Sales exchange log table) 3.
			 * Merge SAL0074D (RentPaySet table) 4. Insert into SAL0024D (Rental Billing Group table) [If new billing
			 * group will insert one record; Existing - to test] 5. Update SAL0001D (Sales Master table) 6. Get Rental
			 * Billing Group staging details (For re-updating purpose of "existing order" of "previous"/"existing"
			 * billing group) 7. Merge SAL0045D (Installation table) 8. Check eCash, auxiliary, paymode for call entry
			 * and progress insertion
			 */
			params.put("rotStus", "5");

			LOGGER.info("4. Update SAL0277D status :: Approve");
			// 1.
			ownershipTransferMapper.updateSAL0277D_stus(params);
			// 2.
			ownershipTransferMapper.insertSAL0004D_ROT(params);
			// 3.
			ownershipTransferMapper.mergeSAL0074D_ROT(params);
			// 4.
			ownershipTransferMapper.insertSAL0024D_ROT(params);

			// Updates sales order to new billing group
			// 5.
			ownershipTransferMapper.updateSAL0001D_ROT(params);

			// 6.
			// Get on request Billing ID + Sales Order ID tied to Billing group
			EgovMap exCustBillId = ownershipTransferMapper.getExistCustBill_SAL0280D(params);
			params.put("exCustBillId", exCustBillId == null ? 0 : exCustBillId.get("custBillId"));


			Map<String, Object> tempParam = new HashMap<String, Object>();
			Map<String, Object> billParam = new HashMap<String, Object>();
			billParam.put("custBillId", exCustBillId == null ? 0 : exCustBillId.get("custBillId"));

			// Select from SAL0024D based on request billing group ID
			EgovMap billMap = billingGroupMapper.selectCustBillMaster(billParam);

			if (billMap != null) {
				if (CommonUtils.intNvl(billMap.get("custBillSoId")) == CommonUtils
						.intNvl(exCustBillId.get("rotOrdId"))) {
					tempParam.put("custBillId", CommonUtils.intNvl(billMap.get("custBillId")));
					tempParam.put("custId", CommonUtils.intNvl(billMap.get("custBillCustId")));
					tempParam.put("stusCodeId", "4");

					// Query Sales Order master :: Status = Complete
					EgovMap ordDetail = orderRequestMapper.selectSalesOrderMOtran(tempParam);

					Map<String, Object> tempParam1 = new HashMap<String, Object>();
					tempParam1.put("rotID", params.get("rotId"));
					tempParam1.put("custBillUpdUserId", exCustBillId.get("custBillUpdUserId")); // CUST_BILL_UPD_USER_ID
					tempParam1.put("custBillId", billMap.get("custBillId"));
					if (ordDetail != null) {
						tempParam1.put("custBillSoId", billMap.get(ordDetail.get("salesOrdId")));

						// Updates Staging's Ex Billing Group ID's Sales Order ID
						ownershipTransferMapper.updateSAL0280D_ex(tempParam1);
						ownershipTransferMapper.updateSAL0024D_ROT(tempParam1);
					} else {
						tempParam.put("stusCodeId", "1");

						EgovMap ordDetail2 = orderRequestMapper.selectSalesOrderMOtran(tempParam);

						if (ordDetail2 != null) {
							tempParam1.put("custBillSoId", billMap.get(ordDetail2.get("salesOrdId")));

							// Updates Staging's Ex Billing Group ID's Sales Order ID
							ownershipTransferMapper.updateSAL0280D_ex(tempParam1);
							ownershipTransferMapper.updateSAL0024D_ROT(tempParam1);
						} else {
							tempParam1.put("custBillSoId", "");

							// Updates Staging's Ex Billing Group ID's Sales Order ID
							ownershipTransferMapper.updateSAL0280D_ex(tempParam1);
							ownershipTransferMapper.updateSAL0024D_ROT(tempParam1);
						}
					}
				}
			}

			// 7.
			ownershipTransferMapper.mergeSAL0045D_ROT(params);

			// From CCP Calculation on approve CCP - Start
			// 8.
			EgovMap eCashMap = null;
			// ECASH = 0 :: MODE_ID != 131
			eCashMap = ccpCalculateMapper.chkECash(params);

			LOGGER.info("auxAppType : " + (params.get("auxAppType")));
			LOGGER.info("payMode : " + (params.get("payMode")));

			/*
			 * 2021-04-12 - Disabled as ROT not required to insert into call log + change status if(eCashMap != null ||
			 * (params.get("auxAppType") != null && params.get("payMode") != null)) { // Call Entry Insert callSeq =
			 * ccpCalculateMapper.crtSeqCCR0006D(); params.put("callEntrySeq", callSeq); params.put("callEntryTypeId",
			 * SalesConstants.CALL_ENTRY_TYPE_ID_APPROVED); // 257 params.put("callEntryStusCodeId",
			 * SalesConstants.CALL_ENTRY_MASTER_STUS_CODE_ID_APPROVED); // 1 params.put("callEntryMasterResultId",
			 * SalesConstants.CALL_ENTRY_MASTER_RESULT_ID); //0 params.put("callEntryDocId", params.get("saveOrdId"));
			 * params.put("callEntryMasterIsWaitForCancel", SalesConstants.CALL_ENTRY_MASTER_IS_WAIT_FOR_CANCEL); //
			 * CallEntryMaster.IsWaitForCancel = false; params.put("callEntryMasterHappyCallerId",
			 * SalesConstants.CALL_ENTRY_MASTER_HAPPY_CALL_ID); //CallEntryMaster.HappyCallerID = 0;
			 *
			 * LOGGER.info("4. Insert Call Log Master CCR0006D :: Approve"); ccpCalculateMapper.insertCallEntry(params);
			 *
			 * // Approve :: Select Log logseq = ccpCalculateMapper.crtSeqSAL0009D(); params.put("logSeq", logseq);
			 * params.put("logProgId", SalesConstants.SALES_ORDER_LOG_PRGID_APPROVED); // 2 params.put("logRefId",
			 * SalesConstants.SALES_ORDER_REF_ID); // 0 params.put("logIsLock",
			 * SalesConstants.SALES_ORDER_IS_LOCK_APPROVED); // 1
			 *
			 * LOGGER.info("4. Insert Sales Order Progress Log SAL0009D :: Approve");
			 * ccpCalculateMapper.insertLog(params); }
			 */
			/* From CCP Calculation on approve CCP - End */

			LOGGER.info("===================================");
			LOGGER.info("4. ROT CCP Status :: Approve :: End");
			LOGGER.info("===================================");
		}

		return cnt;
	}
	  @Override
	  public EgovMap selectMemberByMemberIDCode(Map<String, Object> params) {
	    // TODO Auto-generated method stub
	    return ownershipTransferMapper.selectMemberByMemberIDCode(params);
	  }

		@Override
		public int saveRotDetail(Map<String, Object> params, SessionVO sessionVO) { //save rot reason after validation
			LOGGER.debug("OwnershipTransferServiceImpl :: saveRotDetail");
			LOGGER.info("params : {}", params);
			int cnt = 0;
			params.put("rotId", params.get("rotId"));
			params.put("rotReasonAfter", params.get("rotReasonAfter"));
			cnt = ownershipTransferMapper.updateSAL0276D_rotReason(params);
			return cnt;
		}

		public EgovMap selectRequestorInfo(Map<String, Object> params) {
			return ownershipTransferMapper.selectRequestorInfo(params);
		}

		public EgovMap checkBundleInfo(Map<String, Object> params) {
			return ownershipTransferMapper.checkBundleInfo(params);
		}

		public EgovMap checkBundleInfoCcp(Map<String, Object> params) {
			return ownershipTransferMapper.checkBundleInfoCcp(params);
		}

		public EgovMap checkActRot(Map<String, Object> params) {
			return ownershipTransferMapper.checkActRot(params);
		}

		@Override
		public int getRootGrpID() {
			return ownershipTransferMapper.getRootGrpID();
		}

		@Override
		public int updRootGrpId(Map<String, Object> params) {
			int cnt = ownershipTransferMapper.updRootGrpId(params);
			return cnt;
		}

		@Override
		public EgovMap checkRootGrpId(Map<String, Object> params) {
			return ownershipTransferMapper.checkRootGrpId(params);
		}
}
