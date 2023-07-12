package com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.payment.mobileLumpSumPayment.MobileLumpSumPaymentOrderDetailsForm;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.MobileLumpSumPaymentKeyInService;
import com.coway.trust.biz.sales.mambership.MembershipPaymentService;
import com.coway.trust.biz.sales.mambership.impl.MembershipESvmMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("mobileLumpSumPaymentKeyInService")
public class MobileLumpSumPaymentKeyInServiceImpl extends EgovAbstractServiceImpl
		implements MobileLumpSumPaymentKeyInService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MobileLumpSumPaymentKeyInServiceImpl.class);

	private Pattern patternInteger = Pattern.compile("^\\d+$");

	@Autowired
	private MessageSourceAccessor messageAccessor;
	@Resource(name = "mobileLumpSumPaymentKeyInMapper")
	private MobileLumpSumPaymentKeyInMapper mobileLumpSumPaymentKeyInMapper;
	@Resource(name = "commonPaymentService")
	private CommonPaymentService commonPaymentService;
	@Resource(name = "membershipPaymentService")
	private MembershipPaymentService membershipPaymentService;
	@Resource(name = "membershipESvmMapper")
	private MembershipESvmMapper membershipESvmMapper;

	@Override
	public List<EgovMap> customerInfoSearch(Map<String, Object> params) {
		String custCiType = params.get("custCiType").toString();

		// Invoice Number Type Searching
		if (custCiType.equals("1")) {
			EgovMap billingInfoSearchResult = mobileLumpSumPaymentKeyInMapper.getCustomerBillingInfoByInvoiceNo(params);

			params.put("nric", billingInfoSearchResult.get("nric").toString());
			params.put("accBillCrtDt", billingInfoSearchResult.get("accBillCrtDt").toString());
			params.put("accBillGrpId", billingInfoSearchResult.get("accBillGrpId").toString());
		}

		// Cust search by NRIC/Company IC
		if (custCiType.equals("2")) {
			params.put("nric", params.get("custCi").toString());
		}

		List<EgovMap> customerInfoSearchResult = null;
		if (params.get("nric") != null && !params.get("nric").toString().isEmpty()) {
			customerInfoSearchResult = mobileLumpSumPaymentKeyInMapper.getCustomerInfo(params);
		}

		return customerInfoSearchResult;
	}

	@Override
	public List<EgovMap> getCustomerOutstandingDistinctOrder(Map<String, Object> params) {
		List<EgovMap> customerOutstandingOrder = mobileLumpSumPaymentKeyInMapper.getCustomerOutstandingOrder(params);

		List<EgovMap> customerOutstandingDistinctOrder = new ArrayList<>();
		if (customerOutstandingOrder.size() > 0) {
			List<EgovMap> orderNoDistinct = new ArrayList<EgovMap>();
			orderNoDistinct = customerOutstandingOrder.stream().filter(distinctByKey(p -> p.get("ordNo")))
					.collect(Collectors.toList());

			for (EgovMap item : orderNoDistinct) {
				EgovMap newItem = new EgovMap();
				newItem.put("ordNo", item.get("ordNo"));
				newItem.put("ordTypeId", item.get("ordTypeId"));
				newItem.put("ordTypeName", item.get("ordTypeName"));
				customerOutstandingDistinctOrder.add(newItem);
			}
		}
		return customerOutstandingDistinctOrder;
	}

	@Override
	public List<EgovMap> getCustomerOutstandingOrderDetailList(Map<String, Object> params) {
		List<EgovMap> customerOutstandingOrders = mobileLumpSumPaymentKeyInMapper.getCustomerOutstandingOrder(params);
		return customerOutstandingOrders;
	}

	@Override
	public List<EgovMap> rejectApproval(Map<String, Object> params, SessionVO sessionVO){
		String[] mobPayGroupNo = params.get("data").toString().split(",");
		params.put("mobPayGroupNo", mobPayGroupNo);
		params.put("userId", sessionVO.getUserId());

		int updateResult = mobileLumpSumPaymentKeyInMapper.updateRejectLumpSumPayment(params);

		if(updateResult > 0){
			List<EgovMap> result = new ArrayList();
			for(String mobPayGNo : mobPayGroupNo){
				EgovMap info = new EgovMap();
				info.put("mobPayGroupNo", mobPayGNo);
				result.add(info);
			}

			return result;
		}
		return null;
	}

	@Override
	public Map<String, Object> submissionSave(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<>();
		result.put("result", 0);
		int nextGroupID = mobileLumpSumPaymentKeyInMapper.selectNextMobPayGroupId();
		EgovMap user = mobileLumpSumPaymentKeyInMapper.selectUser(params);
		params.put("userId", user.get("userId"));
		params.put("mobilePayGrpNo", nextGroupID);
		LOGGER.debug("Mobile LS : " + params);

		if (params.get("uploadImg1") != null && Integer.parseInt(params.get("uploadImg1").toString()) == 0) {
			params.put("uploadImg1", null);
		}
		if (params.get("uploadImg2") != null && Integer.parseInt(params.get("uploadImg2").toString()) == 0) {
			params.put("uploadImg2", null);
		}
		if (params.get("uploadImg3") != null && Integer.parseInt(params.get("uploadImg3").toString()) == 0) {
			params.put("uploadImg3", null);
		}
		if (params.get("uploadImg4") != null && Integer.parseInt(params.get("uploadImg4").toString()) == 0) {
			params.put("uploadImg4", null);
		}
		if (params.get("issueBank") != null && Integer.parseInt(params.get("issueBank").toString()) == 0) {
			params.put("issueBank", null);
		}
		if (params.get("cardMode") != null && Integer.parseInt(params.get("cardMode").toString()) == 0) {
			params.put("cardMode", null);
		}
		if (params.get("merchantBank") != null && Integer.parseInt(params.get("merchantBank").toString()) == 0) {
			params.put("merchantBank", null);
		}

		if (params.get("cardBrand") != null && Integer.parseInt(params.get("cardBrand").toString()) == 0) {
			params.put("cardBrand", null);
		}

		mobileLumpSumPaymentKeyInMapper.insertPaymentMasterInfo(params);

		List<Map<String, Object>> orderDetails = (List<Map<String, Object>>) params.get("orderDetailList");
		if (orderDetails.size() > 0) {
			for (int i = 0; i < orderDetails.size(); i++) {
				orderDetails.get(i).put("mobilePayGrpNo", nextGroupID);
				mobileLumpSumPaymentKeyInMapper.insertPaymentDetailInfo(orderDetails.get(i));
			}
			result.put("result", 1);
		}
		else{
			throw new ApplicationException(AppConstants.FAIL, "There is no orders being submit for payment. Please Contact IT.");
		}
		return result;
	}

	@Override
	public List<EgovMap> getLumpSumEnrollmentList(Map<String, Object> params) {
		List<EgovMap> resultList = mobileLumpSumPaymentKeyInMapper.getLumpSumEnrollmentList(params);
		return resultList;
	}

	@Override
	public List<EgovMap> mobileSelectCashMatchingPayGroupList(Map<String, Object> params) {
		EgovMap user = new EgovMap();
		if (params.get("userName") != null) {
			user = mobileLumpSumPaymentKeyInMapper.selectUser(params);
			if (user != null) {
				params.put("userId", user.get("userId"));
			}
		}
		List<EgovMap> resultList = mobileLumpSumPaymentKeyInMapper.mobileSelectCashMatchingPayGroupList(params);
		return resultList;
	}

	@Override
	public int mobileUpdateCashMatchingData(Map<String, Object> params) {
		EgovMap user = mobileLumpSumPaymentKeyInMapper.selectUser(params);
		params.put("userId", user.get("userId"));
		mobileLumpSumPaymentKeyInMapper.mobileUpdateCashMatchingData(params);
		return 1;
	}

	@Override
	public Map<String, Object> saveNormalPayment(Map<String, Object> params, SessionVO sessionVO) {
		EgovMap detail = mobileLumpSumPaymentKeyInMapper.selectLumpSumPaymentDetail(params);
		List<EgovMap> subDetail = mobileLumpSumPaymentKeyInMapper.selectLumpSumPaymentSubDetail(params);
		params.put("memCode", Integer.parseInt(detail.get("crtMemCode").toString()));

		List<Object> formList = new ArrayList<Object>();
		int iProcSeq = 1;
		String allowance = "0";
		String trRefNo = "";
		String trIssDt = "";

		// ALLOWANCE
		if (!"".equals(CommonUtils.nvl(params.get("allowance")))) {
			allowance = "1";
		} else {
			allowance = "0";
		}

		// TR REF NO.
		if (!"".equals(CommonUtils.nvl(params.get("trRefNo")))) {
			trRefNo = params.get("trRefNo").toString();
		} else {
			trRefNo = "";
		}

		// TR ISSED DATE.
		if (!"".equals(CommonUtils.nvl(params.get("trIssDt")))) {
			trIssDt = params.get("trIssDt").toString();
		} else {
			trIssDt = "";
		}

		// VERIFY TRX ID AMOUNT VS SELECTED AMOUNT
		String key = (String) params.get("transactionId"); // BANK STATEMENT ID
		if (!patternInteger.matcher(key).matches()) {
			throw new ApplicationException(AppConstants.FAIL, "Entered transaction ID must be in number format.");
		}

		Map<String, Object> schParams = new HashMap<String, Object>();
		schParams.put("fTrnscId", key);
		EgovMap selectBankStatementInfo = mobileLumpSumPaymentKeyInMapper.selectBankStatementInfo(schParams);

		if (selectBankStatementInfo == null) {
			throw new ApplicationException(AppConstants.FAIL,
					"Entered Transaction ID not found OR is mapped. Please check Transaction ID entered.");
		}

		BigDecimal transactionCredit = BigDecimal.ZERO;

		if ("".equals(String.valueOf(selectBankStatementInfo.get("crdit")))) {
			transactionCredit = BigDecimal.ZERO;
		} else {
			transactionCredit = new BigDecimal(String.valueOf(selectBankStatementInfo.get("crdit")));
		}

		BigDecimal totPayAmount = (BigDecimal) detail.get("totPayAmt");
		if (transactionCredit.compareTo(totPayAmount) != 0) {
			throw new ApplicationException(AppConstants.FAIL,
					"Total selected payment amount of " + totPayAmount.toPlainString()
							+ " does not match with transaction ID's amount of " + transactionCredit.toPlainString()
							+ ".");
		}

		// TRANSACTION TYPE
		String paymentMode = (String) selectBankStatementInfo.get("type");
		String payType = "";

		// ONGHC - ADD FOR ONL TRANSACTION
		if ("ONL".equals(paymentMode)) {
			payType = "108";
		} else if ("CHQ".equals(paymentMode)) {
			payType = "106";
		} else {
			payType = "105";
		}

		String payMode = "";

		if ("5697".equals(String.valueOf(params.get("payMode")))) {
			payMode = "CHQ";
		} else {
			if ("ONL".equals(paymentMode)) {
				payMode = "ONL";
			} else {
				payMode = "CSH";
			}
		}

		// PAYMENT MODE CHECKING between bank statement and selected record
		if (!paymentMode.equals(payMode)) {
			throw new ApplicationException(AppConstants.FAIL,
					"Selected payment type does not match with entered transaction ID's payment type");
		}

		// EACH ORDER LOOP
		if (subDetail.size() > 0) {
			for (int i = 0; i < subDetail.size(); i++) {
				EgovMap orderDetail = subDetail.get(i);

				String salesOrdNo = new BigDecimal(orderDetail.get("salesOrdNo").toString()).toPlainString();
				String salesOrdId = new BigDecimal(orderDetail.get("salesOrdId").toString()).toPlainString();

				Map<String, Object> subInfoParam = new HashMap();
				subInfoParam.put("salesOrdNo", salesOrdNo);
				subInfoParam.put("salesOrderId", salesOrdId);
				subInfoParam.put("orderId", salesOrdId);

				EgovMap orderDetailInfo = mobileLumpSumPaymentKeyInMapper.selectOrderDetailInfo(subInfoParam);
				if (orderDetailInfo != null) {
					subInfoParam.put("appTypeId", Integer.parseInt(orderDetailInfo.get("appTypeId").toString()));

					String paymentType = orderDetail.get("payType").toString();

					if (paymentType == "RENTAL PAYMENT") {
						formList = rentalPaymentCollection(params, orderDetail, subInfoParam, allowance, trRefNo,
								trIssDt, iProcSeq, formList);
					}
					// need to know if is HT/HA
					if (paymentType == "OUTRIGHT PAYMENT" || paymentType == "INSTALLMENT PAYMENT") {
						formList = nonRentalPaymentCollection(params, orderDetail, subInfoParam, allowance, trRefNo,
								trIssDt, iProcSeq, formList);
					}

					if (paymentType == "OUTRIGHT MEMBERSHIP") {
						formList = outrightMembershipPaymentCollection(params, orderDetail, subInfoParam, allowance, trRefNo,
								trIssDt, iProcSeq, formList);
					}

					if (paymentType == "AS PAYMENT") {
						formList = asPaymentCollection(params, orderDetail, subInfoParam, allowance, trRefNo,
								trIssDt, iProcSeq, formList);
					}
				}
				iProcSeq = iProcSeq + 1; // 2020.02.24 : ADD iProcSeq
			} // End For Loop
			BigDecimal totPayAmt = new BigDecimal(String.valueOf(detail.get("totPayAmt")));

			if (params.get("chargeAmount") == null || params.get("chargeAmount").equals("")) {
				params.put("chargeAmount", 0);
			}

			if (params.get("bankAcc") == null || params.get("bankAcc").equals("")) {
				params.put("bankAcc", 0);
			}

			params.put("payItemIsLock", false);
			params.put("payItemIsThirdParty", false);
			params.put("payItemStatusId", 1);
			params.put("isFundTransfer", false);
			params.put("skipRecon", false);
			params.put("payItemCardTypeId", 0);

			params.put("keyInPayRoute", "WEB");
			params.put("keyInScrn", "NOR");
			params.put("amount", totPayAmt);
			params.put("slipNo", detail.get("slipNo"));
			params.put("chqNo", detail.get("chequeNo")); // ADD TO SET CHEQUE NO.
			params.put("bankType", "2729");
			params.put("keyInPayDate", detail.get("crtDt"));

			params.put("bankAcc", selectBankStatementInfo.get("bankAccId"));
			params.put("trDate", selectBankStatementInfo.get("trnscDt"));

			// ONGHC - ADD FOR ONL PAYMENT TYPE
			params.put("payType", payType);
			params.put("userid", sessionVO.getUserId());

			/**
			 * onwards is update pay0349m status && INSERT TO PAY0240T AND PAY0241T
			 */
			mobileLumpSumPaymentKeyInMapper.updateApproveLumpSumPaymentInfo(params);
			Map<String, Object> resultList = commonPaymentService.saveNormalPayment(params, formList,
					Integer.parseInt(key));
			return resultList;
		}
		return null;
	}

	@Override
	public List<EgovMap> savePaymentCard(Map<String, Object> params, SessionVO sessionVO) {
	    List<Object> gridFormList = (List<Object>) params.get(AppConstants.AUIGRID_FORM);
	    Map<String, Object> formInfo = null;
	    formInfo = new HashMap<String, Object>();
	    if (gridFormList.size() > 0) {
	      for (Object obj : gridFormList) {
	        Map<String, Object> map = (Map<String, Object>) obj;
	        formInfo.put((String) map.get("name"), map.get("value"));
	      }
	    }

		EgovMap detail = mobileLumpSumPaymentKeyInMapper.selectLumpSumPaymentDetail(params);
		List<EgovMap> subDetail = mobileLumpSumPaymentKeyInMapper.selectLumpSumPaymentSubDetail(params);
		params.put("memCode", Integer.parseInt(detail.get("crtMemCode").toString()));

		List<Object> formList = new ArrayList<Object>();
		int iProcSeq = 1;
		String allowance = "0";
		String trRefNo = "";
		String trIssDt = "";

		// ALLOWANCE
		if (formInfo.get("allowance") != null) {
		      allowance = "1";
		} else {
		      allowance = "0";
		}

		// TR REF NO.
	    if (formInfo.get("trRefNo2") != null) {
	        trRefNo = formInfo.get("trRefNo2").toString();
	      } else {
	        trRefNo = "";
	      }

		// TR ISSED DATE.
	    if (formInfo.get("trIssDt2") != null) {
	        trIssDt = formInfo.get("trIssDt2").toString();
	      } else {
	        trIssDt = "";
	      }

		// EACH ORDER LOOP
		if (subDetail.size() > 0) {
			for (int i = 0; i < subDetail.size(); i++) {
				EgovMap orderDetail = subDetail.get(i);

				String salesOrdNo = new BigDecimal(orderDetail.get("salesOrdNo").toString()).toPlainString();
				String salesOrdId = new BigDecimal(orderDetail.get("salesOrdId").toString()).toPlainString();

				Map<String, Object> subInfoParam = new HashMap();
				subInfoParam.put("salesOrdNo", salesOrdNo);
				subInfoParam.put("salesOrderId", salesOrdId);
				subInfoParam.put("orderId", salesOrdId);

				EgovMap orderDetailInfo = mobileLumpSumPaymentKeyInMapper.selectOrderDetailInfo(subInfoParam);
				if (orderDetailInfo != null) {
					subInfoParam.put("appTypeId", Integer.parseInt(orderDetailInfo.get("appTypeId").toString()));

					// Need to do status check to know whether is an outright/membership/AS order
					String paymentType = orderDetail.get("payType").toString();
					// RENTAL PAYMENT, OUTRIGHT PAYMENT, INSTALLMENT PAYMENT, AS PAYMENT
					// RENTAL MEMBERSHIP,OUTRIGHT MEMBERSHIP

					if (paymentType == "RENTAL PAYMENT") {
						formList = rentalPaymentCollection(params, orderDetail, subInfoParam, allowance, trRefNo,
								trIssDt, iProcSeq, formList);
					}
					// need to know if is HT/HA
					if (paymentType == "OUTRIGHT PAYMENT" || paymentType == "INSTALLMENT PAYMENT") {
						formList = nonRentalPaymentCollection(params, orderDetail, subInfoParam, allowance, trRefNo,
								trIssDt, iProcSeq, formList);
					}

					if (paymentType == "OUTRIGHT MEMBERSHIP") {
						formList = outrightMembershipPaymentCollection(params, orderDetail, subInfoParam, allowance, trRefNo,
								trIssDt, iProcSeq, formList);
					}

					if (paymentType == "AS PAYMENT") {
						formList = asPaymentCollection(params, orderDetail, subInfoParam, allowance, trRefNo,
								trIssDt, iProcSeq, formList);
					}
				}
				iProcSeq = iProcSeq + 1; // 2020.02.24 : ADD iProcSeq
			} // End For Loop

			 // CREDIT CARD일때
		      if ("107".equals(String.valueOf(formInfo.get("keyInPayType")))) {
		        formInfo.put("keyInIsOnline", "1299".equals(String.valueOf(formInfo.get("keyInCardMode"))) ? 0 : 1);
		        formInfo.put("keyInIsLock", 0);
		        formInfo.put("keyInIsThirdParty", 0);
		        formInfo.put("keyInStatusId", 1);
		        formInfo.put("keyInIsFundTransfer", 0);
		        formInfo.put("keyInSkipRecon", 0);
		        formInfo.put("keyInPayItmCardType", formInfo.get("keyCrcCardType"));
		        formInfo.put("keyInPayItmCardMode", formInfo.get("keyInCardMode"));
		        formInfo.put("keyInPayType", "107");
		        formInfo.put("keyInPayDate", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1)); // 임시
		      }

		      formInfo.put("userId", sessionVO.getUserId());

			/**
			 * onwards is update pay0349m status && INSERT TO PAY0240T AND PAY0241T
			 */
			mobileLumpSumPaymentKeyInMapper.updateApproveLumpSumPaymentInfo(params);
			List<EgovMap> resultList = null;
			// INSERT TO PAY0240T AND PAY0241T AND LATER EXECUTE SP_INST_NORMAL_PAYMENT
			resultList = commonPaymentService.savePayment(formInfo, formList);
			return resultList;
		}
		return null;
	}

	private List<Object> rentalPaymentCollection(Map<String, Object> params, EgovMap orderDetail,
			Map<String, Object> subInfoParam, String allowance, String trRefNo, String trIssDt, int iProcSeq,
			List<Object> formList) {

		String salesOrdNo = subInfoParam.get("salesOrdNo").toString();
		String salesOrdId = subInfoParam.get("salesOrdId").toString();

		List<EgovMap> orderInfoRentalList = commonPaymentService.selectOrderInfoRental(subInfoParam);
		if (orderInfoRentalList.get(0) == null) {
			throw new ApplicationException(AppConstants.FAIL,
					"No record found for order [" + salesOrdNo + "] rental information.");
		}

		// Payment - Bill Info Rental 조회
		BigDecimal rpf = new BigDecimal(orderInfoRentalList.get(0).get("rpf").toString()); // TOTAL RPF
		BigDecimal rpfPaid = new BigDecimal(orderInfoRentalList.get(0).get("rpfPaid").toString()); // TOTAL
																								   // PAID
																								   // RPF

		String excludeRPF = "";

		if (rpf.compareTo(BigDecimal.ZERO) >= 1) { // HAVE RPF
			if (rpfPaid.compareTo(rpf) >= 0) { // PAID RPF >= RPF
				excludeRPF = "N"; // NO NEED RPF
			} else {
				excludeRPF = "Y"; // RPF REQUIRED
			}
			excludeRPF = "Y"; // RPF REQUIRED
		}

		if (rpf.compareTo(BigDecimal.ZERO) == 0) { // IF RPF IS 0 THAN NO NEED RPF
			excludeRPF = "N";
		}

		subInfoParam.put("excludeRPF", excludeRPF);

		List<EgovMap> billInfoRentalList = commonPaymentService.selectBillInfoRental(subInfoParam);

		subInfoParam.put("COLL_MEM_CODE", params.get("memCode"));
		List<EgovMap> paymentCollectorConfirm = membershipPaymentService.paymentColleConfirm(params);

		if (paymentCollectorConfirm.get(0) == null) {
			throw new ApplicationException(AppConstants.FAIL, "No record found for payment collection's member.");
		}

		EgovMap paymentColleConfirmMap = paymentCollectorConfirm.get(0);

		BigDecimal mstRpf = new BigDecimal(orderInfoRentalList.get(0).get("rpf").toString());
		BigDecimal mstRpfPaid = new BigDecimal(orderInfoRentalList.get(0).get("rpfPaid").toString());

		String mstCustNm = (String) orderInfoRentalList.get(0).get("custNm");
		BigDecimal mstCustBillId = new BigDecimal(orderInfoRentalList.get(0).get("custBillId").toString());

		Map<String, Object> formMap = null;

		BigDecimal totTargetAmt = BigDecimal.ZERO;
		BigDecimal totRemainAmt = new BigDecimal("".equals(CommonUtils.nvl(String.valueOf(orderDetail.get("payAmt"))))
				? "0" : String.valueOf(orderDetail.get("payAmt")));

		for (int j = 0; j < orderInfoRentalList.size(); j++) {
			if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
				// IF HAVE REMAINING RPF
				if (((mstRpf.subtract(mstRpfPaid)).compareTo(BigDecimal.ZERO) > 0)) {
					BigDecimal payAmt = new BigDecimal("".equals(CommonUtils.nvl((orderDetail.get("payAmt")))) ? "0"
							: String.valueOf(orderDetail.get("payAmt")));
					BigDecimal targetAmtRPF = BigDecimal.ZERO;

					if ((mstRpf.subtract(mstRpfPaid)).compareTo(payAmt) > 0) {
						targetAmtRPF = payAmt; // IF REMAINING RPF MORE THAN PAYMENT AMOUNT DIRECT USE
											   // PAYMENT AMOUNT
					} else {
						targetAmtRPF = mstRpf.subtract(mstRpfPaid);
					}

					formMap = new HashMap<String, Object>();

					formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
					formMap.put("appType", "RENTAL");
					formMap.put("advMonth", 0);
					formMap.put("mstRpf", mstRpf);
					formMap.put("mstRpfPaid", mstRpfPaid);
					formMap.put("assignAmt", 0);
					formMap.put("billAmt", mstRpf);
					formMap.put("billDt", "1900-01-01");
					formMap.put("billGrpId", mstCustBillId);
					formMap.put("billId", 0);
					formMap.put("billNo", "0");
					formMap.put("billStatus", "");
					formMap.put("billTypeId", 161);
					formMap.put("billTypeNm", "RPF");
					formMap.put("custNm", mstCustNm);
					formMap.put("discountAmt", 0);
					formMap.put("installment", 0);
					formMap.put("ordId", salesOrdId);
					formMap.put("ordNo", salesOrdNo);
					formMap.put("paidAmt", mstRpfPaid);
					formMap.put("targetAmt", targetAmtRPF);
					formMap.put("srvcContractID", 0);
					formMap.put("billAsId", 0);
					formMap.put("srvMemId", 0);
					formMap.put("trNo", trRefNo);
					formMap.put("trDt", trIssDt);
					formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
					formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
					formMap.put("allowComm", allowance);

					formList.add(formMap);
					totRemainAmt = totRemainAmt.subtract(targetAmtRPF);
				}
			}

			// NO RENTAL PROCESSING FEE
			if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
				for (j = 0; j < billInfoRentalList.size(); j++) {
					Map billInfoRentalMap = billInfoRentalList.get(j);

					String detSalesOrdNo = (String) billInfoRentalMap.get("ordNo");
					if (salesOrdNo.equals(detSalesOrdNo)) {
						// AMOUNT TO BE DEDUCT
						BigDecimal targetAmt = new BigDecimal(billInfoRentalMap.get("targetAmt").toString());

						if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
							if (totRemainAmt.compareTo(targetAmt) < 0) {
								targetAmt = totRemainAmt;
							}

							formMap = new HashMap<String, Object>();
							formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
							formMap.put("appType", "RENTAL");
							formMap.put("advMonth", 0);
							formMap.put("mstRpf", mstRpf);
							formMap.put("mstRpfPaid", mstRpfPaid);

							formMap.put("assignAmt", 0);
							formMap.put("billAmt", billInfoRentalMap.get("billAmt"));
							formMap.put("billDt", billInfoRentalMap.get("billDt"));
							formMap.put("billGrpId", billInfoRentalMap.get("billGrpId"));
							formMap.put("billId", billInfoRentalMap.get("billId"));
							formMap.put("billNo", billInfoRentalMap.get("billNo"));
							formMap.put("billStatus", billInfoRentalMap.get("stusCode"));
							formMap.put("billTypeId", billInfoRentalMap.get("billTypeId"));
							formMap.put("billTypeNm", billInfoRentalMap.get("billTypeNm"));
							formMap.put("custNm", billInfoRentalMap.get("custNm"));
							formMap.put("discountAmt", 0);
							formMap.put("installment", billInfoRentalMap.get("installment"));
							formMap.put("ordId", billInfoRentalMap.get("ordId"));
							formMap.put("ordNo", billInfoRentalMap.get("ordNo"));
							formMap.put("paidAmt", billInfoRentalMap.get("paidAmt"));
							formMap.put("appType", "RENTAL");
							formMap.put("targetAmt", targetAmt);
							formMap.put("srvcContractID", 0);
							formMap.put("billAsId", 0);
							formMap.put("srvMemId", 0);

							formMap.put("trNo", trRefNo);
							formMap.put("trDt", trIssDt);
							formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
							formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
							formMap.put("allowComm", allowance);

							formList.add(formMap);

							//totRemainAmt = totRemainAmt.subtract(targetAmt);
						}
					} else {
						break;
					}
				}
			}
		}
		return formList;
	}

	private List<Object> nonRentalPaymentCollection(Map<String, Object> params, EgovMap orderDetail,
			Map<String, Object> subInfoParam, String allowance, String trRefNo, String trIssDt, int iProcSeq,
			List<Object> formList) {
		Map<String, Object> formMap = null;
		String salesOrdNo = subInfoParam.get("salesOrdNo").toString();
		String salesOrdId = subInfoParam.get("salesOrdId").toString();
		BigDecimal totRemainAmt = new BigDecimal("".equals(CommonUtils.nvl(String.valueOf(orderDetail.get("payAmt"))))
				? "0" : String.valueOf(orderDetail.get("payAmt")));

		// selectOrderInfoNonRental
		List<EgovMap> orderInfoNonRentalList = commonPaymentService.selectOrderInfoNonRental(subInfoParam);

		if (orderInfoNonRentalList.get(0) == null) {
			throw new ApplicationException(AppConstants.FAIL,
					"No record found for order [" + salesOrdNo + "] outright information.");
		}

		subInfoParam.put("COLL_MEM_CODE", params.get("memCode"));
		List<EgovMap> paymentCollectorConfirm = membershipPaymentService.paymentColleConfirm(params);

		if (paymentCollectorConfirm.get(0) == null) {
			throw new ApplicationException(AppConstants.FAIL, "No record found for payment collection's member.");
		}

		EgovMap nonRentalOrderInfo = orderInfoNonRentalList.get(0);
		EgovMap paymentColleConfirmMap = paymentCollectorConfirm.get(0);

		formMap = new HashMap<String, Object>();
		formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
		formMap.put("appType", "OUT");
		formMap.put("advMonth", 0);
		formMap.put("mstRpf", 0);
		formMap.put("mstRpfPaid", 0);

		formMap.put("billAmt", nonRentalOrderInfo.get("balance"));
		formMap.put("billDt", "01/01/1900");
		formMap.put("billGrpId", 0);
		formMap.put("billId", nonRentalOrderInfo.get("custBillId"));
		formMap.put("billNo", "0");
		formMap.put("billStatus", "");
		formMap.put("billTypeId", nonRentalOrderInfo.get("appTypeId"));
		formMap.put("billTypeNm", nonRentalOrderInfo.get("appTypeNm"));
		formMap.put("custNm", nonRentalOrderInfo.get("custNm"));
		formMap.put("discountAmt", 0);
		formMap.put("installment", 0);
		formMap.put("ordId", nonRentalOrderInfo.get("salesOrdId"));
		formMap.put("ordNo", nonRentalOrderInfo.get("salesOrdNo"));
		formMap.put("paidAmt", nonRentalOrderInfo.get("totalPaid"));
		formMap.put("targetAmt", totRemainAmt);
		formMap.put("assignAmt", 0);
		formMap.put("srvcContractID", 0);
		formMap.put("billAsId", 0);
		formMap.put("srvMemId", 0);

		formMap.put("trNo", trRefNo);
		formMap.put("trDt", trIssDt);
		formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
		formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
		formMap.put("allowComm", allowance);

		return formList;
	}

	private List<Object> outrightMembershipPaymentCollection(Map<String, Object> params, EgovMap orderDetail,
			Map<String, Object> subInfoParam, String allowance, String trRefNo, String trIssDt, int iProcSeq,
			List<Object> formList) {
		Map<String, Object> formMap = null;
		String salesOrdNo = subInfoParam.get("salesOrdNo").toString();
		String salesOrdId = subInfoParam.get("salesOrdId").toString();

		int srvMemId = Integer.parseInt("".equals(CommonUtils.nvl(String.valueOf(orderDetail.get("srvMemId")))) ? "0" :
			String.valueOf(orderDetail.get("srvMemId")));
		BigDecimal totRemainAmt = new BigDecimal("".equals(CommonUtils.nvl(String.valueOf(orderDetail.get("payAmt"))))
				? "0" : String.valueOf(orderDetail.get("payAmt")));

		EgovMap svmInfo = mobileLumpSumPaymentKeyInMapper.getServiceMembershipDetail(params);
		EgovMap psmPay24Info = mobileLumpSumPaymentKeyInMapper.getPay0024D(params);

		subInfoParam.put("COLL_MEM_CODE", params.get("memCode"));
		List<EgovMap> paymentCollectorConfirm = membershipPaymentService.paymentColleConfirm(params);

		if (paymentCollectorConfirm.get(0) == null) {
			throw new ApplicationException(AppConstants.FAIL, "No record found for payment collection's member.");
		}

		EgovMap paymentColleConfirmMap = paymentCollectorConfirm.get(0);

		if (new BigDecimal(String.valueOf(svmInfo.get("srvMemPacAmt"))).compareTo(BigDecimal.ZERO) > 0) {
			BigDecimal packageAmt = new BigDecimal(
					"".equals(CommonUtils.nvl(String.valueOf(psmPay24Info.get("packageAmt")))) ? "0"
							: String.valueOf(psmPay24Info.get("packageAmt")));
			if (totRemainAmt.compareTo(packageAmt) >= 0) {
				formMap = new HashMap<String, Object>();
				formMap.put("procSeq", "1");
				formMap.put("appType", "OUT_MEM");
				formMap.put("advMonth", "0");
				formMap.put("billGrpId", "0");
				formMap.put("billId", "0");
				formMap.put("ordId", salesOrdId);
				formMap.put("mstRpf", "0");
				formMap.put("mstRpfPaid", "0");
				formMap.put("billNo", "0");
				formMap.put("ordNo", salesOrdNo);
				formMap.put("billTypeId", "164");
				formMap.put("billTypeNm", "Membership Package");
				formMap.put("installment", "0");
				formMap.put("billAmt", psmPay24Info.get("packageCharge"));
				formMap.put("paidAmt", psmPay24Info.get("packagePaid"));
				formMap.put("targetAmt", packageAmt);
				formMap.put("billDt", "1900-01-01");
				formMap.put("assignAmt", "0");
				formMap.put("billStatus", "");
				formMap.put("custNm", svmInfo.get("name"));
				formMap.put("srvcContractID", "0");
				formMap.put("billAsId", "0");
				formMap.put("discountAmt", "0");
				formMap.put("srvMemId", srvMemId);
				formMap.put("trNo", trRefNo);
				formMap.put("trDt", trIssDt);
				formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
				formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
				formMap.put("allowComm", allowance);
				//formMap.put("allowComm", psmPayInfo.get("allowComm"));

				formList.add(formMap);

				totRemainAmt = totRemainAmt.subtract(packageAmt);
			} else {
				throw new ApplicationException(AppConstants.FAIL,
						"Payment Amount for membership is not equal to the charged amount for order no :" + salesOrdNo);
			}
		}

		/*
		 * srvMemBsAmt = total package + filter
		 */
		if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
		 if(new BigDecimal(String.valueOf(svmInfo.get("srvMemBsAmt"))).compareTo(BigDecimal.ZERO) > 0) {
			 BigDecimal filterAmt = new BigDecimal(
						"".equals(CommonUtils.nvl(String.valueOf(psmPay24Info.get("filterAmt")))) ? "0"
								: String.valueOf(psmPay24Info.get("filterAmt")));
    			 if(totRemainAmt.compareTo(filterAmt)>= 0){
    	            formMap = new HashMap<String, Object>();

    	            formMap.put("procSeq","1");
    	            formMap.put("appType","OUT_MEM");
    	            formMap.put("advMonth","0");
    	            formMap.put("billGrpId","0");
    	            formMap.put("billId","0");
    	            formMap.put("ordId",salesOrdId);
    	            formMap.put("mstRpf","0");
    	            formMap.put("mstRpfPaid","0");
    				formMap.put("billNo", "0");
    				formMap.put("ordNo", salesOrdNo);
    	            formMap.put("billTypeId","542");
    	            formMap.put("billTypeNm","Filter (1st BS)");
    	            formMap.put("installment","0");
    	            formMap.put("billAmt",psmPay24Info.get("filterCharge"));
    	            formMap.put("paidAmt",psmPay24Info.get("filterPaid"));
    	            formMap.put("targetAmt",psmPay24Info.get("filterAmt"));
    	            formMap.put("billDt","1900-01-01");
    	            formMap.put("assignAmt","0");
    	            formMap.put("billStatus","");
    	            formMap.put("custNm",svmInfo.get("name"));
    	            formMap.put("srvcContractID","0");
    	            formMap.put("billAsId","0");
    	            formMap.put("discountAmt","0");
    	            formMap.put("srvMemId",srvMemId);
    				formMap.put("trNo", trRefNo);
    				formMap.put("trDt", trIssDt);
    				formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
    				formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
    				formMap.put("allowComm", allowance);

    	            formList.add(formMap);
    			 }
				else {
					throw new ApplicationException(AppConstants.FAIL,
							"Payment Amount for membership filter is not enough for order no :" + salesOrdNo);
				}
	        }
		}

		return formList;
	}

	private List<Object> asPaymentCollection(Map<String, Object> params, EgovMap orderDetail,
			Map<String, Object> subInfoParam, String allowance, String trRefNo, String trIssDt, int iProcSeq,
			List<Object> formList) {
		String salesOrdNo = subInfoParam.get("salesOrdNo").toString();
		String salesOrdId = subInfoParam.get("salesOrdId").toString();
		BigDecimal totRemainAmt = new BigDecimal("".equals(CommonUtils.nvl(String.valueOf(orderDetail.get("payAmt"))))
				? "0" : String.valueOf(orderDetail.get("payAmt")));

		subInfoParam.put("COLL_MEM_CODE", params.get("memCode"));
		List<EgovMap> paymentCollectorConfirm = membershipPaymentService.paymentColleConfirm(params);

		if (paymentCollectorConfirm.get(0) == null) {
			throw new ApplicationException(AppConstants.FAIL, "No record found for payment collection's member.");
		}
		EgovMap paymentColleConfirmMap = paymentCollectorConfirm.get(0);

		Map<String,Object> asBillParam = new HashMap();
		asBillParam.put("billSearchTxt", salesOrdNo);
		asBillParam.put("billType", "1");
		List<EgovMap> asBillResult = commonPaymentService.selectOrderInfoBillPayment(asBillParam);


		if(asBillResult.size() == 0){
			throw new ApplicationException(AppConstants.FAIL, "No record found for AS Payment of order " + salesOrdNo);
		}
		else{
			/*
			 * Will have multiple AS Bill in 1 order
			 */
			for(int i =0;i< asBillResult.size();i++){
				EgovMap asDetail = asBillResult.get(i);

				if(asDetail.get("billIsPaid").toString().toUpperCase() == "FALSE"){
					BigDecimal billAmt = new BigDecimal(
							"".equals(CommonUtils.nvl(String.valueOf(asDetail.get("billAmt")))) ? "0"
									: String.valueOf(asDetail.get("billAmt")));

					if(totRemainAmt.compareTo(billAmt) >= 0){
						Map<String, Object> formMap = new HashMap<String, Object>();
						formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
						formMap.put("appType", "AS");
						formMap.put("advMonth", 0);
						formMap.put("mstRpf", "0");
						formMap.put("mstRpfPaid", "0");
						formMap.put("assignAmt", billAmt);
						formMap.put("billAmt", billAmt);
						formMap.put("billDt", asDetail.get("billDt"));
						formMap.put("billGrpId", 0);
						formMap.put("billId", asDetail.get("billId"));
						formMap.put("billNo", asDetail.get("billNo"));
						formMap.put("billStatus", asDetail.get("stusNm"));
						formMap.put("billTypeId", 238);
						formMap.put("billTypeNm", "ASBill");
						formMap.put("custNm", asDetail.get("custNm"));
						formMap.put("discountAmt", 0);
						formMap.put("installment", 0);
						formMap.put("ordId", salesOrdId);
						formMap.put("ordNo", salesOrdNo);
						formMap.put("paidAmt", billAmt);
						formMap.put("targetAmt", billAmt);
						formMap.put("srvcContractID", 0);
						formMap.put("billAsId", asDetail.get("billAsId"));
						formMap.put("srvMemId", 0);
						formMap.put("trNo", trRefNo);
						formMap.put("trDt", trIssDt);
						formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
						formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
						formMap.put("allowComm", allowance);

						formList.add(formMap);

						totRemainAmt = billAmt.subtract(billAmt);
					}
					else{
						throw new ApplicationException(AppConstants.FAIL,
								"Payment Amount for AS Bill is not enough for order no :" + salesOrdNo);
					}
				}
			}
		}

		return formList;
	}

	private <T> Predicate<T> distinctByKey(Function<? super T, Object> keyExtractor) {
		Map<Object, Boolean> map = new ConcurrentHashMap<>();
		return t -> map.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
	}
}
