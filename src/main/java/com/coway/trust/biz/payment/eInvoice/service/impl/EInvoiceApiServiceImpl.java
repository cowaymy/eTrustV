package com.coway.trust.biz.payment.eInvoice.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.billinggroup.service.impl.BillingGroupMapper;
import com.coway.trust.biz.payment.eInvoice.service.EInvoiceApiService;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @ClassName : EInvoiceApiServiceImpl.java
 * @Description : EInvoiceApiServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 2.   KR-HAN        First creation
 * </pre>
 */
@Service("eInvoiceApiService")
public class EInvoiceApiServiceImpl extends EgovAbstractServiceImpl implements EInvoiceApiService {

	@Resource(name = "eInvoiceApiMapper")
	private EInvoiceApiMapper eInvoiceApiMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Autowired
	private LoginMapper loginMapper;

	@Value("${autodebit.email.receiver}")
	private String emailReceiver;

	@Value("${billing.type.confirm.url}")
	private String billingTypeConfirmUrl;

	@Resource(name = "billingGroupMapper")
	private BillingGroupMapper billingGroupMapper;

	// 티켓 서비스
	@Resource(name = "mobileAppTicketApiCommonService")
	private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;

	private static final Logger logger = LoggerFactory.getLogger(EInvoiceApiServiceImpl.class);


	/**
	 * selectBillGroupList
	 * @Author KR-HAN
	 * @Date 2019. 10. 2.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.payment.eInvoice.service.EInvoiceApiService#selectBillGroupList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectBillGroupList(Map<String, Object> params) {
		return eInvoiceApiMapper.selectBillGroupList(params);
	}

	 /**
	 * selectEInvoiceDetail
	 * @Author KR-HAN
	 * @Date 2019. 10. 2.
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectEInvoiceDetail(Map<String, Object> params) {
		return eInvoiceApiMapper.selectEInvoiceDetail(params);
	}

	/**
	 * saveEInvoiceBillType
	 * @Author KR-HAN
	 * @Date 2019. 10. 8.
	 * @param params
	 * @throws Exception
	 * @see com.coway.trust.biz.payment.eInvoice.service.EInvoiceApiService#saveEInvoiceBillType(java.util.Map)
	 */
	@Override
	public void saveEInvoiceBillType(Map<String, Object> params) throws Exception {

		String defaultDate = "1900-01-01";
		params.put("_USER_ID", params.get("userId") );
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);

		int userId = loginVO.getUserId();

		params.put("defaultDate", defaultDate);
		params.put("custBillId", params.get("custId") );

		// master 조회.
		EgovMap selectBasicInfo = billingGroupMapper.selectBasicInfo(params);

		String custBillIsEstm = selectBasicInfo.get("custBillIsEstm") != null
				? String.valueOf(selectBasicInfo.get("custBillIsEstm")) : "";
		String custBillIsSms = selectBasicInfo.get("custBillIsSms") != null
				? String.valueOf(selectBasicInfo.get("custBillIsSms")) : "";
		String custBillIsPost = selectBasicInfo.get("custBillIsPost") != null
				? String.valueOf(selectBasicInfo.get("custBillIsPost")) : "";
		String custBillEmail = selectBasicInfo.get("custBillEmail") != null
				? String.valueOf(selectBasicInfo.get("custBillEmail")) : "";
		String custBillId = selectBasicInfo.get("custBillId") != null
				? String.valueOf(selectBasicInfo.get("custBillId")) : "0";

		// 기존 이력 조회
		List<EgovMap> reqMaster = billingGroupMapper.selectBeforeReqIDs(params);

		if (selectBasicInfo != null && Integer.parseInt(custBillId) > 0) {
			// Ticket 저장
//			List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
//			Map<String, Object> sParams = new HashMap<String, Object>();
//
//			sParams.put("salesOrdNo",  params.get("salesOrdNo"));
//			sParams.put("ticketTypeId", "5673" ); // Request Invoice
//			sParams.put("ticketStusId", "1" );
//			sParams.put("userId", userId );
//
//			arrParams.add(sParams);
//
//			String mobTicketNo = mobileAppTicketApiCommonService.saveMobileAppTicket(arrParams);

			if (reqMaster.size() > 0) {
				for (int i = 0; i < reqMaster.size(); i++) {
					Map<String, Object> map = reqMaster.get(i);
					params.put("reqId", String.valueOf(map.get("reqId")));
					params.put("stusCodeId", 10);
					// REQ마스터테이블 업데이트
					billingGroupMapper.updReqEstm(params);
				}
			}

			// 인서트 셋팅 시작
			String salesOrderIDOld = "0";
			String salesOrderIDNew = "0";
			String contactIDOld = "0";
			String contactIDNew = "0";
			String addressIDOld = "0";
			String addressIDNew = "0";
			String statusIDOld = "0";
			String statusIDNew = "0";
			String remarkOld = "";
			String remarkNew = "";
			String emailOld = custBillEmail;
			String emailNew = String.valueOf(params.get("emailAddr"));
			String addEmailAddr = String.valueOf(params.get("addEmailAddr"));

			String typeId = "1045";
			String isEStatementOld = custBillIsEstm;
			String isEStatementNew = "1";
			String isSMSOld = "0";
			String isSMSNew = "0";
			String isPostOld = custBillIsPost;
			String isPostNew = "0";
			String sysHisRemark = "[System] Change Billing Type";
			String emailAddtionalNew = "";
			String emailAddtionalOld = "";
			String mobileYn = "Y";
			String agreeYn = "Y";
			String custSign = String.valueOf(params.get("signData"));

			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", "");
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);

			insHisMap.put("mobileYn", mobileYn );
			insHisMap.put("agreeYn", agreeYn );
			insHisMap.put("custSign", custSign);

			// 히스토리테이블 인서트
			eInvoiceApiMapper.insInvoiceHistory(insHisMap);

			Map<String, Object> estmMap = new HashMap<String, Object>();
			estmMap.put("stusCodeId", "5");//approve
			estmMap.put("custBillId", String.valueOf(params.get("custBillId")));
			estmMap.put("email", String.valueOf(emailNew).trim());
			estmMap.put("cnfmCode", CommonUtils.getRandomNumber(10));
			estmMap.put("userId", userId);
			estmMap.put("defaultDate", defaultDate);
			estmMap.put("emailFailInd", "0");
			estmMap.put("emailFailDesc", "");
			estmMap.put("emailAdditional", String.valueOf(addEmailAddr).trim());
			// estmReq 인서트
			billingGroupMapper.insEstmReq(estmMap);

			Map<String, Object> custMap = new HashMap<String, Object>();
			custMap.put("custBillIsEstm", "1");
			custMap.put("custBillEmail", emailNew );
			custMap.put("custBillEmailAdd", addEmailAddr );
			custMap.put("chgBillFlag", "Y");
			custMap.put("userId", userId);
			custMap.put("custBillId", String.valueOf(params.get("custId")));

			// 마스터테이블 업데이트
			eInvoiceApiMapper.updCustInvoiceMaster(custMap);

			// E-mail 전송하기
//			EmailVO email = new EmailVO();
//			List<String> toList = new ArrayList<String>();
//
//			String additionalEmail = "";
//			additionalEmail = String.valueOf(addEmailAddr).trim();
//			toList.add(String.valueOf(emailNew));
//			if (!"".equals(additionalEmail)) {
//				toList.add(additionalEmail);
//			}
//
//			email.setTo(toList);
//			email.setHtml(true);
//			email.setSubject("Coway E-Invoice Subscription Confirmation");
//			email.setText("Dear Sir/Madam, <br /><br />"
//					+ "Thank you for registering for 'Go Green Go E-invoice' with Coway. <br /><br />"
//					+ "Your email address have been registered as per below:- <br /><br />" + "Email 1: "
//					+ String.valueOf(emailNew).trim() + "<br />" + "Email 2: " + additionalEmail
//					+ "<br /><br /> "
//					//+ "To complete the registration, please confirm the above email addresses by clicking the link below:- <br /><br />"
//					+
//					// To-Be eTRUST시스템에서는 문구 삭제 요청함
//					// "<a href='" + billingTypeConfirmUrl + "?reqId=" + reqId + "' target='_blank'
//					// style='color:blue;font-weight:bold'>Verify Your Email Here</a><br /><br />" +
//					"Should you have any enquiries, please do not hesitate to contact our toll-free number at 1800 888 111 or email to"
//					+ "<a href='mailto:billing@coway.com.my' target='_top' style='color:blue;font-weight:bold'>billing@coway.com.my</a><br /><br /><br />"
//					+ "Yours faithfully,<br />" + "<b>Coway Malaysia</b>");
//
//			adaptorService.sendEmail(email, false);
		}
	}
}
