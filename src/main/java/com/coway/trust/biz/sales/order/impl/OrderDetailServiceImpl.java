/**
 * 
 */
package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.sales.order.OrderVO;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOMapper;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("orderDetailService")
public class OrderDetailServiceImpl extends EgovAbstractServiceImpl implements OrderDetailService {

	private static final Logger logger = LoggerFactory.getLogger(PSTRequestDOServiceImpl.class);
	
	@Resource(name = "orderDetailMapper")
	private OrderDetailMapper orderDetailMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	public EgovMap getOrderBasicInfo(Map<String, Object> params) {
		
		EgovMap orderDetail = new EgovMap();
		
		//Basic Info
		EgovMap basicInfo        = orderDetailMapper.selectBasicInfo(params);
		EgovMap logView          = orderDetailMapper.selectLatestOrderLogByOrderID(params);
		EgovMap agreementView    = orderDetailMapper.selectOrderAgreementByOrderID(params);
		EgovMap installationInfo = orderDetailMapper.selectOrderInstallationInfoByOrderID(params);
		EgovMap ccpFeedbackCode  = orderDetailMapper.selectOrderCCPFeedbackCodeByOrderID(params);
		EgovMap ccpInfo          = orderDetailMapper.selectOrderCCPInfoByOrderID(params);
		EgovMap salesmanInfo 	 = orderDetailMapper.selectOrderSalesmanViewByOrderID(params);
		EgovMap codyInfo     	 = orderDetailMapper.selectOrderServiceMemberViewByOrderID(params);
		EgovMap mailingInfo 	 = orderDetailMapper.selectOrderMailingInfoByOrderID(params);
		EgovMap rentPaySetInf 	 = orderDetailMapper.selectOrderRentPaySetInfoByOrderID(params);
		
		this.loadBasicInfo(basicInfo);
		this.loadCustInfo(basicInfo);
		this.loadInstallationInfo(installationInfo);
		this.loadMailingInfo(mailingInfo, basicInfo);
		if(rentPaySetInf != null) this.loadRentPaySetInf(rentPaySetInf, basicInfo);

		orderDetail.put("basicInfo",     	basicInfo);
		orderDetail.put("logView",       	logView);
		orderDetail.put("agreementView", 	agreementView);
		orderDetail.put("installationInfo", installationInfo);
		orderDetail.put("ccpFeedbackCode", 	ccpFeedbackCode);
		orderDetail.put("ccpInfo", 			ccpInfo);		
		orderDetail.put("salesmanInfo", 	salesmanInfo);
		orderDetail.put("codyInfo", 		codyInfo);
		orderDetail.put("mailingInfo", 		mailingInfo);
		orderDetail.put("rentPaySetInf", 	rentPaySetInf);
		
		return orderDetail;
	};
		
	private void loadRentPaySetInf(EgovMap rentPaySetInf, EgovMap basicInfo) {
		
		if(!"DD".equals((String)rentPaySetInf.get("rentPayModeCode"))) {
			rentPaySetInf.put("clmDdMode", "-");
		}
		if(((BigDecimal)rentPaySetInf.get("clmLimit")).compareTo(BigDecimal.ZERO) <= 0) {
			rentPaySetInf.put("clmLimit", "-");
		}

		if(CommonUtils.isNotEmpty((String)rentPaySetInf.get("rentPayIssBankCode"))) {
			rentPaySetInf.put("rentPayIssBank", (String)rentPaySetInf.get("rentPayIssBankCode") + " - " +(String)rentPaySetInf.get("rentPayIssBankName"));
		}
		else {
			rentPaySetInf.put("rentPayIssBank", "-");
		}
		
		if(((BigDecimal)rentPaySetInf.get("cardTypeId")).compareTo(BigDecimal.ZERO) <= 0) {
			rentPaySetInf.put("cardType", "-");
		}
		
		if(CommonUtils.isNotEmpty(rentPaySetInf.get("rentPayCrcNo"))) {
			rentPaySetInf.put("rentPayCrcNo", CommonUtils.getMaskCreditCardNo(StringUtils.trim((String)rentPaySetInf.get("rentPayCrcNo")), "*", 6));
		}
		else {
			rentPaySetInf.put("rentPayCrcNo", "-");
		}
		
        if(CommonUtils.isEmpty(rentPaySetInf.get("rentPayCrOwner"))) {
        	rentPaySetInf.put("rentPayCrOwner", "-");
        }

        if(CommonUtils.isEmpty(rentPaySetInf.get("rentPayCrcExpr"))) {
        	rentPaySetInf.put("rentPayCrcExpr", "-");
        }

        if(CommonUtils.isEmpty(rentPaySetInf.get("rentPayAccNo"))) {
        	rentPaySetInf.put("rentPayAccNo", "-");
        }

        if(CommonUtils.isEmpty(rentPaySetInf.get("rentPayAccOwner"))) {
        	rentPaySetInf.put("rentPayAccOwner", "-");
        }

       	rentPaySetInf.put("issuNric", CommonUtils.nvl((String)rentPaySetInf.get("issuNric"), "-"));
	}
	
	private void loadMailingInfo(EgovMap mailingInfo, EgovMap basicInfo) {
		
		String fullAddress = "";
		
		if(CommonUtils.isNotEmpty(mailingInfo.get("mailAdd1"))) {
			fullAddress += mailingInfo.get("mailAdd1") + "<br />";
		}
		if(CommonUtils.isNotEmpty(mailingInfo.get("mailAdd2"))) {
			fullAddress += mailingInfo.get("mailAdd2") + "<br />";
		}
		if(CommonUtils.isNotEmpty(mailingInfo.get("mailAdd3"))) {
			fullAddress += mailingInfo.get("mailAdd3") + "<br />";
		}
		
		mailingInfo.put("fullAddress", fullAddress);
		
		if(!SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode"))) {
			mailingInfo.put("billGrpNo", "-");
		}

	}
	
	private void loadCustInfo(EgovMap basicInfo) {
		
		if(basicInfo != null) {    		
    		if(CommonUtils.isNotEmpty(basicInfo.get("custGender"))) {
    			if("M".equals(StringUtils.trim((String)basicInfo.get("custGender")))) {
    				basicInfo.put("custGender", "Male");
    			}
    			else if("F".equals(StringUtils.trim((String)basicInfo.get("custGender")))) {
    				basicInfo.put("custGender", "Female");
    			}
    		}
		}
		
		if(CommonUtils.isEmpty(basicInfo.get("custPassportExpr")) || SalesConstants.DEFAULT_DATE.equals(basicInfo.get("custPassportExpr"))) {
			basicInfo.put("custPassportExpr", "-");
		}
		
		if(CommonUtils.isEmpty(basicInfo.get("custVisaExpr")) || SalesConstants.DEFAULT_DATE.equals(basicInfo.get("custVisaExpr"))) {
			basicInfo.put("custVisaExpr", "-");
		}
	}
	
	private void loadBasicInfo(EgovMap basicInfo) {
		
		BigDecimal mthRentalFees   = null;
		String installmentDuration = "-";
		String rentalStatus        = "-";
		int obligationYear = 0;
		
		if(SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode"))) {
			mthRentalFees = (BigDecimal)basicInfo.get("ordMthRental");
			rentalStatus  = (String)basicInfo.get("rentalStus");
		}
		else if(SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode")) || SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS.equals(basicInfo.get("appTypeCode"))) {
			obligationYear = (int)basicInfo.get("obligtYear");
		}
		else if(SalesConstants.APP_TYPE_CODE_INSTALLMENT.equals(basicInfo.get("appTypeCode"))) {
			installmentDuration = (String)basicInfo.get("instlmtPriod");
		}

		basicInfo.put("mthRentalFees",       mthRentalFees);
		basicInfo.put("installmentDuration", installmentDuration);
		basicInfo.put("rentalStatus",        rentalStatus);
		basicInfo.put("obligtYear", 		 Integer.valueOf(obligationYear)+ " " + "mth");		
	}
	
	private void loadInstallationInfo(EgovMap installationInfo) {
		
		if(installationInfo != null) {
    		//TODO 날짜비교 로직 추가  
    		if(CommonUtils.isEmpty(installationInfo.get("preferInstDt")) || SalesConstants.DEFAULT_DATE.equals(installationInfo.get("preferInstDt"))) {
    			installationInfo.put("preferInstDt", "-");
    		}
    		else {
    			installationInfo.put("preferInstDt", CommonUtils.changeFormat((String)installationInfo.get("preferInstDt"), SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
    			
    		}
    		
    		if(CommonUtils.isEmpty(installationInfo.get("preferInstTm"))) {
    			installationInfo.put("preferInstTm", "-");
    		}
    		
    		if(CommonUtils.isEmpty(installationInfo.get("firstInstallDt")) || SalesConstants.DEFAULT_DATE.equals(installationInfo.get("firstInstallDt"))) {
    			installationInfo.put("firstInstallDt", "-");
    		}
    		else {
    			installationInfo.put("firstInstallDt", CommonUtils.changeFormat((String)installationInfo.get("firstInstallDt"), SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
    		}
    		
    		if(CommonUtils.isEmpty(installationInfo.get("instCntGender"))) {
    			if("M".equals(StringUtils.trim((String)installationInfo.get("instCntGender")))) {
    				installationInfo.put("instCntGender", "Male");
    			}
    			else if("F".equals(StringUtils.trim((String)installationInfo.get("instCntGender")))) {
    				installationInfo.put("instCntGender", "Female");
    			}
    		}
    		
    		if(CommonUtils.isEmpty(installationInfo.get("updDt")) || SalesConstants.DEFAULT_DATE.equals(installationInfo.get("updDt"))) {
    			installationInfo.put("updDt", "-");
    		}
    		
    		String instct = StringUtils.replace((String)installationInfo.get("instct"), "<", "(");
    		
    		installationInfo.put("instct", instct);
		}
	}
	
	public EgovMap getOrderBasicInfoByOrderID(Map<String, Object> params) {
		return orderDetailMapper.selectBasicInfo(params);
	};
	
	public EgovMap getLatestOrderLogByOrderID(Map<String, Object> params) {
		return orderDetailMapper.selectLatestOrderLogByOrderID(params);
	};
	
	public EgovMap getOrderAgreementByOrderID(Map<String, Object> params) {
		return orderDetailMapper.selectOrderAgreementByOrderID(params);
	};
		
	public EgovMap getOrderInstallationInfoByOrderID(Map<String, Object> params) {
		return orderDetailMapper.selectOrderInstallationInfoByOrderID(params);
	};
		
	public List<EgovMap> getOrderReferralInfoList(Map<String, Object> params) {
		return orderDetailMapper.selectOrderReferralInfoList(params);
	};
	
	public List<EgovMap> getROSCallLogList(Map<String, Object> params) {
		return orderDetailMapper.selectROSCallLogList(params);
	};
	
	public List<EgovMap> getPaymentList(Map<String, Object> params) {
		return orderDetailMapper.selectPaymentList(params);
	};
	
	public List<EgovMap> getAutoDebitResultList(Map<String, Object> params) {
		return orderDetailMapper.selectAutoDebitResultList(params);
	};

	
	@Override
	public List<EgovMap> getSameRentalGrpOrderList(Map<String, Object> params) {
		return orderDetailMapper.selectOrderSameRentalGroupOrderList(params);
	}
	
}
