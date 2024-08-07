package com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.impl;

import static com.coway.trust.AppConstants.EMAIL_SUBJECT;
import static com.coway.trust.AppConstants.EMAIL_TEXT;
import static com.coway.trust.AppConstants.EMAIL_TO;
import static com.coway.trust.AppConstants.MSG_NECESSARY;
import static com.coway.trust.AppConstants.REPORT_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_VIEW_TYPE;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.NumberUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.EncryptionDecryptionService;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.common.service.impl.CommonPaymentMapper;
import com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.MobileLumpSumPaymentKeyInService;
import com.coway.trust.biz.sales.mambership.MembershipPaymentService;
import com.coway.trust.biz.sales.mambership.impl.MembershipESvmMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
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
	@Autowired
	private AdaptorService adaptorService;
	@Resource(name = "commonPaymentMapper")
	private CommonPaymentMapper commonPaymentMapper;

	@Resource(name = "encryptionDecryptionService")
	private EncryptionDecryptionService encryptionDecryptionService;

	@Value("${tiny.api.url}")
	private String tinyUrlApi;

	@Value("${tiny.api.token}")
	private String tinyUrlToken;

	@Value("${tiny.api.sub.domain}")
	private String tinyUrlSubDomain;

	@Value("${etrust.base.url}")
	private String etrustBaseUrl;

	@Override
	public List<EgovMap> customerInfoSearch(Map<String, Object> params) {
		String custCiType = params.get("custCiType").toString();
		List<EgovMap> customerInfoSearchResult = null;

		// Order search
		if (custCiType.equals("1")) {
			params.put("salesOrdNo", params.get("custCi").toString());

			if (params.get("salesOrdNo") != null && !params.get("salesOrdNo").toString().isEmpty()) {
				customerInfoSearchResult = mobileLumpSumPaymentKeyInMapper.getCustomerInfoBySalesOrderNo(params);
			} else {
				throw new ApplicationException(AppConstants.FAIL,
						"There is no order number to be search. Please Contact IT.");
			}
		}

		// Invoice Number Type Searching
		if (custCiType.equals("2")) {
			EgovMap billingInfoSearchResult = mobileLumpSumPaymentKeyInMapper.getCustomerBillingInfoByInvoiceNo(params);

			if(billingInfoSearchResult == null || billingInfoSearchResult.get("nric") == null){
				throw new ApplicationException(AppConstants.FAIL,
						"There is no invoice found.");
			}
			params.put("nric", billingInfoSearchResult.get("nric").toString());
			params.put("accBillCrtDt", billingInfoSearchResult.get("accBillCrtDt").toString());
			params.put("accBillGrpId", billingInfoSearchResult.get("accBillGrpId").toString());
		}

		// Cust search by NRIC/Company IC
		if (custCiType.equals("3")) {
			params.put("nric", params.get("custCi").toString());
		}

		if (params.get("nric") != null && !params.get("nric").toString().isEmpty()) {
			String nric = params.get("nric").toString();
			if (nric.matches("^[0-9]*$")) {
				String custCi = params.get("custCi").toString();
				if (custCi.matches("^[0-9]*$")) {
					params.put("custId", params.get("custCi").toString());
				}
			}
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
	public List<EgovMap> rejectApproval(Map<String, Object> params, SessionVO sessionVO) {
		String[] mobPayGroupNo = params.get("data").toString().split(",");
		params.put("mobPayGroupNo", mobPayGroupNo);
		params.put("userId", sessionVO.getUserId());

		if (StringUtils.isEmpty(params.get("userId"))) {
	        throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
	      }

	      if (StringUtils.isEmpty(params.get("status"))) {
	        throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
	      }

	      if (StringUtils.isEmpty(params.get("failReasonId"))) {
	        throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
	      }

	      if (StringUtils.isEmpty(params.get("mobPayGroupNo"))) {
		        throw new ApplicationException(AppConstants.FAIL, "No record is selected for rejection.");
		  }

		int updateResult = mobileLumpSumPaymentKeyInMapper.updateRejectLumpSumPayment(params);

		if (updateResult > 0) {
			List<EgovMap> result = new ArrayList();
			for (String mobPayGNo : mobPayGroupNo) {
				EgovMap info = new EgovMap();
				info.put("mobPayGroupNo",  "LS"  + String.format("%06d", CommonUtils.intNvl(mobPayGNo)));
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
		params.put("userBrnchId", user.get("userBrnchId"));
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

		if (Integer.parseInt(params.get("paymentMethodId").toString()) == 5698
				|| Integer.parseInt(params.get("paymentMethodId").toString()) == 5697) {// cash or cheque
			params.put("status", 1);
		} else {
			params.put("status", 104); // Processing Status
		}

		mobileLumpSumPaymentKeyInMapper.insertPaymentMasterInfo(params);

		List<Map<String, Object>> orderDetails = (List<Map<String, Object>>) params.get("orderDetailList");
		if (orderDetails.size() > 0) {
			for (int i = 0; i < orderDetails.size(); i++) {
				orderDetails.get(i).put("mobilePayGrpNo", nextGroupID);
				mobileLumpSumPaymentKeyInMapper.insertPaymentDetailInfo(orderDetails.get(i));
			}
			result.put("mobPayGroupNo", nextGroupID);
			result.put("userId", params.get("userId"));
			result.put("totPayAmt", params.get("totalPayableAmount"));
			result.put("result", 1);
		} else {
			throw new ApplicationException(AppConstants.FAIL,
					"There is no orders being submit for payment. Please Contact IT.");
		}
		return result;
	}

	@Override
	public List<EgovMap> getLumpSumEnrollmentList(Map<String, Object> params) {
		if(params.get("grpTicketNo") !=null && params.get("grpTicketNo").toString().isEmpty() == false){
			String grpTicketNo = params.get("grpTicketNo").toString();
			params.put("grpTicketNo", Integer.parseInt(grpTicketNo.replaceAll("[^0-9]", "")));
		}

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

		String[] mobPayGroupNoList = params.get("mobPayGroupNo").toString().split(",");

		if (mobPayGroupNoList.length > 0) {
			int nextVal = mobileLumpSumPaymentKeyInMapper.selectNextMatchingId();
			params.put("matchingId", nextVal);
			params.put("status", 104); // Processing Status
			params.put("mobPayGroupNo", mobPayGroupNoList);
			mobileLumpSumPaymentKeyInMapper.mobileUpdateCashMatchingData(params);
		}

		return 1;
	}

	@Override
	public Map<String, Object> saveNormalPayment(Map<String, Object> params, SessionVO sessionVO) {
		List<Object> gridDataList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // GRID DATA IMPORT
		List<Object> gridFormList = (List<Object>) params.get(AppConstants.AUIGRID_FORM); // FORM OBJECT DATA IMPORT

		int iProcSeq = 1;
		String allowance = "0";
		String trRefNo = "";
		String trIssDt = "";

		BigDecimal totPayAmount = BigDecimal.ZERO;
		String slipNo = "";
		String chequeNo = "";
		String keyInPayDate = "";
		String crtMemCode = "";
		int cashMatchingID = 0;

		LOGGER.debug("==================================================================");
		LOGGER.debug("= GRID LIST DATA : " + gridDataList.toString());
		LOGGER.debug("= GRID LIST FORM : " + gridFormList.toString());
		LOGGER.debug("==================================================================");

		Map<String, Object> formInfo = null;
		formInfo = new HashMap<String, Object>();
		if (gridFormList.size() > 0) {
			for (Object obj : gridFormList) {
				Map<String, Object> map = (Map<String, Object>) obj;
				formInfo.put((String) map.get("name"), map.get("value"));
			}
		}
		/*
		 * Form Data Checking START
		 */
		// ALLOWANCE
		if (!"".equals(CommonUtils.nvl(formInfo.get("allowance")))) {
			allowance = "1";
		} else {
			allowance = "0";
		}

		// TR REF NO.
		if (!"".equals(CommonUtils.nvl(formInfo.get("trRefNo")))) {
			trRefNo = formInfo.get("trRefNo").toString();
		} else {
			trRefNo = "";
		}

		// TR ISSED DATE.
		if (!"".equals(CommonUtils.nvl(formInfo.get("trIssDt")))) {
			trIssDt = formInfo.get("trIssDt").toString();
		} else {
			trIssDt = "";
		}

		// VERIFY TRX ID AMOUNT VS SELECTED AMOUNT
		String key = (String) formInfo.get("transactionId"); // BANK STATEMENT ID
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

		List<EgovMap> detailList = new ArrayList<EgovMap>();
		List<EgovMap> subDetailList = new ArrayList<EgovMap>();
		List<String> mobPayGroupNoList = new ArrayList();
		// Get all detail record
		for (int i = 0; i < gridDataList.size(); i++) {
			String payMode = "";
			Map<String, Object> data = new HashMap();
			data = (Map<String, Object>) gridDataList.get(i);

			mobPayGroupNoList.add(data.get("mobPayGroupNo").toString());

			EgovMap detail = mobileLumpSumPaymentKeyInMapper.selectLumpSumPaymentDetail(data);

			totPayAmount = totPayAmount.add((BigDecimal) detail.get("totPayAmt"));
			String createdMem = detail.get("crtMemCode").toString();
			if (crtMemCode.isEmpty()) {
				crtMemCode = createdMem;
				formInfo.put("memCode", createdMem);
			} else {
				if (!crtMemCode.equals(createdMem)) {
					throw new ApplicationException(AppConstants.FAIL,
							"Selected record is not created by the same Member Code");
				}
			}

			if ("5697".equals(String.valueOf(detail.get("payMode")))) {
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

			if (cashMatchingID == 0) {
				cashMatchingID = Integer.parseInt(detail.get("matchingId").toString());
			} else {
				if (cashMatchingID != Integer.parseInt(detail.get("matchingId").toString())) {
					throw new ApplicationException(AppConstants.FAIL,
							"The matching attachment is different. Please ensure that matching is same to proceed.");
				}
			}

			slipNo = detail.get("slipNo") == null ? "" : detail.get("slipNo").toString();
			chequeNo = detail.get("chequeNo") == null ? "" : detail.get("chequeNo").toString();
			keyInPayDate = detail.get("crtDt") == null ? "" : detail.get("crtDt").toString();

			List<EgovMap> subDetails = mobileLumpSumPaymentKeyInMapper.selectLumpSumPaymentSubDetail(data);
			subDetailList.addAll(subDetails);
			detailList.add(detail);
		}

		if (transactionCredit.compareTo(totPayAmount) != 0) {
			throw new ApplicationException(AppConstants.FAIL,
					"Total selected payment amount of " + totPayAmount.toPlainString()
							+ " does not match with transaction ID's amount of " + transactionCredit.toPlainString()
							+ ".");
		}

		/*
		 * Form Data Checking END
		 */
		List<Object> dataList = new ArrayList<Object>();
		// EACH ORDER LOOP
		if (subDetailList.size() > 0) {
			for (int i = 0; i < subDetailList.size(); i++) {
				int currFormSize = dataList.size();
				EgovMap orderDetail = subDetailList.get(i);

				String salesOrdNo = orderDetail.get("salesOrdNo").toString();
				String salesOrdId = new BigDecimal(orderDetail.get("salesOrdId").toString()).toPlainString();

				Map<String, Object> subInfoParam = new HashMap();
				subInfoParam.put("salesOrdNo", salesOrdNo);
				subInfoParam.put("salesOrdId", salesOrdId);
				subInfoParam.put("orderId", salesOrdId);

				EgovMap orderDetailInfo = mobileLumpSumPaymentKeyInMapper.selectOrderDetailInfo(subInfoParam);
				if (orderDetailInfo != null) {
					subInfoParam.put("appTypeId", Integer.parseInt(orderDetailInfo.get("appTypeId").toString()));

					String paymentType = orderDetail.get("payType").toString();

					if (paymentType.equals("RENTAL PAYMENT")) {
						dataList = rentalPaymentCollection(formInfo, orderDetail, subInfoParam, allowance, trRefNo,
								trIssDt, iProcSeq, dataList);
					}
					// need to know if is HT/HA
					if (paymentType.equals("OUTRIGHT PAYMENT") || paymentType.equals("INSTALLMENT PAYMENT")) {
						dataList = nonRentalPaymentCollection(formInfo, orderDetail, subInfoParam, allowance, trRefNo,
								trIssDt, iProcSeq, dataList);
					}

					if (paymentType.equals("OUTRIGHT MEMBERSHIP")) {
						if (orderDetail.get("srvMemId") != null) {
							subInfoParam.put("srvMemId", orderDetail.get("srvMemId").toString());
						}
						dataList = outrightMembershipPaymentCollection(formInfo, orderDetail, subInfoParam, allowance,
								trRefNo, trIssDt, iProcSeq, dataList);
					}

					if (paymentType.equals("AS PAYMENT")) {
						dataList = asPaymentCollection(formInfo, orderDetail, subInfoParam, allowance, trRefNo, trIssDt,
								iProcSeq, dataList);
					}
				}
				iProcSeq = iProcSeq + 1; // 2020.02.24 : ADD iProcSeq

				int afterFormSize = dataList.size();
				//This is to check if every order has generated formList out or not
				if (currFormSize == afterFormSize) {
					throw new ApplicationException(AppConstants.FAIL,
							"Error generating receipt for MobPayGroupNo: " + orderDetail.get("mobPayGroupNo").toString()
									+ " due to no payment found for Order No:" + salesOrdNo);
				}
			} // End For Loop

			if (formInfo.get("chargeAmount") == null || formInfo.get("chargeAmount").equals("")) {
				formInfo.put("chargeAmount", 0);
			}

			if (formInfo.get("bankAcc") == null || formInfo.get("bankAcc").equals("")) {
				formInfo.put("bankAcc", 0);
			}

			formInfo.put("payItemIsLock", false);
			formInfo.put("payItemIsThirdParty", false);
			formInfo.put("payItemStatusId", 1);
			formInfo.put("isFundTransfer", false);
			formInfo.put("skipRecon", false);
			formInfo.put("payItemCardTypeId", 0);

			formInfo.put("keyInPayRoute", "WEB");
			formInfo.put("keyInScrn", "NOR");
			formInfo.put("amount", totPayAmount);
			formInfo.put("slipNo", slipNo);
			formInfo.put("chqNo", chequeNo); // ADD TO SET CHEQUE NO.
			formInfo.put("bankType", "2729");
			formInfo.put("keyInPayDate", keyInPayDate);

			formInfo.put("bankAcc", selectBankStatementInfo.get("bankAccId"));
			formInfo.put("trDate", selectBankStatementInfo.get("trnscDt"));

			// ONGHC - ADD FOR ONL PAYMENT TYPE
			formInfo.put("payType", payType);
			formInfo.put("userid", sessionVO.getUserId());
			formInfo.put("userId", sessionVO.getUserId());

			/*
			 * update mobPayGroupNo status
			 */
			String[] mobPayGroupNoArr = mobPayGroupNoList.toArray(new String[0]);
			formInfo.put("mobPayGroupNoArr", mobPayGroupNoArr);
			mobileLumpSumPaymentKeyInMapper.updateApproveLumpSumPaymentInfo(formInfo);

			/*
			 * onwards is update pay0349m status && INSERT TO PAY0240T AND PAY0241T
			 */
			Map<String, Object> resultList = commonPaymentService.saveNormalPayment(formInfo, dataList,
					Integer.parseInt(key));
			return resultList;
		}
		return null;
	}

	@Override
	public List<EgovMap> savePaymentCard(Map<String, Object> params, SessionVO sessionVO) {
		List<Object> gridDataList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // GRID DATA IMPORT
		List<Object> gridFormList = (List<Object>) params.get(AppConstants.AUIGRID_FORM); // FORM OBJECT DATA IMPORT

		List<EgovMap> resultList = new ArrayList<EgovMap>();
		String allowance = "0";
		String trRefNo = "";
		String trIssDt = "";
		String crtMemCode = "";

		Map<String, Object> formInfo = null;
		formInfo = new HashMap<String, Object>();
		if (gridFormList.size() > 0) {
			for (Object obj : gridFormList) {
				Map<String, Object> map = (Map<String, Object>) obj;
				formInfo.put((String) map.get("name"), map.get("value"));
			}
		}

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

		// Get all detail record of MobPayGroupNo
		for (int i = 0; i < gridDataList.size(); i++) {
			List<EgovMap> resultReceiptList = new ArrayList<EgovMap>();
			int iProcSeq = 1;
			List<String> mobPayGroupNoList = new ArrayList();
			String payMode = "";
			Map<String, Object> data = new HashMap();
			data = (Map<String, Object>) gridDataList.get(i);

			mobPayGroupNoList.add(data.get("mobPayGroupNo").toString());
			EgovMap detail = mobileLumpSumPaymentKeyInMapper.selectLumpSumPaymentDetail(data);
			String createdMem = detail.get("crtMemCode").toString();
			if (crtMemCode.isEmpty()) {
				crtMemCode = createdMem;
				formInfo.put("memCode", createdMem);
			} else {
				if (!crtMemCode.equals(createdMem)) {
					throw new ApplicationException(AppConstants.FAIL,
							"Selected record is not created by the same Member Code");
				}
			}

			List<EgovMap> subDetails = mobileLumpSumPaymentKeyInMapper.selectLumpSumPaymentSubDetail(data);
			List<Object> formList = new ArrayList<Object>();
			if (subDetails.size() > 0) {
				for (int j = 0; j < subDetails.size(); j++) {
					int currFormSize = formList.size();
					EgovMap orderDetail = subDetails.get(j);

					String salesOrdNo = orderDetail.get("salesOrdNo").toString();
					String salesOrdId = new BigDecimal(orderDetail.get("salesOrdId").toString()).toPlainString();
					Map<String, Object> subInfoParam = new HashMap();
					subInfoParam.put("salesOrdNo", salesOrdNo);
					subInfoParam.put("salesOrdId", salesOrdId);
					subInfoParam.put("orderId", salesOrdId);

					EgovMap orderDetailInfo = mobileLumpSumPaymentKeyInMapper.selectOrderDetailInfo(subInfoParam);
					if (orderDetailInfo != null) {
						subInfoParam.put("appTypeId", Integer.parseInt(orderDetailInfo.get("appTypeId").toString()));

						// Need to do status check to know whether is an outright/membership/AS order
						String paymentType = orderDetail.get("payType").toString();
						// RENTAL PAYMENT, OUTRIGHT PAYMENT, INSTALLMENT PAYMENT, AS PAYMENT
						// RENTAL MEMBERSHIP,OUTRIGHT MEMBERSHIP

						if (paymentType.equals("RENTAL PAYMENT")) {
							formList = rentalPaymentCollection(formInfo, orderDetail, subInfoParam, allowance, trRefNo,
									trIssDt, iProcSeq, formList);
						}
						// need to know if is HT/HA
						if (paymentType.equals("OUTRIGHT PAYMENT") || paymentType.equals("INSTALLMENT PAYMENT")) {
							formList = nonRentalPaymentCollection(formInfo, orderDetail, subInfoParam, allowance, trRefNo,
									trIssDt, iProcSeq, formList);
						}

						if (paymentType.equals("OUTRIGHT MEMBERSHIP")) {
							if (orderDetail.get("srvMemId") != null) {
								subInfoParam.put("srvMemId", orderDetail.get("srvMemId").toString());
							}
							formList = outrightMembershipPaymentCollection(formInfo, orderDetail, subInfoParam, allowance,
									trRefNo, trIssDt, iProcSeq, formList);
						}

						if (paymentType.equals("AS PAYMENT")) {
							formList = asPaymentCollection(formInfo, orderDetail, subInfoParam, allowance, trRefNo,
									trIssDt, iProcSeq, formList);
						}
					}
					iProcSeq = iProcSeq + 1; // 2020.02.24 : ADD iProcSeq

					int afterFormSize = formList.size();
					//This is to check if every order has generated formList out or not
					if (currFormSize == afterFormSize) {
						throw new ApplicationException(AppConstants.FAIL,
								"Error generating receipt for MobPayGroupNo: " + orderDetail.get("mobPayGroupNo").toString()
										+ " due to no payment found for Order No:" + salesOrdNo);
					}
				} // END LOOP

				// APPEND CREDIT CARD INFO PER DETAIL INTO FORMINFO
				formInfo.put("keyInApprovalNo", data.get("keyInApprovalNo"));
				formInfo.put("keyInHolderNm", data.get("keyInHolderNm"));
				formInfo.put("keyInCardNo1", data.get("keyInCardNo1"));
				formInfo.put("keyInCardNo2", data.get("keyInCardNo2"));
				formInfo.put("keyInCardNo3", data.get("keyInCardNo3"));
				formInfo.put("keyInCardNo4", data.get("keyInCardNo4"));
				formInfo.put("keyInCardMode", data.get("keyInCardMode"));
				formInfo.put("keyInCrcType", data.get("keyInCrcType"));
				formInfo.put("keyInIssueBank", data.get("keyInIssueBank"));
				formInfo.put("keyInMerchantBank", data.get("keyInMerchantBank"));
				formInfo.put("keyInTrDate", data.get("keyInTrDate"));
				formInfo.put("keyInExpiryMonth", data.get("keyInExpiryMonth"));
				formInfo.put("keyInExpiryYear", data.get("keyInExpiryYear"));
				formInfo.put("keyInAmount", data.get("keyInAmount"));

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
				formInfo.put("userid", sessionVO.getUserId());
				formInfo.put("userId", sessionVO.getUserId());
				// INSERT TO PAY0240T AND PAY0241T AND LATER EXECUTE SP_INST_NORMAL_PAYMENT
				List<EgovMap> saveResult = commonPaymentService.savePayment(formInfo, formList);
				resultReceiptList.addAll(saveResult);

				String[] mobPayGroupNoArr = mobPayGroupNoList.toArray(new String[0]);
				if (resultReceiptList.size() > 0) {
					formInfo.put("mobPayGroupNoArr", mobPayGroupNoArr);
					mobileLumpSumPaymentKeyInMapper.updateApproveLumpSumPaymentInfo(formInfo);
					resultList.addAll(resultReceiptList);
				} else {
					List<String> result = new ArrayList();
					for (String mobPayGNo : mobPayGroupNoArr) {
						EgovMap info = new EgovMap();
						result.add("LS"  + String.format("%06d", CommonUtils.intNvl(mobPayGNo)));
					}
					throw new ApplicationException(AppConstants.FAIL,
							"Error generating receipt for MobPayGroupNo: " + String.join(",", mobPayGroupNoList));
				}
			}
		}
		return resultList;
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
		List<EgovMap> paymentCollectorConfirm = membershipPaymentService.paymentColleConfirm(subInfoParam);

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
							else{
								//If total remaining is more than target pay and also is last record of the billRental, we overpay it,
								//else just use the target amount
								if(j+1 == billInfoRentalList.size()){
									targetAmt = totRemainAmt;
								}
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
							totRemainAmt = totRemainAmt.subtract(targetAmt);
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
		List<EgovMap> paymentCollectorConfirm = membershipPaymentService.paymentColleConfirm(subInfoParam);

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
        formMap.put("billDt", "1900-01-01");
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

		formList.add(formMap);

		return formList;
	}

	private List<Object> outrightMembershipPaymentCollection(Map<String, Object> params, EgovMap orderDetail,
			Map<String, Object> subInfoParam, String allowance, String trRefNo, String trIssDt, int iProcSeq,
			List<Object> formList) {
		Map<String, Object> formMap = null;
		String salesOrdNo = subInfoParam.get("salesOrdNo").toString();
		String salesOrdId = subInfoParam.get("salesOrdId").toString();

		int srvMemId = Integer.parseInt("".equals(CommonUtils.nvl(String.valueOf(orderDetail.get("srvMemId")))) ? "0"
				: String.valueOf(orderDetail.get("srvMemId")));
		BigDecimal totRemainAmt = new BigDecimal("".equals(CommonUtils.nvl(String.valueOf(orderDetail.get("payAmt"))))
				? "0" : String.valueOf(orderDetail.get("payAmt")));

		EgovMap svmInfo = mobileLumpSumPaymentKeyInMapper.getServiceMembershipDetail(subInfoParam);
		EgovMap psmPay24Info = mobileLumpSumPaymentKeyInMapper.getPay0024D(subInfoParam);

		subInfoParam.put("COLL_MEM_CODE", params.get("memCode"));
 		List<EgovMap> paymentCollectorConfirm = membershipPaymentService.paymentColleConfirm(subInfoParam);

		if (paymentCollectorConfirm.get(0) == null) {
			throw new ApplicationException(AppConstants.FAIL, "No record found for payment collection's member.");
		}

		EgovMap paymentColleConfirmMap = paymentCollectorConfirm.get(0);

		if (new BigDecimal(String.valueOf(svmInfo.get("srvMemPacAmt"))).compareTo(BigDecimal.ZERO) > 0) {
			BigDecimal packageAmt = new BigDecimal(
					"".equals(CommonUtils.nvl(String.valueOf(psmPay24Info.get("packageAmt")))) ? "0"
							: String.valueOf(psmPay24Info.get("packageAmt")));

			if(totRemainAmt.compareTo(BigDecimal.ZERO) > 0 && packageAmt.compareTo(BigDecimal.ZERO) > 0) {
				formMap = new HashMap<String, Object>();
				formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
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
				// formMap.put("allowComm", psmPayInfo.get("allowComm"));

				formList.add(formMap);

				totRemainAmt = totRemainAmt.subtract(packageAmt);
			}
		}

		/*
		 * srvMemBsAmt = total package + filter
		 */
		if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
			if (new BigDecimal(String.valueOf(svmInfo.get("srvMemBsAmt"))).compareTo(BigDecimal.ZERO) > 0) {
				BigDecimal filterAmt = new BigDecimal(
						"".equals(CommonUtils.nvl(String.valueOf(psmPay24Info.get("filterAmt")))) ? "0"
								: String.valueOf(psmPay24Info.get("filterAmt")));
				if(filterAmt.compareTo(BigDecimal.ZERO) > 0){
    					if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
    						formMap = new HashMap<String, Object>();

    						formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
    						formMap.put("appType", "OUT_MEM");
    						formMap.put("advMonth", "0");
    						formMap.put("billGrpId", "0");
    						formMap.put("billId", "0");
    						formMap.put("ordId", salesOrdId);
    						formMap.put("mstRpf", "0");
    						formMap.put("mstRpfPaid", "0");
    						formMap.put("billNo", "0");
    						formMap.put("ordNo", salesOrdNo);
    						formMap.put("billTypeId", "542");
    						formMap.put("billTypeNm", "Filter (1st BS)");
    						formMap.put("installment", "0");
    						formMap.put("billAmt", psmPay24Info.get("filterCharge"));
    						formMap.put("paidAmt", psmPay24Info.get("filterPaid"));
    						formMap.put("targetAmt", psmPay24Info.get("filterAmt"));
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

    						formList.add(formMap);
    				}
				}
			}
		}

		if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
				throw new ApplicationException(AppConstants.FAIL,
						"Overpay amount exist for order no :" + salesOrdNo + ".");
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
		List<EgovMap> paymentCollectorConfirm = membershipPaymentService.paymentColleConfirm(subInfoParam);

		if (paymentCollectorConfirm.get(0) == null) {
			throw new ApplicationException(AppConstants.FAIL, "No record found for payment collection's member.");
		}
		EgovMap paymentColleConfirmMap = paymentCollectorConfirm.get(0);

		Map<String, Object> asBillParam = new HashMap();
		asBillParam.put("billSearchTxt", salesOrdNo);
		asBillParam.put("billType", "1");
		List<EgovMap> asBillResult = commonPaymentService.selectOrderInfoBillPayment(asBillParam);

		if (asBillResult.size() == 0) {
			throw new ApplicationException(AppConstants.FAIL, "No record found for AS Payment of order " + salesOrdNo);
		} else {
			/*
			 * Will have multiple AS Bill in 1 order
			 */
			for (int i = 0; i < asBillResult.size(); i++) {
				EgovMap asDetail = asBillResult.get(i);

				BigDecimal billAmt = new BigDecimal("".equals(CommonUtils.nvl(String.valueOf(asDetail.get("billAmt"))))
						? "0" : String.valueOf(asDetail.get("billAmt")));
				BigDecimal paidAmtAsDetail = new BigDecimal("".equals(CommonUtils.nvl(String.valueOf(asDetail.get("paidAmt"))))
						? "0" : String.valueOf(asDetail.get("paidAmt")));

				if (billAmt.compareTo(paidAmtAsDetail) > 0) {
					if (totRemainAmt.compareTo(billAmt) >= 0) {
						Map<String, Object> formMap = new HashMap<String, Object>();
						formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
						formMap.put("appType", "AS");
						formMap.put("advMonth", 0);
						formMap.put("mstRpf", "0");
						formMap.put("mstRpfPaid", "0");
						formMap.put("assignAmt", 0);
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
					} else {
						throw new ApplicationException(AppConstants.FAIL,
								"Payment Amount for AS Bill is not enough for order no :" + salesOrdNo);
					}
				}
			}
		}

		return formList;
	}

	@Override
	public EgovMap getLumpSumReceiptInfo(Map<String, Object> params){
		EgovMap result = new EgovMap();

		String mobPayGroupNo = params.get("mobPayGroupNo").toString();
		String eTRNo = "LS"  + String.format("%06d", CommonUtils.intNvl(mobPayGroupNo));
		result.put("eTRNo", eTRNo);

		 EgovMap additionalParam = mobileLumpSumPaymentKeyInMapper.getAdditionalEmailDetailInfo(params);
		 result.putAll(additionalParam);

		 List<EgovMap> additionalOrderInfoParam = mobileLumpSumPaymentKeyInMapper.getAdditionalEmailDetailOrderInfo(params);
		    if(additionalOrderInfoParam.size() > 0){
		    	String table ="";
		    	for(int i = 0; i< additionalOrderInfoParam.size(); i++){
			    	table += "<tr><td style='border:1px solid;padding-left:10px;text-align:left'>" + additionalOrderInfoParam.get(i).get("salesOrdNo").toString() + "</td>";
			    	table += "<td style='border:1px solid;padding-left:10px;text-align:left'>" + additionalOrderInfoParam.get(i).get("stkDesc").toString() + "</td>";
			    	table += "<td style='border:1px solid;padding-left:10px;text-align:left'>" + additionalOrderInfoParam.get(i).get("payType").toString() + "</td>";
			    	table += "<td style='border:1px solid;text-align:center;'>" + additionalOrderInfoParam.get(i).get("payAmt").toString() + "</td></tr>";
		    	}
		    	result.put("orderListTableInfo", table);
		    }
		 return result;
	}

	@Override
	public void sendEmail(Map<String, Object> params) {
		EmailVO email = new EmailVO();
		String emailSubject = "COWAY: Mobile Bulk Payment";

		String mobPayGroupNo = params.get("mobPayGroupNo").toString();
		String eTRNo = org.apache.commons.lang.StringUtils.leftPad(mobPayGroupNo, 6,"0");
		params.put("eTRNo", "LS"+eTRNo);

		List<String> emailNo = new ArrayList<String>();

	    Map<String, Object> additionalParam = (Map<String, Object>) mobileLumpSumPaymentKeyInMapper.getAdditionalEmailDetailInfo(params);
	    params.putAll(additionalParam);

	    List<EgovMap> additionalOrderInfoParam = mobileLumpSumPaymentKeyInMapper.getAdditionalEmailDetailOrderInfo(params);

	    if(additionalOrderInfoParam.size() > 0){
	    	String table ="";
	    	for(int i = 0; i< additionalOrderInfoParam.size(); i++){
		    	table += "<tr><td style='border:1px solid;padding-left:10px;text-align:left'>" + additionalOrderInfoParam.get(i).get("salesOrdNo").toString() + "</td>";
		    	table += "<td style='border:1px solid;padding-left:10px;text-align:left'>" + additionalOrderInfoParam.get(i).get("stkDesc").toString() + "</td>";
		    	table += "<td style='border:1px solid;padding-left:10px;text-align:left'>" + additionalOrderInfoParam.get(i).get("payType").toString() + "</td>";
		    	table += "<td style='border:1px solid;text-align:center;'>" + additionalOrderInfoParam.get(i).get("payAmt").toString() + "</td></tr>";
    	}
	    	params.put("orderListTableInfo", table);
	    }

		if (!"".equals(CommonUtils.nvl(params.get("email1")))) {
			emailNo.add(CommonUtils.nvl(params.get("email1")));
		} else if (!"".equals(CommonUtils.nvl(params.get("email2")))) {
			emailNo.add(CommonUtils.nvl(params.get("email2")));
		}

		params.put(EMAIL_SUBJECT, emailSubject);
		params.put(EMAIL_TO, emailNo);

		if (emailNo.size() > 0) {
			email.setTo(emailNo);
			email.setHtml(true);
			email.setSubject(emailSubject);
		    email.setHasInlineImage(true);
			adaptorService.sendEmail(email, false, EmailTemplateType.E_LUMP_SUM_RECEIPT, params);
		}
	}

	@Override
	public void sendSms(Map<String, Object> params) {
		LOGGER.debug("Mobile SMS LS : " + params);
		if (!"".equals(CommonUtils.nvl(params.get("sms1"))) || !"".equals(CommonUtils.nvl(params.get("sms2")))) {
			// Send Message

			LOGGER.debug("Mobile SMS 1 : " + params);
	    	String baseUrl = etrustBaseUrl;
	    	String mobPayGroupNo =  params.get("mobPayGroupNo").toString();
	    	String encryptedString = "";

	    	//creating encryption string for url
	    	try {
	    		encryptedString = encryptionDecryptionService.encrypt(mobPayGroupNo,"lumpsum");

	    	} catch (Exception e) {
	    		// TODO Auto-generated catch block
	    		LOGGER.error("lumpsum sms  encryptedString: =====================>> " + e.toString());
	    		e.printStackTrace();
	    	}
	    	params.put("destinationLink", baseUrl + "/payment/mobileLumpSumPayment/lumpSumReceiptPublic.do?key=" + encryptedString);

			//get tinyUrl link
	    	try{
	    		Map<String,Object> returnParams = new HashMap<String, Object>();
	    		String output1 = "";

	    		URL url = new URL(tinyUrlApi + "/create");
	            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	            conn.disconnect();
	            conn.setDoOutput(true);
	            conn.setRequestMethod("POST");
	            conn.setRequestProperty("Content-Type", "application/json");
	            conn.setRequestProperty("Authorization", "Bearer " + tinyUrlToken);
	            conn.connect();

	            DataOutputStream out = new DataOutputStream(conn.getOutputStream());
	            String jsonString = "{\"url\":\"" + params.get("destinationLink") + "\",\"domain\": \"" + tinyUrlSubDomain + "\"}";
	            out.write(jsonString.getBytes());
	            out.flush();
	            out.close();

	            InputStream inputStream;
	            if (conn.getResponseCode() == 200) {
	                inputStream = conn.getInputStream();
	                returnParams.put("status", AppConstants.SUCCESS);
	                returnParams.put("msg", "");
	            } else {
	                inputStream = conn.getErrorStream();
	                returnParams.put("status", AppConstants.FAIL);
	            }

	            if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
	            	BufferedReader br = new BufferedReader(new InputStreamReader(
	    	                (conn.getInputStream())));

	            	String output = "";
	    	        LOGGER.debug("Output from Server .... \n");
	    	        while ((output = br.readLine()) != null) {
	    	        	output1 = output;
	    	        	LOGGER.debug(output);
	    	        	returnParams.put("msg", output);
	    	        }

	    	        JSONObject obj = new JSONObject(output1);
	            	String tinyUrl = obj.getJSONObject("data").getString("tiny_url");
	            	params.put("tinyUrl", tinyUrl);
	            }

	    		conn.disconnect();
	    	} catch (Exception e) {
	    		// TODO Auto-generated catch block
	    		LOGGER.error("lumpsum sms  encryptedString error: =====================>> " + e.toString());
	    		e.printStackTrace();
	    	} finally {
	    		//Send Message
	    		int userId = Integer.parseInt(params.get("userId").toString());
	    	    SmsVO sms = new SmsVO(userId, 975);
	    	    //totPayAmt
	    	    String smsTemplate = mobileLumpSumPaymentKeyInMapper.getSmsTemplate(params);
	    	    String smsNo = "";

	    	    params.put("smsTemplate", smsTemplate);

	    	    if (!"".equals(CommonUtils.nvl(params.get("sms1")))) {
	    	        smsNo = CommonUtils.nvl(params.get("sms1"));
	    	    }

	            if (!"".equals(CommonUtils.nvl(params.get("sms2")))) {
	                if (!"".equals(CommonUtils.nvl(smsNo))) {
	                	smsNo += "|!|" + CommonUtils.nvl(params.get("sms2"));
	                } else {
	                	smsNo = CommonUtils.nvl(params.get("sms2"));
	                }
	            }

	    	    if (!"".equals(CommonUtils.nvl(smsNo))) {
	    	      sms.setMessage(CommonUtils.nvl(smsTemplate));
	    	      sms.setMobiles(CommonUtils.nvl(smsNo));
	    	      sms.setRemark("SMS LUMP SUM VIA MOBILE APPS");
	    	      sms.setRefNo(CommonUtils.nvl(params.get("mobPayGroupNo")));
	    	      /*
	    	       * CHANGE ON mobPayGroupNo
	    	       * "LS"  + String.format("%06d", CommonUtils.intNvl(mobPayGroupNo))
	    	       */
	    	      SmsResult smsResult = adaptorService.sendSMS(sms);
	    	      LOGGER.debug(" lumpsum sms  smsResult : {}", smsResult.getFailReason().toString());
	    	    }
	    	}
		}
	}

	@Override
	public List<EgovMap> getMobileLumpSumHistory(Map<String, Object> params) {
		EgovMap user = new EgovMap();
		if (params.get("userName") != null) {
			user = mobileLumpSumPaymentKeyInMapper.selectUser(params);
			if (user != null) {
				params.put("userId", user.get("userId"));
			}
		}
		List<EgovMap> resultList = mobileLumpSumPaymentKeyInMapper.getMobileLumpSumHistory(params);
		return resultList;
	}

	@Override
	public List<EgovMap> checkBatchPaymentExist(Map<String, Object> params) {
		List<Object> gridDataList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // GRID DATA IMPORT
		List<EgovMap> resultList = new ArrayList<EgovMap>();
		for (int i = 0; i < gridDataList.size(); i++) {
			Map<String, Object> data = new HashMap();
			data = (Map<String, Object>) gridDataList.get(i);
			EgovMap result = commonPaymentMapper.checkBatchPaymentExist(data);

			if (result != null) {
				resultList.add(result);
			}
		}
		return resultList;
	}

	private <T> Predicate<T> distinctByKey(Function<? super T, Object> keyExtractor) {
		Map<Object, Boolean> map = new ConcurrentHashMap<>();
		return t -> map.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
	}
}
