/**
 *
 */
package com.coway.trust.biz.homecare.sales.impl;


import java.math.BigDecimal;
import java.math.BigInteger;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static java.lang.Math.toIntExact;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.sales.customer.impl.CustomerMapper;
import com.coway.trust.biz.homecare.sales.htOrderRegisterService;
import com.coway.trust.biz.sales.order.vo.AccClaimAdtVO;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.CcpDecisionMVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.EStatementReqVO;
import com.coway.trust.biz.sales.order.vo.GSTEURCertificateVO;
import com.coway.trust.biz.sales.order.vo.InstallEntryVO;
import com.coway.trust.biz.sales.order.vo.InstallResultVO;
import com.coway.trust.biz.sales.order.vo.InstallationVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.homecare.sales.vo.HTOrderVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.RentalSchemeVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderContractVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigFilterVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigPeriodVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigSettingVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigurationVO;
import com.coway.trust.biz.sales.order.vo.SrvMembershipSalesVO;
import com.coway.trust.biz.sales.order.impl.OrderLedgerMapper;
import com.coway.trust.biz.sales.order.impl.PreOrderMapper;
import com.coway.trust.biz.sales.order.vo.ASEntryVO;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Tommy
 *
 */
@Service("htOrderRegisterService")
public class htOrderRegisterServiceImpl extends EgovAbstractServiceImpl implements htOrderRegisterService{

	private static Logger logger = LoggerFactory.getLogger(htOrderRegisterServiceImpl.class);

	@Resource(name = "htOrderRegisterMapper")
	private htOrderRegisterMapper htOrderRegisterMapper;

	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Resource(name = "preOrderMapper")
	private PreOrderMapper preOrderMapper;

	@Resource(name = "orderLedgerMapper")
	private OrderLedgerMapper orderLedgerMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public EgovMap selectSrvCntcInfo(Map<String, Object> params) {

		EgovMap custAddInfo = htOrderRegisterMapper.selectSrvCntcInfo(params);

		return custAddInfo;
	}

	@Override
	public EgovMap selectStockPrice(Map<String, Object> params) {

		EgovMap priceInfo = htOrderRegisterMapper.selectStockPrice(params);

		BigDecimal orderPrice, orderPV, orderRentalFees;

		if(SalesConstants.APP_TYPE_CODE_ID_RENTAL == Integer.parseInt(String.valueOf(params.get("appTypeId")))) {
//			orderPrice      = "₩" + ((BigDecimal)priceInfo.get("rentalDeposit")).toString();
//			orderPV         = "₩" + ((BigDecimal)priceInfo.get("pv")).toString();
//			orderRentalFees = "₩" + ((BigDecimal)priceInfo.get("monthlyRental")).toString();
			orderPrice      = (BigDecimal)priceInfo.get("rentalDeposit");
			orderPV         = (BigDecimal)priceInfo.get("pv");
			orderRentalFees = (BigDecimal)priceInfo.get("monthlyRental");
		}
		else {
//			orderPrice      = "₩" + ((BigDecimal)priceInfo.get("normalPrice")).toString();
//			orderPV         = "₩" + ((BigDecimal)priceInfo.get("pv")).toString();
			orderPrice      = (BigDecimal)priceInfo.get("normalPrice");
			orderPV         = (BigDecimal)priceInfo.get("pv");
			orderRentalFees = BigDecimal.ZERO;
		}

		priceInfo.put("orderPrice", new DecimalFormat("0.00").format(orderPrice));
		priceInfo.put("orderPV", new DecimalFormat("0.00").format(orderPV));
		priceInfo.put("orderRentalFees", new DecimalFormat("0.00").format(orderRentalFees));

		return priceInfo;
	}

	@Override
	public List<EgovMap> selectDocSubmissionList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return htOrderRegisterMapper.selectDocSubmissionList(params);
	}

	@Override
	public List<EgovMap> selectPromotionByAppTypeStock(Map<String, Object> params) {
		// TODO Auto-generated method stub
		logger.info("@@@@@@@@@@@@@@@@@@@@@@:: " + params.toString());
		//params.put("appTypeId", CommonUtils.changePromoAppTypeId(Integer.parseInt((String) params.get("appTypeId"))));

		return htOrderRegisterMapper.selectPromotionByAppTypeStock(params);
	}

	@Override
	public List<EgovMap> selectPromotionByAppTypeStock2(Map<String, Object> params) {
		// TODO Auto-generated method stub

		int apptypeid = Integer.parseInt((String)params.get("appTypeId"));

        if (apptypeid == 144){
	        params.put("appTypeId", apptypeid);

        }
        else{
		    params.put("appTypeId", CommonUtils.changePromoAppTypeId(Integer.parseInt((String) params.get("appTypeId"))));
        }
		return htOrderRegisterMapper.selectPromotionByAppTypeStock2(params);
	}

	@Override
	public EgovMap selectProductPromotionPercentByPromoID(Map<String, Object> params) {

		logger.info("@@@@@@@@@@@@@@@@@@@@@@:: " + params.toString());
		EgovMap promoInfo = null;

		//int srvPacId = Integer.parseInt(String.valueOf(params.get("srvPacId")));

		if(!StringUtils.isEmpty(params.get("promoId"))) {
    		EgovMap promoMap = htOrderRegisterMapper.selectPromoDesc(Integer.parseInt((String)params.get("promoId")));

    		int isNew = CommonUtils.intNvl(promoMap.get("isNew"));

    		if(isNew == 1) {

    			promoInfo = htOrderRegisterMapper.selectProductPromotionPercentByPromoID(params); //AS-IS Data(~2017.12.31)

    			if(promoInfo != null) {

    				BigDecimal promoPrcPrcnt;
    				BigDecimal promoAddDiscPrc;

    				promoPrcPrcnt      = (BigDecimal)promoInfo.get("promoPrcPrcnt");
    				promoAddDiscPrc  = (BigDecimal)promoInfo.get("promoAddDiscPrc");
    				promoInfo.put("promoAddDiscPrc", promoAddDiscPrc);
    				promoInfo.put("promoPrcPrcnt", promoPrcPrcnt);
    				promoInfo.put("promoId", promoInfo.get("promoId"));
    				promoInfo.put("promoCode", promoInfo.get("promoCode"));
    				promoInfo.put("promoDesc", promoInfo.get("promoDesc"));

    			}
    		}
		}

		return promoInfo;
	}

	@Override
	public EgovMap selectOldOrderId(Map<String, Object> params) {
		return htOrderRegisterMapper.selectOldOrderId((String)params.get("salesOrdNo"));
	}

	@Override
	public EgovMap checkOldOrderId(Map<String, Object> params) {

		int getOldOrderID = 0;
		int custId = 0, promoId = 0;
		String ROOT_STATE = "", isInValid = "", msg = "", txtInstSpecialInstruction = "";

		logger.info("!@#### custId:"+(String)params.get("custId"));
		logger.info("!@#### salesOrdNo:"+(String)params.get("salesOrdNo"));

		custId = Integer.parseInt((String)params.get("custId"));
		promoId = Integer.parseInt((String)params.get("promoId"));

		EgovMap RESULT = new EgovMap();
		EgovMap ordInfo = htOrderRegisterMapper.selectOldOrderId((String)params.get("salesOrdNo"));

		if(ordInfo != null) {
			getOldOrderID = CommonUtils.intNvl(Integer.parseInt(String.valueOf(ordInfo.get("salesOrdId"))));
		}

		EgovMap GetExpDate = htOrderRegisterMapper.selectSvcExpire(getOldOrderID);

        if (getOldOrderID <= 0) {
        	ROOT_STATE = "ROOT_1";
        }
        else {
        	if(this.isVerifyOldSalesOrderNoValidity(getOldOrderID)) {

//        		EgovMap resultMap = this.selectSalesOrderM(getOldOrderID, SalesConstants.APP_TYPE_CODE_ID_SERVICE); // 2018-09-13 - Disabled extrade for Education and Free Trial
        		EgovMap resultMap = this.selectSalesOrderM(getOldOrderID, 0);
        		EgovMap promoMap = htOrderRegisterMapper.selectPromoDesc(promoId);

        		String appTypId = "";
        		if(resultMap != null)
        			appTypId = resultMap.get("appTypeId").toString();

            	//if(resultMap != null) { //if(so.VerifyOldSalesOrderNotServiceType(getOldOrderID)
            	if("144".equals(appTypId) || "145".equals(appTypId)) { // 2018-09-13 - Disabled extrade for Education and Free Trial
            		ROOT_STATE = "ROOT_2";
            	}
            	//}
            	else {
            		if(GetExpDate == null) {
                    	ROOT_STATE = "ROOT_3";
            		}
            		else {

            			Calendar calNow = Calendar.getInstance();

            			int nowYear = calNow.YEAR;
            			int nowMonth = calNow.MONTH + 1;
            			int nowDate = calNow.DATE;

            			logger.info("!@#### nowYear :"+nowYear);
            			logger.info("!@#### nowMonth:"+nowMonth);
            			logger.info("!@#### nowDate :"+nowDate);

            			Date srvPrdExprDt = (Date)GetExpDate.get("srvPrdExprDt");

            			Calendar calExt = Calendar.getInstance();

            			calExt.setTime(srvPrdExprDt);

            			int expYear = calExt.YEAR;
            			int expMonth = calExt.MONTH + 1;

            			calExt.add(Calendar.MONTH, -4);

            			msg = "-SVM End Date : <b>" + (String)GetExpDate.get("srvPrdExprDtMmyy") + "</b> <br/>";

              			if(expYear <= nowYear || (expYear == nowYear && (expMonth - 4) <= nowMonth) || (calExt.compareTo(calNow) <= 0)) {
            				logger.debug("@####:not InValid");
            			}
              			else {
              				logger.debug("@####:InValid");

              				isInValid = "InValid";
              			}

              			EgovMap validateRentOutright = this.selectSalesOrderM(getOldOrderID, 0);

              			//Renatal
              			if(SalesConstants.APP_TYPE_CODE_ID_RENTAL == Integer.parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) {

              				if(this.isVerifyOldSalesOrderRentalScheme(getOldOrderID,0)) { //chia chia --18/01/2016 --ex-trade only allow rental status REG || INV || SUS

              					BigDecimal valiOutStanding = (BigDecimal)htOrderRegisterMapper.selectRentAmt(getOldOrderID);
              					valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);

              					if(valiOutStanding.compareTo(BigDecimal.ZERO) > 0) {
                                    msg = msg + " -With Outstanding payment not allowed for Ex-Trade promo. <br/>";
                                    isInValid = "InValid";
              					}

              					EgovMap ValiRentInstNo = htOrderRegisterMapper.selectAccRentLedgers(getOldOrderID);

              					if(Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) < 57) { //Ex-Trade can be done 4 month early
                                    msg = msg + " -Below 57th months not allowed to entitle Ex-Trade Promo. <br/>";
                                    isInValid = "InValid";
              					}

              					if(custId != Integer.parseInt(String.valueOf(validateRentOutright.get("custId")))) {
                                    msg = msg + " -Different Customer is not allowed.";
                                    isInValid = "InValid";
              					}

              					ROOT_STATE = "ROOT_4";

              					txtInstSpecialInstruction = "(Old order No.)" + (String)params.get("salesOrdNo") + " , " + (String)promoMap.get("promoDesc")
              					                        + " , SVM expired : " + (String)GetExpDate.get("srvPrdExprDtMmyy");
              				}
              				else {
              					ROOT_STATE = "ROOT_5";
              				}
              			}
              			else if(SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT == Integer.parseInt(String.valueOf(validateRentOutright.get("appTypeId")))
              					|| SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT == Integer.parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) { //outright,Installment

              				msg = "-SVM End Date : <b>" + (String)GetExpDate.get("srvPrdExprDtMmyy") + "</b>  SVM Expired Date : <b>" + (String)GetExpDate.get("srvPrdExprDtMmyyAdd") + "</b> <br/>";

              				if(custId != Integer.parseInt(String.valueOf(validateRentOutright.get("custId")))) {
                                msg = msg + " -Different Customer is not allowed.";
                                isInValid = "InValid";
              				}

          					ROOT_STATE = "ROOT_6";

          					txtInstSpecialInstruction = "(Old order No.)" + (String)params.get("salesOrdNo") + " , " + (String)promoMap.get("promoDesc")
		                        + " , SVM expired : " + (String)GetExpDate.get("srvPrdExprDtMmyy");
              			}
              			else {
          					ROOT_STATE = "ROOT_7";

          					txtInstSpecialInstruction = "(Old order No.)" + (String)params.get("salesOrdNo") + " , " + (String)promoMap.get("promoDesc")
		                        + " , SVM expired : " + (String)GetExpDate.get("srvPrdExprDtMmyy");

              			}
            		}
            	}
        	}
        	else {
        		ROOT_STATE = "ROOT_8";
        	}
        }

        RESULT.put("ROOT_STATE", ROOT_STATE);
        RESULT.put("IS_IN_VALID", isInValid);
        RESULT.put("MSG", msg);
        RESULT.put("OLD_ORDER_ID", getOldOrderID);
        RESULT.put("INST_SPEC_INST", txtInstSpecialInstruction);


		return RESULT;
	}

	@Override
	public EgovMap checkOldOrderIdICare(Map<String, Object> params) {

		int getOldOrderID = 0;
		int custId = 0, promoId = 0;
		String ROOT_STATE = "", isInValid = "", msg = "", txtInstSpecialInstruction = "";

		logger.info("!@#### custId:"+(String)params.get("custId"));
		logger.info("!@#### salesOrdNo:"+(String)params.get("salesOrdNo"));
		logger.info("!@#### all params :"+(String)params.toString());

		custId = Integer.parseInt((String)params.get("custId"));
		promoId = Integer.parseInt((String)params.get("promoId"));

		EgovMap RESULT = new EgovMap();
		EgovMap ordInfo = htOrderRegisterMapper.selectOldOrderId((String)params.get("salesOrdNo"));

		if(ordInfo != null) {
			getOldOrderID = CommonUtils.intNvl(Integer.parseInt(String.valueOf(ordInfo.get("salesOrdId"))));
		}

        if (getOldOrderID <= 0) {
        	ROOT_STATE = "ROOT_1";
        }
        else {
        	if(this.isVerifyOldSalesOrderNoValidityICare(getOldOrderID)) {

        		EgovMap resultMap = this.selectSalesOrderM(getOldOrderID, 0);
        		EgovMap promoMap = htOrderRegisterMapper.selectPromoDesc(promoId);

        		String appTypId = "";
        		if(resultMap != null)
        			appTypId = resultMap.get("appTypeId").toString();

            	if("144".equals(appTypId) || "145".equals(appTypId)) { // 2018-09-13 - Disabled extrade for Education and Free Trial
            		ROOT_STATE = "ROOT_2";
            	}

            	else {
					EgovMap validateRentOutright = this.selectSalesOrderM(getOldOrderID, 0);

					// Renatal
					if (SalesConstants.APP_TYPE_CODE_ID_RENTAL == Integer
							.parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) {

						if (this.isVerifyOldSalesOrderRentalScheme(getOldOrderID, 1)) { // Kit --ex-trade only allow
																						// rental status REG

							params.put("ordId", getOldOrderID);
							orderLedgerMapper.getOderOutsInfo(params);
							EgovMap map = (EgovMap) ((ArrayList) params.get("p1")).get(0);

							BigDecimal valiOutStanding = new BigDecimal((String) map.get("ordOtstndMth"));
							valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);

							if (valiOutStanding.compareTo(BigDecimal.ZERO) > 2) {
								msg = msg + " -Outstanding payment more than 2 months not allowed for I-Care promo. <br/>";
								isInValid = "InValid";
							}

							EgovMap ValiRentInstNo = htOrderRegisterMapper.selectRentalInstNo(getOldOrderID);

							if(ValiRentInstNo != null){
    							if (Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) <= 6) {
    								msg = msg + " -Below 6th months not allowed to entitle I-Care Promo. <br/>";
    								isInValid = "InValid";
    							} else if (Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) > 60) {
    								msg = msg + " -Above 60th months not allowed to entitle I-Care Promo. <br/>";
    								isInValid = "InValid";
    							}
							}

							if(Integer.parseInt(String.valueOf(validateRentOutright.get("typeId"))) != 964){
								msg = msg + " -Only Individual Customer is allowed.";
								isInValid = "InValid";
							}


							if (custId != Integer.parseInt(String.valueOf(validateRentOutright.get("custId")))) {
								msg = msg + " -Different Customer is not allowed.";
								isInValid = "InValid";
							}

							ROOT_STATE = (isInValid.equals("InValid")) ? "ROOT_9" : "ROOT_7";

							txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
									+ (String) promoMap.get("promoDesc");
						} else {
							ROOT_STATE = "ROOT_5";
						}
					} else if (SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT == Integer.parseInt(String.valueOf(validateRentOutright.get("appTypeId")))
							|| SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT == Integer.parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) { // outright,Installment

						ROOT_STATE = "ROOT_10";
						msg = msg + " -Outright and Installment Order are not eligable for I-Care Programme.<br/>";
						isInValid = "InValid";

					}

					else {
						ROOT_STATE = "ROOT_7";

						txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
								+ (String) promoMap.get("promoDesc");

					}
            	}
        	}
        	else {
        		ROOT_STATE = "ROOT_8";
        	}
        }

        RESULT.put("ROOT_STATE", ROOT_STATE);
        RESULT.put("IS_IN_VALID", isInValid);
        RESULT.put("MSG", msg);
        RESULT.put("OLD_ORDER_ID", getOldOrderID);
        RESULT.put("INST_SPEC_INST", txtInstSpecialInstruction);


		return RESULT;
	}

	private boolean isVerifyOldSalesOrderNoValidity(int getOldOrderID) {
		EgovMap result = htOrderRegisterMapper.selectVerifyOldSalesOrderNoValidity(getOldOrderID);
		return result == null ? true : false;
	}

	private boolean isVerifyOldSalesOrderNoValidityICare(int getOldOrderID) {
		EgovMap result = htOrderRegisterMapper.selectVerifyOldSalesOrderNoValidityICare(getOldOrderID);
		return result == null ? true : false;
	}

	private boolean isVerifyOldSalesOrderRentalScheme(int getOldOrderID,int iCare) {
		Map<String, Object> params = new HashMap<String, Object>();

		params.put("value", getOldOrderID);
		params.put("iCare", iCare);

		EgovMap result = htOrderRegisterMapper.selectSalesOrderRentalScheme(params);
		return result != null ? true : false;
	}

	private EgovMap selectSalesOrderM(int getOldOrderID, int appTypeId) {
		Map<String, Object> params = new HashMap<String, Object>();

		params.put("salesOrdId", getOldOrderID);
		params.put("appTypeId", appTypeId);

		EgovMap result = htOrderRegisterMapper.selectSalesOrderM(params);

		return result;
	}

	@Override
	public EgovMap selectTrialNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return htOrderRegisterMapper.selectTrialNo(params);
	}

	@Override
	public EgovMap selectLoginInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		EgovMap map = new EgovMap();

		map.put("userName", (String)params.get("loginUserName"));
		map.put("userPassWord", (String)params.get("userPassword"));

		return htOrderRegisterMapper.selectLoginInfo(map);
	}

	@Override
	public EgovMap selectCheckAccessRight(Map<String, Object> params, SessionVO sessionVO) {
		return htOrderRegisterMapper.selectCheckAccessRight(params);
	}

	@Override
	public EgovMap selectMemberByMemberIDCode(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return htOrderRegisterMapper.selectMemberByMemberIDCode(params);
	}

	@Override
	public List<EgovMap> selectMemberList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("stus", 1);
		return htOrderRegisterMapper.selectMemberList(params);
	}

	private void preprocSalesOrderMaster(SalesOrderMVO salesOrderMVO, SessionVO sessionVO) {

		salesOrderMVO.setSalesOrdId(0);
		salesOrderMVO.setSalesOrdNo("");
		salesOrderMVO.setBrnchId(sessionVO.getUserBranchId());
		salesOrderMVO.setDscntAmt(BigDecimal.ZERO);
		salesOrderMVO.setTaxAmt(BigDecimal.ZERO);
		salesOrderMVO.setCcPromoId(0);
		salesOrderMVO.setPromoId(salesOrderMVO.getPromoId());
		salesOrderMVO.setPvMonth(0);
		salesOrderMVO.setPvYear(0);
		salesOrderMVO.setStusCodeId(salesOrderMVO.getAppTypeId() == 143 ? 4 : 1);
		salesOrderMVO.setUpdUserId(sessionVO.getUserId());
        salesOrderMVO.setSyncChk(0);
        salesOrderMVO.setRenChkId(salesOrderMVO.getAppTypeId() == 66 ? 122 : 0);
        salesOrderMVO.setInstPriod(salesOrderMVO.getAppTypeId() == 68 ? salesOrderMVO.getInstPriod() : 0);
        salesOrderMVO.setDoNo("");
        salesOrderMVO.setSalesOrdIdOld(salesOrderMVO.getSalesOrdIdOld());
        salesOrderMVO.setEditTypeId(0);
        salesOrderMVO.setMthRentAmt(salesOrderMVO.getAppTypeId() == 66 ? salesOrderMVO.getMthRentAmt() : BigDecimal.ZERO);
        salesOrderMVO.setLok(0);
        salesOrderMVO.setAeonStusId(0);
        salesOrderMVO.setCommDt(SalesConstants.DEFAULT_DATE2);
        salesOrderMVO.setCrtUserId(sessionVO.getUserId());
        salesOrderMVO.setPayComDt(SalesConstants.DEFAULT_DATE2);
        salesOrderMVO.setRefDocId(0);
        salesOrderMVO.setRentPromoId(0);
	}

	private void preprocSalesOrderDetails(SalesOrderDVO salesOrderDVO, SessionVO sessionVO) {

		salesOrderDVO.setSalesOrdId(0);
		salesOrderDVO.setItmNo(1);
//		salesOrderDVO.ItemStkID = int.Parse(cmbOrderProduct.SelectedValue);
//		salesOrderDVO.ItemPriceID = int.Parse(hiddenOrderPriceID.Value);
		salesOrderDVO.setItmQty(1);
//		salesOrderDVO.setItmTax(0);
		salesOrderDVO.setItmDscnt(0);
//		salesOrderDVO.ItemPrice = double.Parse(txtOrderPrice.Text.Trim());
//		salesOrderDVO.ItemPV = double.Parse(txtOrderPV.Text.Trim());
		salesOrderDVO.setStusCodeId(1);
		salesOrderDVO.setUpdUserId(sessionVO.getUserId());
		salesOrderDVO.setEditTypeId(0);
		salesOrderDVO.setItmId(0);
		salesOrderDVO.setItmCallEntryId(0);
	}

	private String convert24Tm(String TM) {
		String ampm = "", HH = "", MI = "", cvtTM = "";

		if(CommonUtils.isNotEmpty(TM)) {
			ampm = CommonUtils.right(TM, 2);
			HH = CommonUtils.left(TM, 2);
			MI = TM.substring(3, 5);

			if("PM".equals(ampm)) {
				cvtTM = String.valueOf(Integer.parseInt(HH) + 12) + ":" + MI + ":00";
			}
			else  {
				cvtTM = HH + ":" + MI + ":00";
			}
		}
		return cvtTM;
	}

	private void preprocInstallationMaster(InstallationVO installationVO, SessionVO sessionVO) {

		logger.info("!@###### preprocInstallationMaster START ");

		installationVO.setInstallId(0);
		installationVO.setSalesOrdId(0);
		installationVO.setPreTm(this.convert24Tm(installationVO.getPreTm()));
		installationVO.setActDt(SalesConstants.DEFAULT_DATE2);
		installationVO.setActTm(SalesConstants.DEFAULT_TM);
		installationVO.setStusCodeId(1);
		installationVO.setUpdUserId(sessionVO.getUserId());
		installationVO.setEditTypeId(0);
		installationVO.setInstallId(0);
/*
		installationMaster.InstalltionID = 0;
        installationMaster.SalesOrderID = 0;
        installationMaster.AddID = int.Parse(txtHiddenInstAddressID.Text.Trim());
        installationMaster.CntID = int.Parse(txtHiddenInstContactID.Text.Trim());
        installationMaster.PreCallDate = PreInstDate.AddDays(-1);
        installationMaster.PreDate = PreInstDate;
        installationMaster.PreTime = tpPreferInstTime.SelectedTime;
        installationMaster.ActDate = defaultDate;
        installationMaster.ActTime = defaultTime;
        installationMaster.StatusCodeID = 1;
        installationMaster.Instruction = txtInstSpecialInstruction.Text.Trim();
        installationMaster.Updated = DateTime.Now;
        installationMaster.Updator = li.UserID;
        installationMaster.BranchID = int.Parse(cmbDSCBranch.SelectedValue);
        installationMaster.EditTypeID = 0;
        installationMaster.IsTradeIn = false;
*/
	}

	private void preprocRentPaySetMaster(RentPaySetVO rentPaySetVO, SessionVO sessionVO) {

		logger.info("!@###### preprocRentPaySetMaster START ");

		rentPaySetVO.setRentPayId(0);
		rentPaySetVO.setSalesOrdId(0);
		rentPaySetVO.setFailResnId(0);
		rentPaySetVO.setUpdUserId(sessionVO.getUserId());
		rentPaySetVO.setStusCodeId(1);
		rentPaySetVO.setEditTypeId(0);
		rentPaySetVO.setAeonCnvr(0);
		rentPaySetVO.setRem("");
		rentPaySetVO.setLastApplyUser(sessionVO.getUserId());
		rentPaySetVO.setPayTrm(0);

/*
        rentPaySetMaster.RentPayID = 0;
        rentPaySetMaster.SalesOrderID = 0;
        rentPaySetMaster.ModeID = int.Parse(cmbRentPaymode.SelectedValue);
        rentPaySetMaster.CustCRCID = int.Parse(cmbRentPaymode.SelectedValue) == 131 ? int.Parse(txtHiddenRentPayCRCID.Text.Trim()) : 0;
        rentPaySetMaster.CustAccID = int.Parse(cmbRentPaymode.SelectedValue) == 132 ? int.Parse(txtHiddenRentPayBankAccID.Text.Trim()) : 0;
        rentPaySetMaster.BankID = int.Parse(cmbRentPaymode.SelectedValue) == 131 ? int.Parse(hiddenRentPayCRCBankID.Value) :
            int.Parse(cmbRentPaymode.SelectedValue) == 132 ? int.Parse(hiddenRentPayBankAccBankID.Value) : 0;
        rentPaySetMaster.DDApplyDate = DateTime.Now;
        rentPaySetMaster.DDSubmitDate = defaultDate;
        rentPaySetMaster.DDStartDate = defaultDate;
        rentPaySetMaster.DDRejectDate = defaultDate;
        rentPaySetMaster.FailReasonID = 0;
        rentPaySetMaster.Updated = DateTime.Now;
        rentPaySetMaster.Updator = li.UserID;
        rentPaySetMaster.StatusCodeID = 1;
        rentPaySetMaster.Is3rdParty = btnThirdParty.Checked ? true : false;
        rentPaySetMaster.CustomerID = btnThirdParty.Checked ? int.Parse(txtHiddenThirdPartyID.Text.Trim()) : int.Parse(txtHiddenCustID.Text.Trim());
        rentPaySetMaster.EditTypeID = 0;
        rentPaySetMaster.NRICOld = txtRentPayIC.Text.Trim();
        rentPaySetMaster.IssuedNRIC = (!string.IsNullOrEmpty(txtRentPayIC.Text.Trim())) ? txtRentPayIC.Text.Trim() : btnThirdParty.Checked ? txtThirdPartyNRIC.Text.Trim() : txtCustIC.Text.Trim();
        rentPaySetMaster.AeonConvert = false;
        rentPaySetMaster.Remark = "";
        rentPaySetMaster.LastApplyUser = li.UserID;
        rentPaySetMaster.PayTerm = 0;
 */
	}

	private void preprocCustomerBillMaster(CustBillMasterVO custBillMasterVO, SessionVO sessionVO) {

		custBillMasterVO.setCustBillId(0);;
		custBillMasterVO.setCustBillSoId(0);
		custBillMasterVO.setCustBillStusId(SalesConstants.STATUS_ACTIVE);
		custBillMasterVO.setCustBillUpdUserId(sessionVO.getUserId());
		custBillMasterVO.setCustBillGrpNo("");
		custBillMasterVO.setCustBillCrtUserId(sessionVO.getUserId());
		custBillMasterVO.setCustBillPayTrm(0);
		custBillMasterVO.setCustBillInchgMemId(0);
		custBillMasterVO.setCustBillIsEstm(0);

/*
		customerBillMaster.CustBillID = 0;
        customerBillMaster.CustBillSOID = 0;
        customerBillMaster.CustBillCustID = int.Parse(txtHiddenCustID.Text.Trim());
        customerBillMaster.CustBillCntID = int.Parse(txtHiddenContactID.Text.Trim());
        customerBillMaster.CustBillAddID = int.Parse(txtHiddenAddressID.Text.Trim());
        customerBillMaster.CustBillStatusID = 1;
        customerBillMaster.CustBillRemark = txtBillGroupRemark.Text.Trim();
        customerBillMaster.CustBillUpdateAt = DateTime.Now;
        customerBillMaster.CustBillUpdateBy = li.UserID;
        customerBillMaster.CustBillGrpNo = "";
        customerBillMaster.CustBillCreateAt = DateTime.Now;
        customerBillMaster.CustBillCreateBy = li.UserID;
        customerBillMaster.CustBillPayTerm = 0;
        customerBillMaster.CustBillInchargeMemID = 0;
        customerBillMaster.CustBillEmail = txtBillGroupEmail_1.Text.Trim();
        customerBillMaster.CustBillIsEstatement = false;
        customerBillMaster.CustBillIsSMS = btnBillGroupSMS_1.Checked == true ? true : false;
        customerBillMaster.CustBillIsSMS_2 = btnBillGroupSMS_2.Checked == true ? true : false;
        customerBillMaster.CustBillIsPost = btnBillGroupPost.Checked == true ? true : false;
        customerBillMaster.CustBillEmail_Addtional = txtBillGroupEmail_2.Text.Trim();
        customerBillMaster.CustBillCustCareCntID = null;
        customerBillMaster.CustBillIsWebPortal = btnBillGroupWebPortal.Checked == true ? true : false;
        customerBillMaster.CustBillWebPortalUrl = txtBillGroupWebAddress.Text.Trim();
        customerBillMaster.CustBillCustCareCntID = string.IsNullOrEmpty(txtHiddenBPCareID.Text) ? 0 : int.Parse(txtHiddenBPCareID.Text.Trim());
*/
	}

	private void preprocRentalSchemeMaster(RentalSchemeVO rentalSchemeVO, SessionVO sessionVO) {

		logger.info("!@###### preprocRentalSchemeMaster START ");

		rentalSchemeVO.setRenSchId(0);
		rentalSchemeVO.setSalesOrdId(0);
		rentalSchemeVO.setStusCodeId(SalesConstants.STATUS_CODE_NAME_ACT);
		rentalSchemeVO.setRenSchTerms(0);
		rentalSchemeVO.setIsSync(0);
/*
        rentalSchemeMaster.RenSchID = 0;
        rentalSchemeMaster.SalesOrderID = 0;
        rentalSchemeMaster.StatusCodeID = "ACT";
        rentalSchemeMaster.RenSchDate = DateTime.Now;
        rentalSchemeMaster.RenSchTerms = 0;
        rentalSchemeMaster.IsSync = false;
*/
	}

	private void preprocClaimAdtMaster(AccClaimAdtVO accClaimAdtVO, RentPaySetVO rentPaySetVO, SessionVO sessionVO) {

		logger.info("!@###### preprocRentalSchemeMaster START ");

		int issueBankId = rentPaySetVO.getBankId();

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bankId", issueBankId);
		EgovMap bankInfo = null;

		if(issueBankId > 0) {
			bankInfo = htOrderRegisterMapper.selectBankById(params);
		}

		accClaimAdtVO.setAccClSoId(0);
		accClaimAdtVO.setAccClSvcCntrctId(0); //TODO 소스상에 없음. 확인필요
		accClaimAdtVO.setAccClPromo(0);
		accClaimAdtVO.setAccClBankCode(bankInfo != null ? (String)bankInfo.get("code") : "");
		accClaimAdtVO.setAccDecBankAccNo("");
		accClaimAdtVO.setAccClReqstMCode("");
		accClaimAdtVO.setAccClRejctId("");
		accClaimAdtVO.setAccClStusId(SalesConstants.STATUS_CODE_NAME_ACT);
		accClaimAdtVO.setAccClUpdUserId(sessionVO.getUserId());
		accClaimAdtVO.setAccClPromoChkId("0");
		accClaimAdtVO.setAccClSplClmAmt(BigDecimal.ZERO);
		accClaimAdtVO.setAccClSoNo("");
		accClaimAdtVO.setAccClUserName(sessionVO.getUserName());
		accClaimAdtVO.setAccClBankId(issueBankId);
		accClaimAdtVO.setAccClClmLimit(0);
		accClaimAdtVO.setAccClBillDt(5);
/*
        claimAdtMaster.AccCLSOID = 0;
        claimAdtMaster.AccCLBillClaimAmt = double.Parse(txtOrderRentalFees.Text.Trim());
        claimAdtMaster.AccCLClaimAmt = double.Parse(txtOrderRentalFees.Text.Trim());
        claimAdtMaster.AccCLPromo = 0;
        claimAdtMaster.AccCLBankCode = bankInfo.Code != null ? bankInfo.Code : "";
        claimAdtMaster.AccCLBankAccNo = AccNo;
        claimAdtMaster.AccDecBankAccNo = "";
        claimAdtMaster.AccCLRequestMcode = "";
        claimAdtMaster.AccCLApplyDate = DateTime.Now;
        claimAdtMaster.AccCLSubMitDate = defaultDate;
        claimAdtMaster.AccCLApproveDate = defaultDate;
        claimAdtMaster.AccCLRejectDate = defaultDate;
        claimAdtMaster.AccCLRejectID = "";
        claimAdtMaster.AccCLStatusID = "ACT";
        claimAdtMaster.AccCLUpdateAt = DateTime.Now;
        claimAdtMaster.AccCLUpdateBy = li.UserID;
        claimAdtMaster.AccCLPromoCheckID = "0";
        claimAdtMaster.AccCLPromoStartDate = defaultDate;
        claimAdtMaster.AccCLAcctName = AccName;
        claimAdtMaster.AccCLAccNRIC = (!string.IsNullOrEmpty(txtRentPayIC.Text.Trim())) ? txtRentPayIC.Text.Trim() : btnThirdParty.Checked ? txtThirdPartyNRIC.Text.Trim() : txtCustIC.Text.Trim();
        claimAdtMaster.AccCLSpLClaimamt = 0;
        claimAdtMaster.AccCLSOno = "";
        claimAdtMaster.AccCLUserName = li.LoginID;
        claimAdtMaster.AccCLPayMode = AdtPayMode;
        claimAdtMaster.AccCLPayModeID = int.Parse(cmbRentPaymode.SelectedValue);
        claimAdtMaster.AccCLBankID = IssueBankID;
        claimAdtMaster.AccCLClaimLimit = 0;
        claimAdtMaster.AccClBillDate = 5;
        claimAdtMaster.AccCLInsertDate = DateTime.Now;
*/
	}

	private void preprocEStatementRequest(EStatementReqVO eStatementReqVO, SessionVO sessionVO) {

		logger.info("!@###### preprocEStatementRequest START ");

		eStatementReqVO.setReqId(0);
		eStatementReqVO.setStusCodeId(5);
		eStatementReqVO.setCustBillId(0);
		eStatementReqVO.setCnfmCode(CommonUtils.getRandomNumber(10));
		eStatementReqVO.setCrtUserId(sessionVO.getUserId());
		eStatementReqVO.setUpdUserId(sessionVO.getUserId());
		eStatementReqVO.setEmailFailInd(0);
		eStatementReqVO.setEmailFailDesc("");
		eStatementReqVO.setRefNo("");

/*
        EStatementRequest.ReqID = 0;
        EStatementRequest.StatusCodeID = 5;
        EStatementRequest.CustBillID = 0; //Update later
        EStatementRequest.Email = txtBillGroupEmail_1.Text.Trim();
        EStatementRequest.EmailAdditional = txtBillGroupEmail_2.Text.Trim();
        EStatementRequest.ConfirmCode = CommonFunction.GetRandomNumber(10);
        EStatementRequest.Created = DateTime.Now;
        EStatementRequest.Creator = li.UserID;
        EStatementRequest.ConfirmDate = DateTime.Now;
        EStatementRequest.Updated = DateTime.Now;
        EStatementRequest.Updator = li.UserID;
        EStatementRequest.EmailFailInd = false;
        EStatementRequest.EmailFailDesc = "";
        EStatementRequest.RefNo = ""; //Update later
*/
	}

	private void preprocCcpMaster(CcpDecisionMVO ccpDecisionMVO, int custTypeId, int custRaceId, SessionVO sessionVO) {

		logger.info("!@###### preprocCcpMaster START ");

        int statusId = 1, ccpSchemeTypeId;
        String remark = "";

        if(custTypeId == SalesConstants.CUST_TYPE_CODE_ID_IND && custRaceId == 14) {
            // KOREAN --> PASSED CCP
        	statusId = 5;
        	remark = "CCP Korean bypass.";
        }

        ccpSchemeTypeId = custTypeId == SalesConstants.CUST_TYPE_CODE_ID_IND ? SalesConstants.CCP_SCHEME_TYPE_CODE_ID_ICS : SalesConstants.CCP_SCHEME_TYPE_CODE_ID_CCS;

        ccpDecisionMVO.setCcpId(5);
        ccpDecisionMVO.setCcpSalesOrdId(0);
        ccpDecisionMVO.setCcpSchemeTypeId(ccpSchemeTypeId);
        ccpDecisionMVO.setCcpTypeId(972);
        ccpDecisionMVO.setCcpIncomeRangeId(0);
        ccpDecisionMVO.setCcpTotScrePoint(BigDecimal.ZERO);
        ccpDecisionMVO.setCcpStusId(statusId);
        ccpDecisionMVO.setCcpResnId(0);
        ccpDecisionMVO.setCcpRem(remark);
        ccpDecisionMVO.setCcpRjStusId(0);
        ccpDecisionMVO.setCcpUpdUserId(sessionVO.getUserId());
        ccpDecisionMVO.setCcpIsLou(SalesConstants.IS_FALSE);
        ccpDecisionMVO.setCcpIsSaman(SalesConstants.IS_FALSE);
        ccpDecisionMVO.setCcpIsSync(SalesConstants.IS_FALSE);
        ccpDecisionMVO.setCcpPncRem("");
        ccpDecisionMVO.setCcpHasGrnt(SalesConstants.IS_FALSE);
        ccpDecisionMVO.setCcpIsHold(SalesConstants.IS_FALSE);

/*
        CcpMaster.CcpID = 0;
        CcpMaster.CcpSalesOrderID = 0;
        CcpMaster.CcpSchemeTypeID = int.Parse(hiddenCustTypeID.Value) == 964 ? 969 : 970;
        CcpMaster.CcpTypeID = 972;
        CcpMaster.CcpIncomeRangeID = 0;
        CcpMaster.CcpTotalScorePoint = 0;
        CcpMaster.CcpStatusID = StatusID;
        CcpMaster.CcpReasonID = 0;
        CcpMaster.CcpRemark = Remark;
        CcpMaster.CcpRjStatusID = 0;
        CcpMaster.CcpUpdateAt = DateTime.Now;
        CcpMaster.CcpUpdateBy = li.UserID;
        CcpMaster.CcpIsLOU = false;
        CcpMaster.CcpIsSaman = false;
        CcpMaster.CcpIsSync = false;
        CcpMaster.CcpPNCRemark = "";
        CcpMaster.CcpHasGuarantee = false;
        CcpMaster.CcpIshold = false;
*/
	}

	private void preprocSalesOrderContract(SalesOrderContractVO salesOrderContractVO, SalesOrderMVO salesOrderMVO, SessionVO sessionVO) {

		logger.info("!@###### preprocSalesOrderContract START ");

		EgovMap inMap = new EgovMap();

		inMap.put("srvCntrctPacId", salesOrderMVO.getSrvPacId());

		EgovMap outMap = htOrderRegisterMapper.selectServiceContractPackage(inMap);

        salesOrderContractVO.setCntrctId(0);
        salesOrderContractVO.setCntrctSalesOrdId(0);
//      salesOrderContractVO.setCntrctRentalPriod(60);
//      salesOrderContractVO.setCntrctObligtPriod(36);
        salesOrderContractVO.setCntrctRentalPriod(CommonUtils.intNvl(outMap.get("srvCntrctPacDur")));
        salesOrderContractVO.setCntrctObligtPriod(CommonUtils.intNvl(outMap.get("obligtPriod")));
        salesOrderContractVO.setCntrctStusId(SalesConstants.STATUS_ACTIVE);
        salesOrderContractVO.setCntrctRem("");
        salesOrderContractVO.setCntrctCrtUserId(sessionVO.getUserId());
        salesOrderContractVO.setCntrctUpdUserId(sessionVO.getUserId());
/*
        salesOrderContract.ContractID = 0;
        salesOrderContract.ContractSalesOrderID = 0;
        salesOrderContract.ContractRentalPeriod = 60;
        salesOrderContract.ContractObligationPeriod = obligationPeriod;
        salesOrderContract.ContractStatusID = 1;
        salesOrderContract.ContractRemark = "";
        salesOrderContract.ContractCreated = DateTime.Now;
        salesOrderContract.ContractCreator = li.UserID;
        salesOrderContract.ContractUpdated = DateTime.Now;
        salesOrderContract.ContractUpdator = li.UserID;
*/
	}

	private void preprocDocumentList(List<DocSubmissionVO> updateDocList, SessionVO sessionVO) {

		logger.info("!@###### preprocDocumentList START ");

		for(int i = updateDocList.size() - 1; i >= 0; i--) {

			DocSubmissionVO docVO = updateDocList.get(i);

			if(docVO.getChkfield() == 1) {
    			docVO.setDocSubId(0);
    			docVO.setDocSubTypeId(SalesConstants.CCP_DOC_SUB_CODE_ID_ICS);
    			docVO.setDocTypeId(docVO.getCodeId());
    			docVO.setDocSoId(0);
    			docVO.setDocMemId(0);
    			docVO.setDocCopyQty(1);
    			docVO.setStusId(1);
    			docVO.setCrtUserId(sessionVO.getUserId());
    			docVO.setUpdUserId(sessionVO.getUserId());
    			docVO.setDocSubBatchId(0);
			}
			else {
				updateDocList.remove(i);
			}
		}
	}

	private void preprocCallEntryMaster(CallEntryVO callEntryVO, int orderAppType, String installDate, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocCallEntryMaster START ");

        int statusCodeId = 1;
        //DateTime CallDate = ((DateTime)dpPreferInstDate.SelectedDate).AddDays(-1);
        String callDate = installDate;
        logger.debug("@#### callDate:"+callDate);
        //APP TYPE = SERVICES
        if(orderAppType == SalesConstants.APP_TYPE_CODE_ID_SERVICE) {
        	statusCodeId = 20;
        }
        else {
        	callDate = CommonUtils.getAddDay(callDate, -1, SalesConstants.DEFAULT_DATE_FORMAT1);
        }

        logger.debug("@#### callDate2:"+callDate);

//      callDate = CommonUtils.changeFormat(callDate, SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2);

        callEntryVO.setCallEntryId(0);
        callEntryVO.setSalesOrdId(0);
        callEntryVO.setTypeId(257);
        callEntryVO.setStusCodeId(statusCodeId);
        callEntryVO.setResultId(0);
        callEntryVO.setDocId(0);
        callEntryVO.setCrtUserId(sessionVO.getUserId());
        callEntryVO.setCallDt(callDate);
        callEntryVO.setIsWaitForCancl(SalesConstants.IS_FALSE);
        callEntryVO.setHapyCallerId(0);
        callEntryVO.setUpdUserId(sessionVO.getUserId());
        callEntryVO.setOriCallDt(callDate);

/*
        callEntryMaster.CallEntryID = 0;
        callEntryMaster.SalesOrderID = 0;
        callEntryMaster.TypeID = 257;
        callEntryMaster.StatusCodeID = StatusCodeID;
        callEntryMaster.ResultID = 0;
        callEntryMaster.DocID = 0;
        callEntryMaster.Created = DateTime.Now;
        callEntryMaster.Creator = li.UserID;
        callEntryMaster.CallDate = CallDate;
        callEntryMaster.IsWaitForCancel = false;
        callEntryMaster.HappyCallerID = 0;
        callEntryMaster.Updated = DateTime.Now;
        callEntryMaster.Updator = li.UserID;
        callEntryMaster.OriCallDate = CallDate;
*/
	}

	private void preprocCallResultDetails(CallResultVO callResultVO, String dInstallDate, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocCallResultDetails START ");

		callResultVO.setCallResultId(0);
		callResultVO.setCallEntryId(0);
		callResultVO.setCallStusId(20);
		callResultVO.setCallActnDt(dInstallDate);
		callResultVO.setCallFdbckId(0);
		callResultVO.setCallCtId(0);
		callResultVO.setCallRem("");
		callResultVO.setCallCrtUserId(sessionVO.getUserId());
		callResultVO.setCallCrtUserIdDept(0);
		callResultVO.setCallHcId(0);
		callResultVO.setCallRosAmt(BigDecimal.ZERO);
		callResultVO.setCallSms(SalesConstants.IS_FALSE);
		callResultVO.setCallSmsRem("");
/*
        CallResultDetails.CallResultID = 0;
        CallResultDetails.CallEntryID = 0;
        CallResultDetails.CallStatusID = 20;
        CallResultDetails.CallCallDate = CallDate;
        CallResultDetails.CallActionDate = CallDate;
        CallResultDetails.CallFeedBackID = 0;
        CallResultDetails.CallCTID = 0;
        CallResultDetails.CallRemark = "";
        CallResultDetails.CallCreateBy = li.UserID;
        CallResultDetails.CallCreateAt = DateTime.Now;
        CallResultDetails.CallCreateByDept = 0;
        CallResultDetails.CallHCID = 0;
        CallResultDetails.CallROSAmt = 0;
        CallResultDetails.CallSMS = false;
        CallResultDetails.CallSMSRemark = "";
*/
	}

	private void preprocInstallEntryMaster(InstallEntryVO installEntryVO, String dInstallDate, int itmStkId, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocInstallEntryMaster START ");

		installEntryVO.setInstallEntryId(0);
		installEntryVO.setInstallEntryNo("");
		installEntryVO.setSalesOrdId(0);
		installEntryVO.setStusCodeId(4);
		installEntryVO.setCtId(0);
		installEntryVO.setInstallDt(dInstallDate);
		installEntryVO.setCallEntryId(0);
		installEntryVO.setInstallStkId(itmStkId);
		installEntryVO.setInstallResultId(0);
		installEntryVO.setCrtUserId(sessionVO.getUserId());
		installEntryVO.setAllowComm(SalesConstants.IS_FALSE);
		installEntryVO.setUpdUserId(sessionVO.getUserId());
		installEntryVO.setRevId(0);
/*
        InstallEntryMaster.InstallEntryID = 0;
        InstallEntryMaster.InstallEntryNo = "";
        InstallEntryMaster.SalesOrderID = 0;
        InstallEntryMaster.StatusCodeID =4;
        InstallEntryMaster.CTID = 0;
        InstallEntryMaster.InstallDate = InstallDate;
        InstallEntryMaster.CallEntryID = 0;
        InstallEntryMaster.InstallStkID = int.Parse(cmbOrderProduct.SelectedValue);
        InstallEntryMaster.InstallResultID = 0;
        InstallEntryMaster.Created = DateTime.Now;
        InstallEntryMaster.Creator = li.UserID;
        InstallEntryMaster.AllowComm = false;
        InstallEntryMaster.IsTradeIn = false;
        InstallEntryMaster.CTGroup = "";
        InstallEntryMaster.Updated = DateTime.Now;
        InstallEntryMaster.Updator = li.UserID;
        InstallEntryMaster.RevID = 0;
*/
	}

	private void preprocInstallResultDetails(InstallResultVO installResultVO, String dInstallDate, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocInstallResultDetails START ");

		installResultVO.setResultId(0);
		installResultVO.setEntryId(0);
		installResultVO.setStusCodeId(4);
		installResultVO.setCtId(999999);
		installResultVO.setInstallDt(dInstallDate);
		installResultVO.setRem("");
		installResultVO.setGlPost(1);
		installResultVO.setCrtUserId(sessionVO.getUserId());
		installResultVO.setSirimNo("");
		installResultVO.setSerialNo("");
		installResultVO.setFailId(0);
		installResultVO.setAllowComm(SalesConstants.IS_FALSE);
		installResultVO.setIsTradeIn(SalesConstants.IS_FALSE);
		installResultVO.setRequireSms(SalesConstants.IS_FALSE);
		installResultVO.setDocRefNo1("");
		installResultVO.setDocRefNo2("");
		installResultVO.setUpdUserId(sessionVO.getUserId());
		installResultVO.setAdjAmt(BigDecimal.ZERO);

/*
        InstallResultDetails.ResultID = 0;
        InstallResultDetails.EntryID = 0;
        InstallResultDetails.StatusCodeID = 4;
        InstallResultDetails.CTID = 999999; //modified by chia // cant save 0
        InstallResultDetails.InstallDate = InstallDate;
        InstallResultDetails.Remark = "";
        InstallResultDetails.GLPost = 1;
        InstallResultDetails.Created = DateTime.Now;
        InstallResultDetails.Creator = li.UserID;
        InstallResultDetails.SirimNo = "";
        InstallResultDetails.SerialNo = "";
        InstallResultDetails.FailID = 0;
        InstallResultDetails.NextCallDate = defaultDate;
        InstallResultDetails.AllowComm = false;
        InstallResultDetails.IsTradeIn = false;
        InstallResultDetails.RequireSMS = false;
        InstallResultDetails.DocRefNo1 = "";
        InstallResultDetails.DocRefNo2 = "";
        InstallResultDetails.Updated = DateTime.Now;
        InstallResultDetails.Updator = li.UserID;
        InstallResultDetails.AdjAmount = 0;
*/
	}

	private void preprocMembershipSalesMaster(SrvMembershipSalesVO srvMembershipSalesVO, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocMembershipSalesMaster START ");

		srvMembershipSalesVO.setSrvMemId(0);
		srvMembershipSalesVO.setSrvMemQuotId(0);
		srvMembershipSalesVO.setSrvSalesOrdId(0);
		srvMembershipSalesVO.setSrvMemNo("");
		srvMembershipSalesVO.setSrvMemBillNo("");
		srvMembershipSalesVO.setSrvMemPacId(10);
		srvMembershipSalesVO.setSrvMemPacAmt(BigDecimal.ZERO);
		srvMembershipSalesVO.setSrvMemBsAmt(BigDecimal.ZERO);
		srvMembershipSalesVO.setSrvMemPv(0);
		srvMembershipSalesVO.setSrvFreq(2);
		srvMembershipSalesVO.setSrvDur(1);
		srvMembershipSalesVO.setSrvStusCodeId(4);
		srvMembershipSalesVO.setSrvRem("");
		srvMembershipSalesVO.setSrvCrtUserId(sessionVO.getUserId());
		srvMembershipSalesVO.setSrvUpdUserId(sessionVO.getUserId());
		srvMembershipSalesVO.setSrvMemBs12Amt(BigDecimal.ZERO);
		srvMembershipSalesVO.setSrvMemIsSynch(SalesConstants.IS_FALSE);
		srvMembershipSalesVO.setSrvMemSalesMemId(0);
		srvMembershipSalesVO.setSrvMemCustCntId(0);
		srvMembershipSalesVO.setSrvMemQty(0);
		srvMembershipSalesVO.setSrvBsQty(0);
		srvMembershipSalesVO.setSrvMemPromoId(0);
		srvMembershipSalesVO.setSrvMemPvMonth(0);
		srvMembershipSalesVO.setSrvMemPvYear(0);
		srvMembershipSalesVO.setSrvMemIsMnl(SalesConstants.IS_FALSE);
		srvMembershipSalesVO.setSrvMemBrnchId(sessionVO.getUserBranchId());

/*
        MembershipSalesMaster.SrvMemID = 0;
        MembershipSalesMaster.SrvMemQuotID = 0;
        MembershipSalesMaster.SrvSalesOrderID = 0;
        MembershipSalesMaster.SrvMemNo = "";
        MembershipSalesMaster.SrvMemBillNo = "";
        MembershipSalesMaster.SrvMemPacID = 10;
        MembershipSalesMaster.SrvMemPacAmt = 0;
        MembershipSalesMaster.SrvMemBSAmt = 0;
        MembershipSalesMaster.SrvMemPV = 0;
        MembershipSalesMaster.SrvFreq = 2;
        MembershipSalesMaster.SrvStartDate = CommonFunction.GetFirstDayOfMonth(DateTime.Now);
        MembershipSalesMaster.SrvExpireDate = CommonFunction.GetLastDayOfMonth(DateTime.Now);
        MembershipSalesMaster.SrvDuration = 1;
        MembershipSalesMaster.SrvStatusCodeID = 4;
        MembershipSalesMaster.SrvRemark = "";
        MembershipSalesMaster.SrvCreateAt = DateTime.Now;
        MembershipSalesMaster.SrvCreateBy = li.UserID;
        MembershipSalesMaster.SrvUpdateAt = DateTime.Now;
        MembershipSalesMaster.SrvUpdateBy = li.UserID;
        MembershipSalesMaster.SrvMemBS12Amt = 0;
        MembershipSalesMaster.SrvMemIsSynch = false;
        MembershipSalesMaster.SrvMemSalesMemID = 0;
        MembershipSalesMaster.SrvMemCustCntID = 0;
        MembershipSalesMaster.SrvMemQty = 0;
        MembershipSalesMaster.SrvBSQty = 0;
        MembershipSalesMaster.SrvMemPromoID = 0;
        MembershipSalesMaster.SrvMemPVMonth = 0;
        MembershipSalesMaster.SrvMemPVYear = 0;
        MembershipSalesMaster.SrvMemIsManual = false;
        MembershipSalesMaster.SrvMemBranchID = li.BranchID;
 */
	}

	private void preprocConfigMaster(SrvConfigurationVO srvConfigurationVO, String dInstallDate, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocConfigMaster START ");

		srvConfigurationVO.setSrvConfigId(0);
		srvConfigurationVO.setSrvSoId(0);
		srvConfigurationVO.setSrvCodyId(0);
		srvConfigurationVO.setSrvPrevDt(dInstallDate);
		srvConfigurationVO.setSrvRem("");
		srvConfigurationVO.setSrvBsGen(SalesConstants.IS_FALSE);
		srvConfigurationVO.setSrvCrtUserId(sessionVO.getUserId());
		srvConfigurationVO.setSrvUpdUserId(sessionVO.getUserId());
		srvConfigurationVO.setSrvStusId(1);
		srvConfigurationVO.setSrvBsWeek(0);

	}

	private void preprocConfigSettingList(List<SrvConfigSettingVO> srvConfigSettingVOList, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocConfigSettingList START ");

		SrvConfigSettingVO cnfigSetVO = null;

		for(int i = 279; i <= 280; i++) {
			cnfigSetVO = new SrvConfigSettingVO();

			cnfigSetVO.setSrvSettId(0);
			cnfigSetVO.setSrvConfigId(0);
			cnfigSetVO.setSrvSettTypeId(i);
			cnfigSetVO.setSrvSettStusId(1);
			cnfigSetVO.setSrvSettRem("");
			cnfigSetVO.setSrvSettCrtUserId(sessionVO.getUserId());

			srvConfigSettingVOList.add(cnfigSetVO);
		}
	}

	private void preprocConfigPeriod(SrvConfigPeriodVO srvConfigPeriodVO, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocConfigPeriod START ");

		srvConfigPeriodVO.setSrvPrdId(0);
		srvConfigPeriodVO.setSrvConfigId(0);
		srvConfigPeriodVO.setSrvMbrshId(0);
		srvConfigPeriodVO.setSrvPrdDur(2);
		srvConfigPeriodVO.setSrvPrdStusId(1);
		srvConfigPeriodVO.setSrvPrdRem("");
		srvConfigPeriodVO.setSrvPrdCrtUserId(sessionVO.getUserId());
		srvConfigPeriodVO.setSrvPrdUpdUserId(sessionVO.getUserId());

	}

	private List<SrvConfigFilterVO> preprocConfigFilterList(String dInstallDate, int itmStkId, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocConfigFilterList START ");

		List<SrvConfigFilterVO> srvConfigFilterVOList = null;
		SrvConfigFilterVO srvConfigFilterVO = null;

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bomStkId", itmStkId);
		List<EgovMap> bomInfoList = htOrderRegisterMapper.selectBOMList(params);

		if(bomInfoList != null && bomInfoList.size() > 0) {

			srvConfigFilterVOList = new ArrayList<SrvConfigFilterVO>();

			for(EgovMap bomInfo : bomInfoList) {

				srvConfigFilterVO = new SrvConfigFilterVO();

				srvConfigFilterVO.setSrvFilterId(0);
				srvConfigFilterVO.setSrvConfigId(0);
				srvConfigFilterVO.setSrvFilterStkId(Integer.parseInt(String.valueOf((BigDecimal)bomInfo.get("bomPartId"))));
				srvConfigFilterVO.setSrvFilterPriod(Integer.parseInt(String.valueOf((BigDecimal)bomInfo.get("bomPartPriod"))));
				srvConfigFilterVO.setSrvFilterPrvChgDt(dInstallDate);
				srvConfigFilterVO.setSrvFilterStusId(1);
				srvConfigFilterVO.setSrvFilterRem("");
				srvConfigFilterVO.setSrvFilterCrtUserId(sessionVO.getUserId());
				srvConfigFilterVO.setSrvFilterUpdUserId(sessionVO.getUserId());

				srvConfigFilterVOList.add(srvConfigFilterVO);
			}
		}

		return srvConfigFilterVOList;
	}

	private void preprocOrderLog(List<SalesOrderLogVO> salesOrderLogVOList, int orderAppType, int custTypeId, int custRaceId, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocOrderLogList START ");

		SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();

		int progressId = 0;
		int isLock = SalesConstants.IS_TRUE;

//		if((orderAppType != SalesConstants.APP_TYPE_CODE_ID_RENTAL)
//		|| (orderAppType == SalesConstants.APP_TYPE_CODE_ID_RENTAL && custTypeId == SalesConstants.CUST_TYPE_CODE_ID_IND && custRaceId == 14)) {
		if(orderAppType != SalesConstants.APP_TYPE_CODE_ID_RENTAL){
			//APP TYPE != RENTAL || APP TYPE == RENTAL && RACE == KOREAN
			if(orderAppType == SalesConstants.APP_TYPE_CODE_ID_SERVICE) {
                //APP TYPE == SERVICES
                //PROGRESS : CUSTOMER IN-USE
				progressId = 5;
				isLock = SalesConstants.IS_FALSE;
			}
			else {
                //APP TYPE == OTHER THAT SERVICES
                //PROGRESS : INSTALLATION CALL-LOG (NEW INSTALLATION)
				progressId = 2;

			}
		}
		else {
            //APP TYPE == RENTAL && RACE!= KOREAN
            //PROGRESS : CCP RESULT
			progressId = 1;
		}

		salesOrderLogVO.setLogId(0);
		salesOrderLogVO.setSalesOrdId(0);
		salesOrderLogVO.setPrgrsId(progressId);
		salesOrderLogVO.setRefId(0);
		salesOrderLogVO.setIsLok(isLock);
		salesOrderLogVO.setLogCrtUserId(sessionVO.getUserId());

		salesOrderLogVOList.add(salesOrderLogVO);
	}

	private void preprocGSTCertificate(GSTEURCertificateVO gSTEURCertificateVO, int orderAppType, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocGSTCertificate START ");

		int reliefTypeId = 0;

		if(orderAppType == SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
			reliefTypeId = 1374; //Foreign Mission And International Organization
		}
		else if(orderAppType == SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT || orderAppType == SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT) {
			reliefTypeId = 1373; //Government Sector
		}

		gSTEURCertificateVO.setEurcRliefTypeId(reliefTypeId);
		gSTEURCertificateVO.setEurcRliefAppTypeId(orderAppType);
		gSTEURCertificateVO.setEurcStusCodeId(SalesConstants.STATUS_ACTIVE);
		gSTEURCertificateVO.setEurcCrtUserId(sessionVO.getUserId());
		gSTEURCertificateVO.setEurcUpdUserId(sessionVO.getUserId());
	}

	private void preprocASEntry(ASEntryVO aSEntryVO, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocASEntry START ");


		aSEntryVO.setAsId(0);
		aSEntryVO.setAsNo("");
		aSEntryVO.setAsSoId(0);
		aSEntryVO.setAsMemId(0);
		aSEntryVO.setAsMemGrp(null);
		//aSEntryVO.setAsReqstDt();
		//aSEntryVO.setAsReqstTm();
		//aSEntryVO.setAsAppntDt();
		//aSEntryVO.setAsAppntTm();
		aSEntryVO.setAsBrnchId(0);
		aSEntryVO.setAsMalfuncId(9004100);
		aSEntryVO.setAsMalfuncResnId(2);
		aSEntryVO.setAsRemReqster("");
		aSEntryVO.setAsRemReqsterCntc("");
		aSEntryVO.setAsCalllogId(0);
		aSEntryVO.setAsStusId(1);
		aSEntryVO.setAsSms(0);
		aSEntryVO.setAsCrtUserId(sessionVO.getUserId());
		//aSEntryVO.setAsCrtDt();
		aSEntryVO.setAsUpdUserId(sessionVO.getUserId());
		//aSEntryVO.setAsUpdDt("");
		aSEntryVO.setAsEntryIsSynch(0);
		aSEntryVO.setAsEntryIsEdit(0);
		aSEntryVO.setAsTypeId(3154);
		aSEntryVO.setAsReqsterTypeId(0);
		aSEntryVO.setAsIsBSWithin30days(0);
		aSEntryVO.setAsAllowComm(0);
		aSEntryVO.setAsPrevMemId(0);
		aSEntryVO.setAsRemAddCntc(null);
		aSEntryVO.setAsRemReqsterCntcSms(0);
		aSEntryVO.setAsRemAddCntcSms(0);
		aSEntryVO.setAsSesionCode("");
		aSEntryVO.setCallMem("0");
		aSEntryVO.setRefReqst(null);
		aSEntryVO.setPrevCompSvc(null);
		aSEntryVO.setNextCompSvc(null);
		//aSEntryVO.setSignDtTime("");
		//aSEntryVO.setCompDtSeq(0);
		//aSEntryVO.setDistance(0);
		aSEntryVO.setFirst(null);
		aSEntryVO.setLast(null);
		aSEntryVO.setHome(null);
		aSEntryVO.setAsMobileReqstId(null);
		aSEntryVO.setAsRqstRem(null);
		aSEntryVO.setPrevSvcArea(null);
		aSEntryVO.setNextSvcArea(null);
		aSEntryVO.setAsIfFlag(null);

	}

	@Override
	public ReturnMessage registerOrder(HTOrderVO orderVO, SessionVO sessionVO) throws Exception {

		logger.info("!@###### OrderRegisterServiceImpl.registerOrder################");

		HTOrderVO HTOrderVO = new HTOrderVO();

		//GridDataSet<DocSubmissionVO>    documentList     = orderVO.getDocSubmissionVOList();
		//List<DocSubmissionVO>               docSubVOList     = documentList.getUpdate(); // 수정 리스트 얻기
		InstallationVO 		                      installationVO 	  = orderVO.getInstallationVO();


		int orderAppType = orderVO.getAppTypeId();
		int custTypeId   = orderVO.getCustTypeId();
		int custRaceId   = orderVO.getRaceId();
		int srvPacId = orderVO.getSrvPacId();
		int orderQuantity = orderVO.getOrderQuantity();

		//SERVICE ADDRESS INSTALLATION
		String sInstallDate = installationVO.getPreDt();
		String dInstallDate = sInstallDate;

		HTOrderVO.setCrtUserId(sessionVO.getUserId());
		HTOrderVO.setOrderAppType(orderAppType);
		HTOrderVO.setCustTypeId(custTypeId);
		HTOrderVO.setRaceId(custRaceId);
		HTOrderVO.setsInstallDate(sInstallDate);
		HTOrderVO.setdInstallDate(dInstallDate);
		HTOrderVO.setBrnchId(sessionVO.getUserBranchId());

		// DOCUMENT SUBMISSION
/*		this.preprocDocumentList(docSubVOList, sessionVO);
		HTOrderVO.setDocSubVOList(docSubVOList);
*/
		// SERVICE CONFIGURATION
		SrvMembershipSalesVO srvMembershipSalesVO = new SrvMembershipSalesVO();
		this.preprocMembershipSalesMaster(srvMembershipSalesVO, sessionVO);
		HTOrderVO.setSrvMembershipSalesVO(srvMembershipSalesVO);

		SrvConfigurationVO srvConfigurationVO = new SrvConfigurationVO();
		this.preprocConfigMaster(srvConfigurationVO, dInstallDate, sessionVO);
		HTOrderVO.setSrvConfigurationVO(srvConfigurationVO);

		List<SrvConfigSettingVO> srvConfigSettingVOList = new ArrayList<SrvConfigSettingVO>();
		this.preprocConfigSettingList(srvConfigSettingVOList, sessionVO);
		HTOrderVO.setSrvConfigSettingVOList(srvConfigSettingVOList);

		SrvConfigPeriodVO srvConfigPeriodVO = new SrvConfigPeriodVO();
		this.preprocConfigPeriod(srvConfigPeriodVO, sessionVO);
		HTOrderVO.setSrvConfigPeriodVO(srvConfigPeriodVO);

		// SERVICE CARE ORDER LOG
/*		List<SalesOrderLogVO> salesOrderLogVOList = new ArrayList<SalesOrderLogVO>();
		this.preprocOrderLog(salesOrderLogVOList, orderAppType, custTypeId, custRaceId, sessionVO);
		HTOrderVO.setSalesOrderLogVOList(salesOrderLogVOList);
*/
		//GET SERVICE CARE ORDER NO
		String salesOrdNo = "";
		salesOrdNo =  htOrderRegisterMapper.selectDocNo(168);
		logger.info("!@#### SERVICE CARE ORDER NO  :"+ salesOrdNo);
		logger.info("##HTOrderVO## : " + HTOrderVO);
		orderVO.setSalesOrdNo(salesOrdNo);
		orderVO.setCrtUserId(sessionVO.getUserId());
		orderVO.setBrnchId(sessionVO.getUserBranchId());
        int salesOrdId = 0;
        int stusCodeId = 0;
        if (orderVO.getAppTypeId() == 3216 || orderVO.getAppTypeId() == 3217){
        	stusCodeId = 1;
        }else{
        	stusCodeId = 4;
        }
        orderVO.setStusCodeId(stusCodeId);

     // SERVICE CARE ORDER - SAL0225D
     	htOrderRegisterMapper.insertSalesOrderM(orderVO);

     	salesOrdId = (int)orderVO.getSalesOrdId();
     	logger.info("!@#### SERVICE CARE ORDER ID  :"+ salesOrdId);

     // INSTALLATION ADDRESS - SAL0045D
        installationVO.setSalesOrdId(salesOrdId);
        htOrderRegisterMapper.insertInstallation(installationVO);

     // DOCUMENT SUBMISSION
/*        if(docSubVOList != null && docSubVOList.size() > 0) {
        	for(DocSubmissionVO docSubVO : docSubVOList) {
        		docSubVO.setDocSoId(salesOrdId);
        		htOrderRegisterMapper.insertDocSubmission(docSubVO);
        	}
        }
*/
     //SERVICE MEMBERSHIP SALES - SAL0095D

        Map<String, Object> srvparams = null;
		srvparams = new HashMap<String, Object>();
		srvparams.put("appTypeId",orderVO.getAppTypeId());
		srvparams.put("salesOrdId",salesOrdId);
		srvparams.put("orderQuantity", orderQuantity);
		EgovMap memberPackageInfo = htOrderRegisterMapper.selectMembershipPackageInfo(srvparams);
		srvparams.put("DOCNO", "19");
	    EgovMap membershipBillNo = htOrderRegisterMapper.getCSEntryDocNo(srvparams);
	    String billNo = "";

	    if (orderVO.getAppTypeId() == 3216 || orderVO.getAppTypeId() == 3217){
	    	billNo = String.valueOf(membershipBillNo.get("csno"));
	    }else
	    {
	    	billNo = "";
	    }


		String startDt = (String) memberPackageInfo.get("strtDt");
		String expireDt = (String) memberPackageInfo.get("exprDt");
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		Date startDt1 = df.parse(startDt.toString());
		Date expireDt1 = df.parse(expireDt.toString());


    	if(srvMembershipSalesVO != null && srvMembershipSalesVO.getSrvStusCodeId() > 0) {
    		String membershipNo = htOrderRegisterMapper.selectDocNo(DocTypeConstants.MEMBERSHIP_NO);
    		srvMembershipSalesVO.setSrvMemBillNo(billNo);
    		srvMembershipSalesVO.setSrvFreq(4);
    		srvMembershipSalesVO.setSrvStartDt(startDt1);
    		srvMembershipSalesVO.setSrvExprDt(expireDt1);
    		srvMembershipSalesVO.setSrvDur(CommonUtils.intNvl(memberPackageInfo.get("srvMemDur")));
    		srvMembershipSalesVO.setSrvMemPacId(srvPacId);
    		srvMembershipSalesVO.setSrvMemNo(membershipNo);
    		srvMembershipSalesVO.setSrvSalesOrdId(salesOrdId);
    		htOrderRegisterMapper.insertSrvMembershipSales(srvMembershipSalesVO);
    	}

    	//SERVICE CONFIGURATION - SAL0090D
    	if(srvConfigurationVO != null && srvConfigurationVO.getSrvStusId() > 0) {
    		srvConfigurationVO.setSrvSoId(salesOrdId);
    		srvConfigurationVO.setSrvBsGen(1);
    		srvConfigurationVO.setSrvCodyId(CommonUtils.intNvl(memberPackageInfo.get("codyId")));
    		htOrderRegisterMapper.insertSrvConfiguration(srvConfigurationVO);
    	}

    	//SERVICE CONFIG SETTING - SAL0089D
        if(srvConfigSettingVOList != null && srvConfigSettingVOList.size() > 0) {
        	for(SrvConfigSettingVO srvConfigSettingVO : srvConfigSettingVOList) {
        		srvConfigSettingVO.setSrvConfigId(srvConfigurationVO.getSrvConfigId());
        		htOrderRegisterMapper.insertSrvConfigSetting(srvConfigSettingVO);
        	}
        }

        //SERVICE CONFIG PERIOD - SAL0088D
        if(srvConfigPeriodVO != null && srvConfigPeriodVO.getSrvPrdStusId() > 0) {
        	srvConfigPeriodVO.setSrvConfigId(srvConfigurationVO.getSrvConfigId());
        	srvConfigPeriodVO.setSrvPrdDur(4);
        	srvConfigPeriodVO.setSrvPrdStartDt(startDt1);
        	srvConfigPeriodVO.setSrvPrdExprDt(expireDt1);;
        	htOrderRegisterMapper.insertSrvConfigPeriod(srvConfigPeriodVO);
        }

		// SERVICE CARE ORDER LOG - SAL0232D
    	//List<SalesOrderLogVO> 	 salesOrderLogVOList 	= orderVO.getSalesOrderLogVOList();
       /* if(salesOrderLogVOList != null && salesOrderLogVOList.size() > 0) {
        	for(SalesOrderLogVO salesOrderLogVO : salesOrderLogVOList) {

        		salesOrderLogVO.setSalesOrdId(salesOrdId);
        		htOrderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);
        	}
        }*/


	    // TAX INVOICE
	    // PAY0031D
/*        Map<String, Object> params = null;
        params = new HashMap<String, Object>();
	    params.put("DOCNO", "133");
	    params.put("CS_SO_ID", salesOrdId);
	    EgovMap invoiceDocNo = htOrderRegisterMapper.getCSEntryDocNo(params);
	    int taxInvcId = htOrderRegisterMapper.getSeqPay0031D();
	    EgovMap taxPersonInfo = htOrderRegisterMapper.selectTaxInvoice(params);*/

        String appTypeName= "";
		String invDocNo = "";


	    if (orderVO.getAppTypeId() == 3216 || orderVO.getAppTypeId() == 3217){  //CHECK APPLICATION TYPE = CARE SERVICE

	    	Map<String, Object> params = null;
	        params = new HashMap<String, Object>();
	  	    params.put("DOCNO", "133");
	  	    params.put("CS_SO_ID", salesOrdId);
	  	    EgovMap invoiceDocNo = htOrderRegisterMapper.getCSEntryDocNo(params);
	  	    int taxInvcId = htOrderRegisterMapper.getSeqPay0031D();
	  	    EgovMap taxPersonInfo = htOrderRegisterMapper.selectTaxInvoice(params);

	    Map<String, Object> param = new HashMap();

	    param.put("taxInvcId", taxInvcId);
	    param.put("taxInvcRefNo", String.valueOf(invoiceDocNo.get("csno")));
	    param.put("taxInvcRefDt", "");
	    param.put("taxInvcSvcNo", salesOrdNo);
	    param.put("taxInvcType", "408"); // CARE SERVICE

	    try {
	      param.put("taxInvcCustName", taxPersonInfo.get("taxInvoiceCustName"));
	      param.put("taxInvcCntcPerson", taxPersonInfo.get("taxInvoiceContPers"));
	    } catch (Exception e) {

	      param.put("taxInvcCustName", "");
	      param.put("taxInvcCntcPerson", "");

	    }

	    param.put("taxInvcAddr1", taxPersonInfo.get("add1"));
	    param.put("taxInvcAddr2", taxPersonInfo.get("add2"));
	    param.put("taxInvcAddr3", taxPersonInfo.get("add3"));
	    param.put("taxInvcAddr4", "");
	    param.put("taxInvcPostCode", "");
	    param.put("taxInvcStateName", "");
	    param.put("areaId", taxPersonInfo.get("areaId"));
	    param.put("addrDtl", taxPersonInfo.get("addrDtl"));
	    param.put("street", taxPersonInfo.get("street"));
	    param.put("taxInvcCnty", "");
	    param.put("taxInvcTaskId", "");
	    param.put("taxInvcRem", "");
	    param.put("taxInvcChrg", orderVO.getTotAmt());
	    param.put("taxInvcTxs", "0");
	    param.put("taxInvcAmtDue", orderVO.getTotAmt());
	    param.put("taxInvcCrtDt", new Date());
	    param.put("taxInvcCrtUserId", sessionVO.getUserId());

	    // PAY0032D
	    Map<String, Object> param2 = new HashMap();

	    param2.put("taxInvcId", taxInvcId);
	    param2.put("invcItmType", orderVO.getAppTypeId()); //
	    param2.put("invcItmOrdNo", salesOrdNo);
	    param2.put("invcItmPoNo", orderVO.getCustPoNo());
	    param2.put("invcItmCode", orderVO.getProdSize());
	    param2.put("invcItmDesc1", orderVO.getProdBrand());
	    param2.put("invcItmDesc2", "");
	    param2.put("invcItmSerialNo", "");
	    param2.put("invcItmQty", 1);
	    param2.put("invcItmUnitPrc", "");
	    param2.put("invcItmGstRate", "0");
	    param2.put("invcItmGstTxs", "0");
	    param2.put("invcItmChrg", orderVO.getTotAmt());
	    param2.put("invcItmAmtDue", orderVO.getTotAmt());
	    param2.put("invcItmAdd1", taxPersonInfo.get("add1"));
	    param2.put("invcItmAdd2", taxPersonInfo.get("add2"));
	    param2.put("invcItmAdd3", taxPersonInfo.get("add3"));
	    param2.put("invcItmAdd4", "");
	    param2.put("invcItmPostCode", "");
	    param2.put("invcItmAreaName", "");
	    param2.put("invcItmStateName", "");
	    param.put("areaId", taxPersonInfo.get("areaId"));
	    param.put("addrDtl", taxPersonInfo.get("addrDtl"));
	    param.put("street", taxPersonInfo.get("street"));
	    param2.put("invcItmCnty", "");
	    param2.put("invcItmInstallDt", "");
	    param2.put("invcItmRetnDt", "");
	    param2.put("invcItmBillRefNo", "Care Service");

	    // PAY0016D
	    Map<String, Object> param3 = new HashMap();

	    param3.put("accBillTaskId", "0");
	    param3.put("accBillRefDt", new Date());
	    param3.put("accBillRefNo", "2000");
	    param3.put("accBillOrdId", salesOrdId);
	    param3.put("accBillTypeId", "1159"); // SYSTEM GENERATE BILL

	    int appId = orderVO.getAppTypeId();
	    String scModeId = "";
	    if (appId == 3216){ // 1 TIME PACKAGE
	    	scModeId = "3218";
	    }else if(appId == 3217){ // 1 YEAR PACKAGE
	    	scModeId = "3219";
	    }

	    param3.put("accBillModeId", scModeId); // CARE SERVICE BILL
	    param3.put("accBillSchdulId", "0");
	    param3.put("accBillSchdulPriod", "0");
	    param3.put("accBillAdjId", "0");
	    param3.put("accBillSchdulAmt", orderVO.getTotAmt());
	    param3.put("accBillAdjAmt", "0");
	    param3.put("accBillTxsAmt", "0");
	    param3.put("accBillNetAmt", orderVO.getTotAmt());
	    param3.put("accBillStus", "1");
	    param3.put("accBillRem", String.valueOf(invoiceDocNo.get("csno")));
	    param3.put("accBillCrtDt", new Date());
	    param3.put("accBillCrtUserId", sessionVO.getUserId() );
	    param3.put("accBillGrpId", "0");
	    param3.put("accBillTaxCodeId", "0");
	    param3.put("accBillTaxRate", "0");
	    param3.put("accBillAcctCnvr", "0");
	    param3.put("accBillCntrctId", "0");


	    //SERVICE MEMBER LEDGER SAL0291D
	     Map<String , Object> param4 = new HashMap<String , Object> ();

	     param4.put("srvMemId",srvMembershipSalesVO.getSrvMemId());
 		 param4.put("srvMemDocNo",srvMembershipSalesVO.getSrvMemBillNo());
	     param4.put("srvMemDocTypeId","386");
         param4.put("srvMemDtTm",new Date());
         param4.put("srvMemAmt",orderVO.getTotAmt());
         param4.put("srvMemInstNo","0");
         param4.put("srvMemBatchNo",String.valueOf(invoiceDocNo.get("csno")));   //srvMemBatchNo
         param4.put("srvMemUpdUserId",sessionVO.getUserId());
         param4.put("srvMemUpdDt","");
         param4.put("srvMemOrdId",salesOrdId);
         param4.put("srvMemQotatId",srvMembershipSalesVO.getSrvMemQuotId());
         param4.put("r01","");


         // SERVICE MEMBER BILL PAY0007D
         Map<String, Object> param5 = new HashMap();

         param5.put("billTypeId", "223"); //MEMBERSHIP BILL
         param5.put("billSoId", salesOrdId);
         param5.put("billMemId", srvMembershipSalesVO.getSrvMemId());
         param5.put("billAsId", "0");
         param5.put("billPayTypeId", "386"); // SERVICE MEMBERSHIP BILL
         param5.put("billNo", srvMembershipSalesVO.getSrvMemBillNo());
         param5.put("billMemShipNo", srvMembershipSalesVO.getSrvMemNo());
         param5.put("billDt", new Date());
         param5.put("billAmt", orderVO.getTotAmt());
         param5.put("billRem", "");
         param5.put("billIsPaid", "1");
         param5.put("billIsComm", "0");
         param5.put("updUserId", sessionVO.getUserId());
         param5.put("updDt", new Date());
         param5.put("syncChk", "0");
         param5.put("coursId", "0");
         param5.put("stusId", "1");



	    htOrderRegisterMapper.insert_Pay0031d(param);
	    htOrderRegisterMapper.insert_Pay0032d(param2);
	    htOrderRegisterMapper.insert_Pay0016d(param3);
	    htOrderRegisterMapper.insertAccSrvMemLedger(param4);
	    htOrderRegisterMapper.insert_Pay0007d(param5);

	    switch(orderVO.getAppTypeId()){
		case 3216 :
			appTypeName = "Care Service 1 Time ";
			invDocNo =  String.valueOf(invoiceDocNo.get("csno"));
			break;
		case 3217 :
			appTypeName = "Care Service 1 Year ";
			invDocNo =  String.valueOf(invoiceDocNo.get("csno"));
			break;
	    }

        }

//		String appTypeName= "";
//		String invDocNo = "";
		switch(orderVO.getAppTypeId()){
		case 5702 :
			appTypeName = "Free Trial 1 Year (No Billing)";
			invDocNo = "";
			break;
		case 5701 :
			appTypeName = "Free Trial 1 Time (No Billing)";
			invDocNo = "";
			break;
		default :
			break;
		}

		logger.info("!@#### SERVICE APPLICATION TYPE ID  :"+ orderVO.getAppTypeId());



		String msg = "Care Service Order Saved.<br /> Care Service No. :  " + salesOrdNo + "<br /> Application Type : " + appTypeName + "<br /> Invoice Doc No. : " + invDocNo;
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return message;

	}


	@Override
	public List<EgovMap> selectProductCodeList(Map<String, Object> params) {
		// TODO ProductCodeList 호출시 error남
		return htOrderRegisterMapper.selectProductCodeList(params);
	}

	@Override
	public List<EgovMap> selectServicePackageList(Map<String, Object> params) {
		// TODO ProductCodeList 호출시 error남
		return htOrderRegisterMapper.selectServicePackageList(params);
	}

	@Override
	public List<EgovMap> selectServicePackageList2(Map<String, Object> params) {
		// TODO ProductCodeList 호출시 error남
		return htOrderRegisterMapper.selectServicePackageList2(params);
	}

	@Override
	public List<EgovMap> selectPrevOrderNoList(Map<String, Object> params) {
		// TODO ProductCodeList 호출시 error남
		return htOrderRegisterMapper.selectPrevOrderNoList(params);
	}

	public List<EgovMap> selectProductComponent(Map<String, Object> params) {
		// TODO Auto-generated method stub

		return htOrderRegisterMapper.selectProductComponent(params);
	}

	@Override
	public EgovMap selectProductComponentDefaultKey(Map<String, Object> params) {
		EgovMap cpntKey = htOrderRegisterMapper.selectProductComponentDefaultKey(params);
		return cpntKey;
	}

	public EgovMap selectHTCovergPostCode(Map<String, Object> params) {
		// TODO Auto-generated method stub

		return htOrderRegisterMapper.selectHTCovergPostCode(params);
	}
}
