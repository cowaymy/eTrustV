/**
 *
 */
package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.sales.order.OrderLedgerService;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.PreOrderListVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("preOrderService")
public class PreOrderServiceImpl extends EgovAbstractServiceImpl implements PreOrderService {

	private static Logger logger = LoggerFactory.getLogger(PreOrderServiceImpl.class);

	@Resource(name = "preOrderMapper")
	private PreOrderMapper preOrderMapper;

	@Resource(name = "orderRegisterMapper")
	private OrderRegisterMapper orderRegisterMapper;

	@Resource(name = "orderLedgerMapper")
	private OrderLedgerMapper orderLedgerMapper;

	@Resource(name = "voucherMapper")
	private VoucherMapper voucherMapper;

//	@Autowired
//	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectPreOrderList(Map<String, Object> params) {
		return preOrderMapper.selectPreOrderList(params);
	}

	@Override
	public EgovMap selectPreOrderInfo(Map<String, Object> params) {

		EgovMap rslt = preOrderMapper.selectPreOrderInfo(params);

		if(rslt.get("preTm") != null) {
			rslt.put("preTm", this.convert12Tm((String) rslt.get("preTm")));
		}

		if(rslt.get("voucherCode") != null){
			String voucherCode = rslt.get("voucherCode").toString();
			if(voucherCode.isEmpty() == false){
		        Map<String, Object> voucherParams = new HashMap();
		        voucherParams.put("voucherCode",voucherCode);
				EgovMap voucher = voucherMapper.getVoucherInfo(voucherParams);

				if(voucher != null){
					rslt.put("voucherInfo", voucher);
				}
			}
		}

		return preOrderMapper.selectPreOrderInfo(params);
	}

	private String convert12Tm(String TM) {
		String HH = "", MI = "", cvtTM = "";

		if(CommonUtils.isNotEmpty(TM)) {
			HH = CommonUtils.left(TM, 2);
			MI = TM.substring(3, 5);

			if(Integer.parseInt(HH) > 12) {
				cvtTM = CommonUtils.getFillString((Integer.parseInt(HH) - 12), "0", 2) + ":" + String.valueOf(MI) + " PM";
			}
			else {
				cvtTM = HH + ":" + String.valueOf(MI) + " AM";
			}
		}
		return cvtTM;
	}

	@Override
	public int selectExistSofNo(Map<String, Object> params) {
		return preOrderMapper.selectExistSofNo(params);
	}

	@Override
	public void insertPreOrder(PreOrderVO preOrderVO, SessionVO sessionVO) {
		/*
		 * Check if the voucher has been used before on sales order
		 * Also check if the voucher has been use before on other e-keyin sales
		 */

	  	if(CommonUtils.isEmpty(preOrderVO.getVoucherCode()) == false){
			this.checkVoucherValideKeyIn(preOrderVO.getVoucherCode());
		}

		preOrderVO.setStusId(SalesConstants.STATUS_ACTIVE);
		this.preprocPreOrder(preOrderVO, sessionVO);
		preOrderMapper.insertPreOrder(preOrderVO);

		//Update customer marketing message status(universal between HC/HA)
        Map<String, Object> params = new HashMap();
        params.put("custId",preOrderVO.getCustId());
        params.put("updUserId", sessionVO.getUserId());
        params.put("receivingMarketingMsgStatus", preOrderVO.getReceivingMarketingMsgStatus());
        orderRegisterMapper.updateMarketingMessageStatus(params);
	}

	@Override
	public void updatePreOrder(PreOrderVO preOrderVO, SessionVO sessionVO) {
		String existingVoucherCode = CommonUtils.nvl(preOrderMapper.selectExistingSalesVoucherCode(preOrderVO));
		String currentVoucherCode = CommonUtils.nvl(preOrderVO.getVoucherCode());

		/*
		 * Check if the voucher has been used before on sales order
		 * Also check if the voucher has been use before on other e-keyin sales
		 */
		if(currentVoucherCode.isEmpty() == false){
			if(existingVoucherCode.isEmpty()){
				this.checkVoucherValideKeyIn(currentVoucherCode);
			}
			else{
				if(existingVoucherCode != null && existingVoucherCode.equals(currentVoucherCode) == false){
					this.checkVoucherValideKeyIn(currentVoucherCode);
				}
			}
		}

		this.preprocPreOrder(preOrderVO, sessionVO);
		preOrderMapper.updatePreOrder(preOrderVO);

        //Update customer marketing message status(universal between HC/HA)
        Map<String, Object> params = new HashMap();
        params.put("custId",preOrderVO.getCustId());
        params.put("updUserId", sessionVO.getUserId());
        params.put("receivingMarketingMsgStatus", preOrderVO.getReceivingMarketingMsgStatus());

        orderRegisterMapper.updateMarketingMessageStatus(params);
	}

	@Override
	public void updatePreOrderStatus(PreOrderListVO preOrderListVO, SessionVO sessionVO) {

		GridDataSet<PreOrderVO> preOrderList = preOrderListVO.getPreOrderVOList();

		ArrayList<PreOrderVO> updateList = preOrderList.getUpdate();

		for(PreOrderVO vo : updateList) {
			vo.setUpdUserId(sessionVO.getUserId());
			preOrderMapper.updatePreOrderStatus(vo);
		}
	}

	@Override
	public void updatePreOrderFailStatus(Map<String, Object> params, SessionVO sessionVO) {
		params.put("crtUserId", sessionVO.getUserId()); //added by keyi 20211115
		params.put("updUserId", sessionVO.getUserId());

		preOrderMapper.updatePreOrderFailStatus(params);

		preOrderMapper.InsertPreOrderFailStatus(params);

	}

	private void preprocPreOrder(PreOrderVO preOrderVO, SessionVO sessionVO) {

		preOrderVO.setChnnl(preOrderVO.getChnnl()==2 ? preOrderVO.getChnnl(): SalesConstants.PRE_ORDER_CHANNEL_WEB);
		//preOrderVO.setStusId(SalesConstants.STATUS_ACTIVE);
		//preOrderVO.setKeyinBrnchId(sessionVO.getUserBranchId());
		preOrderVO.setPreTm(this.convert24Tm(preOrderVO.getPreTm()));

		preOrderVO.setCrtUserId(sessionVO.getUserId());
		preOrderVO.setUpdUserId(sessionVO.getUserId());
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

	@Override
	public int selectExistingMember(Map<String, Object> params) {
		return preOrderMapper.selectExistingMember(params);
	}

	@Override
	public List<EgovMap> getAttachList(Map<String, Object> params) {
		return preOrderMapper.selectAttachList(params);
	}

	@Override
	public List<EgovMap> selectPreOrderFailStatus(Map<String, Object> params) {
		return preOrderMapper.selectPreOrderFailStatus(params);
	}

	public int selRcdTms(Map<String, Object> params) {
	    return preOrderMapper.selRcdTms(params);
	  }

	public int selPreOrdId(Map<String, Object> params) {
     return preOrderMapper.selPreOrdId(params);
    }

	@Override
	  public EgovMap checkOldOrderIdEKeyIn(Map<String, Object> params) {

	    int getOldOrderID = 0;
	    int custId = 0, promoId = 0;
	    String ROOT_STATE = "", isInValid = "", msg = "", txtInstSpecialInstruction = "";

	    logger.info("!@#### custId:" + (String) params.get("custId"));
	    logger.info("!@#### salesOrdNo:" + (String) params.get("salesOrdNo"));

	    custId = Integer.parseInt((String) params.get("custId"));
	    promoId = Integer.parseInt((String) params.get("promoId"));

	    EgovMap RESULT = new EgovMap();
	    EgovMap ordInfo = orderRegisterMapper.selectOldOrderId((String) params.get("salesOrdNo"));

	    if (ordInfo != null) {
	      getOldOrderID = CommonUtils.intNvl(Integer.parseInt(String.valueOf(ordInfo.get("salesOrdId"))));
	    }

	    EgovMap GetExpDate = orderRegisterMapper.selectSvcExpire(getOldOrderID);

	    if (getOldOrderID <= 0) {
	      ROOT_STATE = "ROOT_1";
	    } else {
	      if (this.isVerifyOldSalesOrderNoValidity(getOldOrderID)) {

	        // EgovMap resultMap = this.selectSalesOrderM(getOldOrderID,
	        // SalesConstants.APP_TYPE_CODE_ID_SERVICE); // 2018-09-13 - Disabled
	        // extrade for Education and Free Trial
	        EgovMap resultMap = this.selectSalesOrderM(getOldOrderID, 0);
	        EgovMap promoMap = orderRegisterMapper.selectPromoDesc(promoId);

	        String appTypId = "";
	        if (resultMap != null)
	          appTypId = resultMap.get("appTypeId").toString();

	        // if(resultMap != null) {
	        // //if(so.VerifyOldSalesOrderNotServiceType(getOldOrderID)
	        if ("144".equals(appTypId) || "145".equals(appTypId)) { // 2018-09-13 -
	                                                                // Disabled
	                                                                // extrade for
	                                                                // Education and
	                                                                // Free Trial
	          ROOT_STATE = "ROOT_2";
	        }
	        // }
	        else {
	          if (GetExpDate == null) {
	            ROOT_STATE = "ROOT_3";
	          } else {

	            Calendar calNow = Calendar.getInstance();

	            int nowYear = calNow.YEAR;
	            int nowMonth = calNow.MONTH + 1;
	            int nowDate = calNow.DATE;

	            logger.info("!@#### nowYear :" + nowYear);
	            logger.info("!@#### nowMonth:" + nowMonth);
	            logger.info("!@#### nowDate :" + nowDate);

	            Date srvPrdExprDt = (Date) GetExpDate.get("srvPrdExprDt");

	            Calendar calExt = Calendar.getInstance();

	            calExt.setTime(srvPrdExprDt);

	            int expYear = calExt.YEAR;
	            int expMonth = calExt.MONTH + 1;

	            calExt.add(Calendar.MONTH, -4);

	            msg = "-SVM End Date : <b>" + (String) GetExpDate.get("srvPrdExprDtMmyy") + "</b> <br/>";

	            if (expYear <= nowYear || (expYear == nowYear && (expMonth - 4) <= nowMonth)
	                || (calExt.compareTo(calNow) <= 0)) {
	              logger.debug("@####:not InValid");
	            } else {
	              logger.debug("@####:InValid");

	              isInValid = "InValid";
	            }

	            EgovMap validateRentOutright = this.selectSalesOrderM(getOldOrderID, 0);

	            // Renatal
	            if (SalesConstants.APP_TYPE_CODE_ID_RENTAL == Integer
	                .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) {

	              if (this.isVerifyOldSalesOrderRentalScheme(getOldOrderID, 0)) { // chia
	                                                                              // chia
	                                                                              // --18/01/2016
	                                                                              // --ex-trade
	                                                                              // only
	                                                                              // allow
	                                                                              // rental
	                                                                              // status
	                                                                              // REG
	                                                                              // ||
	                                                                              // INV
	                                                                              // ||
	                                                                              // SUS

	                BigDecimal valiOutStanding = (BigDecimal) orderRegisterMapper.selectRentAmt(getOldOrderID);
	                valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);

	                if (valiOutStanding.compareTo(BigDecimal.ZERO) > 0) {
	                  msg = msg + " -With Outstanding payment not allowed for Ex-Trade promo. <br/>";
	                  isInValid = "InValid";
	                }

	                EgovMap ValiRentInstNo = orderRegisterMapper.selectAccRentLedgers(getOldOrderID);

	                if (Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) < 57) { // Ex-Trade
	                                                                                               // can
	                                                                                               // be
	                                                                                               // done
	                                                                                               // 4
	                                                                                               // month
	                                                                                               // early
	                  msg = msg + " -Below 57th months not allowed to entitle Ex-Trade Promo. <br/>";
	                  isInValid = "Valid";
	                }

	                if (custId != Integer.parseInt(String.valueOf(validateRentOutright.get("custId")))) {
	                  msg = msg + " -Different Customer is not allowed.";
	                  isInValid = "InValid";
	                }

	                ROOT_STATE = "ROOT_4";

	                txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
	                    + (String) promoMap.get("promoDesc") + " , SVM expired : "
	                    + (String) GetExpDate.get("srvPrdExprDtMmyy");
	              } else {
	                ROOT_STATE = "ROOT_5";
	              }
	            } else if (SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT == Integer
	                .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))
	                || SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT == Integer
	                    .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) { // outright,Installment

	              msg = "-SVM End Date : <b>" + (String) GetExpDate.get("srvPrdExprDtMmyy") + "</b>  SVM Expired Date : <b>"
	                  + (String) GetExpDate.get("srvPrdExprDtMmyyAdd") + "</b> <br/>";

	              if (custId != Integer.parseInt(String.valueOf(validateRentOutright.get("custId")))) {
	                msg = msg + " -Different Customer is not allowed.";
	                isInValid = "InValid";
	              }

	              ROOT_STATE = "ROOT_6";

	              txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
	                  + (String) promoMap.get("promoDesc") + " , SVM expired : "
	                  + (String) GetExpDate.get("srvPrdExprDtMmyy");
	            } else {
	              ROOT_STATE = "ROOT_7";

	              txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
	                  + (String) promoMap.get("promoDesc") + " , SVM expired : "
	                  + (String) GetExpDate.get("srvPrdExprDtMmyy");

	            }
	          }
	        }
	      } else {
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
	  public EgovMap checkOldOrderIdICareEKeyIn(Map<String, Object> params) {

	    int getOldOrderID = 0;
	    int custId = 0, promoId = 0;
	    String ROOT_STATE = "", isInValid = "", msg = "", txtInstSpecialInstruction = "";

	    logger.info("!@#### custId:" + (String) params.get("custId"));
	    logger.info("!@#### salesOrdNo:" + (String) params.get("salesOrdNo"));
	    logger.info("!@#### all params :" + (String) params.toString());

	    custId = Integer.parseInt((String) params.get("custId"));
	    promoId = Integer.parseInt((String) params.get("promoId"));

	    EgovMap RESULT = new EgovMap();
	    EgovMap ordInfo = orderRegisterMapper.selectOldOrderId((String) params.get("salesOrdNo"));

	    if (ordInfo != null) {
	      getOldOrderID = CommonUtils.intNvl(Integer.parseInt(String.valueOf(ordInfo.get("salesOrdId"))));
	    }

	    if (getOldOrderID <= 0) {
	      ROOT_STATE = "ROOT_1";
	    } else {
	      if (this.isVerifyOldSalesOrderNoValidityICare(getOldOrderID)) {

	        EgovMap resultMap = this.selectSalesOrderM(getOldOrderID, 0);
	        EgovMap promoMap = orderRegisterMapper.selectPromoDesc(promoId);

	        String appTypId = "";
	        if (resultMap != null)
	          appTypId = resultMap.get("appTypeId").toString();

	        if ("144".equals(appTypId) || "145".equals(appTypId)) { // 2018-09-13 -
	                                                                // Disabled
	                                                                // extrade for
	                                                                // Education and
	                                                                // Free Trial
	          ROOT_STATE = "ROOT_2";
	        }

	        else {
	          EgovMap validateRentOutright = this.selectSalesOrderM(getOldOrderID, 0);

	          // Renatal
	          if (SalesConstants.APP_TYPE_CODE_ID_RENTAL == Integer
	              .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) {

	            if (this.isVerifyOldSalesOrderRentalScheme(getOldOrderID, 1)) { // Kit
	                                                                            // --ex-trade
	                                                                            // only
	                                                                            // allow
	                                                                            // rental
	                                                                            // status
	                                                                            // REG

	              params.put("ordId", getOldOrderID);
	              orderLedgerMapper.getOderOutsInfo(params);
	              EgovMap map = (EgovMap) ((ArrayList) params.get("p1")).get(0);

	              BigDecimal valiOutStanding = new BigDecimal((String) map.get("ordOtstndMth"));
	              valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);

	              if (valiOutStanding.compareTo(BigDecimal.ZERO) > 2) {
	                msg = msg + " -Outstanding payment more than 2 months not allowed for I-Care promo. <br/>";
	                isInValid = "InValid";
	              }

	              EgovMap ValiRentInstNo = orderRegisterMapper.selectRentalInstNo(getOldOrderID);

	              if (ValiRentInstNo != null) {
	                if (Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) <= 6) {
	                  msg = msg + " -Below 6th months not allowed to entitle I-Care Promo. <br/>";
	                  isInValid = "Valid";
	                } else if (Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) > 60) {
	                  msg = msg + " -Above 60th months not allowed to entitle I-Care Promo. <br/>";
	                  isInValid = "Valid";
	                }
	              }

	              if (Integer.parseInt(String.valueOf(validateRentOutright.get("typeId"))) != 964) {
	                msg = msg + " -Only Individual Customer is allowed.";
	                isInValid = "InValid";
	              }

	              if (custId != Integer.parseInt(String.valueOf(validateRentOutright.get("custId")))) {
	                msg = msg + " -Different Customer is not allowed.";
	                isInValid = "InValid";
	              }

	              ROOT_STATE = (isInValid.equals("InValid")) ? "ROOT_9" : "ROOT_10";

	              txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
	                  + (String) promoMap.get("promoDesc");
	            } else {
	              ROOT_STATE = "ROOT_5";
	            }
	          } else if (SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT == Integer
	              .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))
	              || SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT == Integer
	                  .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) { // outright,Installment

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
	      } else {
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
		    EgovMap result = orderRegisterMapper.selectVerifyOldSalesOrderNoValidity(getOldOrderID);
		    return result == null ? true : false;
		  }

	  private boolean isVerifyOldSalesOrderNoValidityICare(int getOldOrderID) {
		    EgovMap result = orderRegisterMapper.selectVerifyOldSalesOrderNoValidityICare(getOldOrderID);
		    return result == null ? true : false;
		  }

	  private boolean isVerifyOldSalesOrderRentalScheme(int getOldOrderID, int iCare) {
	    Map<String, Object> params = new HashMap<String, Object>();

	    params.put("value", getOldOrderID);
	    params.put("iCare", iCare);

	    EgovMap result = orderRegisterMapper.selectSalesOrderRentalScheme(params);
	    return result != null ? true : false;
	  }

	  private EgovMap selectSalesOrderM(int getOldOrderID, int appTypeId) {
	    Map<String, Object> params = new HashMap<String, Object>();

	    params.put("salesOrdId", getOldOrderID);
	    params.put("appTypeId", appTypeId);

	    EgovMap result = orderRegisterMapper.selectSalesOrderM(params);

	    return result;
	  }


	public EgovMap checkExtradeSchedule() {
			return preOrderMapper.checkExtradeSchedule();
		}

	private void checkVoucherValideKeyIn(String voucherCode)
	{
        Map<String, Object> voucherParams = new HashMap();
        voucherParams.put("voucherCode", voucherCode);
		int valid = voucherMapper.isVoucherValidToApply(voucherParams);
		if(valid == 0){
			throw new ApplicationException(AppConstants.FAIL, "Voucher applied is not a valid voucher");
		}
		int eKeyInValid = voucherMapper.isVoucherValidToApplyIneKeyIn(voucherParams);
		if(eKeyInValid == 0){
			throw new ApplicationException(AppConstants.FAIL, "Voucher is applied on other e-KeyIn orders");
		}
	}
}
