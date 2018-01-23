package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.math.MathContext;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billing.service.impl.ProductLostBillingMapper;
import com.coway.trust.biz.payment.billinggroup.service.impl.BillingGroupMapper;
import com.coway.trust.biz.sales.ccp.impl.CcpCalculateMapper;
import com.coway.trust.biz.sales.customer.impl.CustomerMapper;
import com.coway.trust.biz.sales.mambership.impl.MembershipQuotationMapper;
import com.coway.trust.biz.sales.order.OrderRequestService;
import com.coway.trust.biz.sales.order.vo.AccOrderBillVO;
import com.coway.trust.biz.sales.order.vo.AccTRXVO;
import com.coway.trust.biz.sales.order.vo.AccTaxInvoiceOutrightVO;
import com.coway.trust.biz.sales.order.vo.AccTaxInvoiceOutright_SubVO;
import com.coway.trust.biz.sales.order.vo.AccTradeLedgerVO;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterHistoryVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterVO;
import com.coway.trust.biz.sales.order.vo.DiscountEntryVO;
import com.coway.trust.biz.sales.order.vo.InstallResultVO;
import com.coway.trust.biz.sales.order.vo.InstallationVO;
import com.coway.trust.biz.sales.order.vo.InvStkMovementVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvConfigVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvFilterVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvPeriodVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvSettingVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderSchemeConversionVO;
import com.coway.trust.biz.sales.order.vo.SalesReqCancelVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigFilterVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigPeriodVO;
import com.coway.trust.biz.sales.order.vo.SrvMembershipSalesVO;
import com.coway.trust.biz.sales.order.vo.StkReturnEntryVO;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import com.coway.trust.biz.services.installation.impl.InstallationResultListMapper;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;
import com.googlecode.mp4parser.h264.Debug;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderRequestService")
public class OrderRequestServiceImpl implements OrderRequestService {

	private static Logger logger = LoggerFactory.getLogger(OrderRequestServiceImpl.class);
	
	@Resource(name = "orderRequestMapper")
	private OrderRequestMapper orderRequestMapper;
	
	@Resource(name = "orderRegisterMapper")
	private OrderRegisterMapper orderRegisterMapper;
	
	@Resource(name = "orderModifyMapper")
	private OrderModifyMapper orderModifyMapper;
	
	@Resource(name = "ccpCalculateMapper")
	private CcpCalculateMapper ccpCalculateMapper;
	
	@Resource(name = "membershipQuotationMapper")
	private MembershipQuotationMapper membershipQuotationMapper;
	
	@Resource(name = "installationResultListMapper")
	private InstallationResultListMapper installationResultListMapper;
	
	@Resource(name = "productLostMapper")
	private ProductLostBillingMapper productLostMapper;
	
	@Resource(name = "customerMapper")
	private CustomerMapper customerMapper;
	
	@Resource(name = "orderDetailMapper")
	private OrderDetailMapper orderDetailMapper;
	
	@Resource(name = "billingGroupMapper")
	private BillingGroupMapper billingGroupMapper;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Override
	public List<EgovMap> selectResnCodeList(Map<String, Object> params) {
		return orderRequestMapper.selectResnCodeList(params);
	}

	@Override
	public EgovMap selectOrderLastRentalBillLedger1(Map<String, Object> params) {
		return orderRequestMapper.selectOrderLastRentalBillLedger1(params);
	}
	
	private void preprocSalesOrderExchange(SalesOrderExchangeVO salesOrderExchangeVO, Map<String, Object> params, SessionVO sessionVO, String ordReqType) {
		
		salesOrderExchangeVO.setSoExchgId(0);
		salesOrderExchangeVO.setSoId(CommonUtils.intNvl((String)params.get("salesOrdId")));
		
		if(SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
			salesOrderExchangeVO.setSoExchgTypeId(283);
			salesOrderExchangeVO.setSoExchgStusId(SalesConstants.STATUS_ACTIVE);
			salesOrderExchangeVO.setSoExchgResnId(CommonUtils.intNvl((String)params.get("cmbReason")));
			salesOrderExchangeVO.setSoCurStusId((int)params.get("stusCodeId") == 4 ? 25 :24);
			salesOrderExchangeVO.setInstallEntryId(0);
			salesOrderExchangeVO.setSoExchgOldAppTypeId((int)params.get("appTypeId"));
			salesOrderExchangeVO.setSoExchgNwAppTypeId((int)params.get("appTypeId"));
			salesOrderExchangeVO.setSoExchgOldStkId(CommonUtils.intNvl((String)params.get("hiddenCurrentProductID")));
			salesOrderExchangeVO.setSoExchgNwStkId(CommonUtils.intNvl((String)params.get("cmbOrderProduct")));
			salesOrderExchangeVO.setSoExchgOldPrcId(0);
			salesOrderExchangeVO.setSoExchgNwPrcId(CommonUtils.intNvl((String)params.get("hiddenPriceID")));
			salesOrderExchangeVO.setSoExchgOldPrc(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwPrc(new BigDecimal((String)params.get("ordPrice")));
			salesOrderExchangeVO.setSoExchgOldPv(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwPv(new BigDecimal((String)params.get("ordPv")));
			salesOrderExchangeVO.setSoExchgOldRentAmt(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwRentAmt(new BigDecimal((String)params.get("ordRentalFees")));
			salesOrderExchangeVO.setSoExchgOldPromoId(CommonUtils.intNvl((String)params.get("hiddenCurrentPromotionID")));
			salesOrderExchangeVO.setSoExchgNwPromoId("1".equals((String)params.get("btnCurrentPromo")) ? CommonUtils.intNvl((String)params.get("hiddenCurrentPromotionID"))
					                                                                                   : CommonUtils.intNvl((String)params.get("cmbPromotion")));
			salesOrderExchangeVO.setSoExchgCrtUserId(sessionVO.getUserId());
			salesOrderExchangeVO.setSoExchgUpdUserId(sessionVO.getUserId());
			salesOrderExchangeVO.setSoExchgOldSrvConfigId(0);
			salesOrderExchangeVO.setSoExchgNwSrvConfigId(0);
			salesOrderExchangeVO.setSoExchgOldCallEntryId(0);
			salesOrderExchangeVO.setSoExchgNwCallEntryId(0);
			salesOrderExchangeVO.setSoExchgStkRetMovId(0);
			salesOrderExchangeVO.setSoExchgRem((String)params.get("txtRemark"));
			salesOrderExchangeVO.setSoExchgOldDefRentAmt(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwDefRentAmt(new BigDecimal((String)params.get("ordRentalFees")));
			salesOrderExchangeVO.setSoExchgUnderFreeAsId(CommonUtils.intNvl((String)params.get("hiddenFreeASID")));
			salesOrderExchangeVO.setSoExchgOldCustId(0);
			salesOrderExchangeVO.setSoExchgNwCustId(0);
		}
		else if(SalesConstants.ORDER_REQ_TYPE_CD_AEXC.equals(ordReqType)) {
			salesOrderExchangeVO.setSoExchgTypeId(282);
			salesOrderExchangeVO.setSoExchgStusId(SalesConstants.STATUS_COMPLETED);
			salesOrderExchangeVO.setSoExchgResnId(CommonUtils.intNvl((String)params.get("cmbReason")));
			salesOrderExchangeVO.setSoCurStusId(CommonUtils.intNvl(params.get("stusCodeId")) == 4 ? 25 :24);
			salesOrderExchangeVO.setInstallEntryId(0);
			salesOrderExchangeVO.setSoExchgOldAppTypeId(CommonUtils.intNvl(params.get("appTypeId")));
			salesOrderExchangeVO.setSoExchgNwAppTypeId(CommonUtils.intNvl(params.get("cmbAppType")));
			salesOrderExchangeVO.setSoExchgOldStkId(0);
			salesOrderExchangeVO.setSoExchgNwStkId(CommonUtils.intNvl(params.get("hiddenProductID")));
			salesOrderExchangeVO.setSoExchgOldPrcId(0);
	        salesOrderExchangeVO.setSoExchgNwPrcId(CommonUtils.intNvl(params.get("ordPriceId")));
			salesOrderExchangeVO.setSoExchgOldPrc(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwPrc(new BigDecimal((String)params.get("txtPrice")));
			salesOrderExchangeVO.setSoExchgOldPv(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwPv(new BigDecimal((String)params.get("txtPV")));
			salesOrderExchangeVO.setSoExchgOldRentAmt(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwRentAmt(new BigDecimal((String)params.get("ordRentalFees")));
			salesOrderExchangeVO.setSoExchgOldPromoId(0);
			salesOrderExchangeVO.setSoExchgNwPromoId(CommonUtils.intNvl((String)params.get("cmbPromotion")));
			salesOrderExchangeVO.setSoExchgCrtUserId(sessionVO.getUserId());
			salesOrderExchangeVO.setSoExchgUpdUserId(sessionVO.getUserId());
			salesOrderExchangeVO.setSoExchgOldSrvConfigId(0);
			salesOrderExchangeVO.setSoExchgNwSrvConfigId(0);
			salesOrderExchangeVO.setSoExchgOldCallEntryId(0);
			salesOrderExchangeVO.setSoExchgNwCallEntryId(0);
			salesOrderExchangeVO.setSoExchgStkRetMovId(0);
			salesOrderExchangeVO.setSoExchgRem((String)params.get("txtRemark"));
			salesOrderExchangeVO.setSoExchgOldDefRentAmt(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwDefRentAmt(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgUnderFreeAsId(0);
			salesOrderExchangeVO.setSoExchgOldCustId(0);
			salesOrderExchangeVO.setSoExchgNwCustId(0);
		}
		else if(SalesConstants.ORDER_REQ_TYPE_CD_OTRN.equals(ordReqType)) {

			salesOrderExchangeVO.setSoExchgTypeId(284);
			salesOrderExchangeVO.setSoExchgStusId(SalesConstants.STATUS_COMPLETED);
			salesOrderExchangeVO.setSoExchgResnId(0);
			salesOrderExchangeVO.setSoCurStusId(25);
			salesOrderExchangeVO.setInstallEntryId(0);
			salesOrderExchangeVO.setSoExchgOldAppTypeId(0);
			salesOrderExchangeVO.setSoExchgNwAppTypeId(0);
			salesOrderExchangeVO.setSoExchgOldStkId(0);
			salesOrderExchangeVO.setSoExchgNwStkId(0);
			salesOrderExchangeVO.setSoExchgOldPrcId(0);
	        salesOrderExchangeVO.setSoExchgNwPrcId(0);
			salesOrderExchangeVO.setSoExchgOldPrc(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwPrc(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgOldPv(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwPv(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgOldRentAmt(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwRentAmt(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgOldPromoId(0);
			salesOrderExchangeVO.setSoExchgNwPromoId(0);
			salesOrderExchangeVO.setSoExchgCrtUserId(sessionVO.getUserId());
			salesOrderExchangeVO.setSoExchgUpdUserId(sessionVO.getUserId());
			salesOrderExchangeVO.setSoExchgOldSrvConfigId(0);
			salesOrderExchangeVO.setSoExchgNwSrvConfigId(0);
			salesOrderExchangeVO.setSoExchgOldCallEntryId(0);
			salesOrderExchangeVO.setSoExchgNwCallEntryId(0);
			salesOrderExchangeVO.setSoExchgStkRetMovId(0);
			salesOrderExchangeVO.setSoExchgRem("");
			salesOrderExchangeVO.setSoExchgOldDefRentAmt(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgNwDefRentAmt(BigDecimal.ZERO);
			salesOrderExchangeVO.setSoExchgUnderFreeAsId(0);
			salesOrderExchangeVO.setSoExchgOldCustId(CommonUtils.intNvl(params.get("hiddenCurrentCustID")));
			salesOrderExchangeVO.setSoExchgNwCustId(CommonUtils.intNvl(params.get("txtHiddenCustID")));
			salesOrderExchangeVO.setSoExchgFormNo((String)params.get("txtReferenceNo"));
		}
	}
	
    private void preprocStkMovementMaster(InvStkMovementVO invStkMovementVO, Map<String, Object> params, SessionVO sessionVO) {
    	
    	invStkMovementVO.setMovId(0);
    	invStkMovementVO.setInstallEntryId(0);
    	invStkMovementVO.setMovFromLocId(0);
    	invStkMovementVO.setMovToLocId(0);
    	invStkMovementVO.setMovTypeId(264);
    	invStkMovementVO.setMovStusId(SalesConstants.STATUS_ACTIVE);
    	invStkMovementVO.setMovCnfm(0);
    	invStkMovementVO.setMovCrtUserId(sessionVO.getUserId());
    	invStkMovementVO.setMovUpdUserId(sessionVO.getUserId());
    	invStkMovementVO.setStkCrdPost(SalesConstants.IS_FALSE);
    	invStkMovementVO.setStkCrdPostDt(SalesConstants.DEFAULT_DATE);
    	invStkMovementVO.setStkCrdPostToWebOnTm(SalesConstants.IS_FALSE);
    }

    private void preprocStkReturnMaster(StkReturnEntryVO stkReturnEntryVO, Map<String, Object> params, SessionVO sessionVO) {

    	stkReturnEntryVO.setStkRetnId(0);
    	stkReturnEntryVO.setRetnNo("");
    	stkReturnEntryVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
    	stkReturnEntryVO.setTypeId(297);
    	stkReturnEntryVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    	stkReturnEntryVO.setMovId(0);
    	stkReturnEntryVO.setCrtUserId(sessionVO.getUserId());
    	stkReturnEntryVO.setUpdUserId(sessionVO.getUserId());
    	stkReturnEntryVO.setRefId(0);
    	stkReturnEntryVO.setStockId(0);
    	stkReturnEntryVO.setIsSynch(SalesConstants.IS_FALSE);
    	stkReturnEntryVO.setAppDt(SalesConstants.DEFAULT_DATE);
    	stkReturnEntryVO.setCtId(0);
    	stkReturnEntryVO.setCtGrp("");;
    	stkReturnEntryVO.setCallEntryId(0);
    }
    
    private void preprocSrvMembershipSales(SrvMembershipSalesVO srvMembershipSalesVO, Map<String, Object> params, SessionVO sessionVO) throws Exception {

        params.put("SELPACKAGE_ID", 3);
        params.put("STOCK_ID", CommonUtils.intNvl((String)params.get("hiddenProductID")));
        
		EgovMap memMap = membershipQuotationMapper.mPackageInfo(params);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date defaultDate = sdf.parse(SalesConstants.DEFAULT_DATE2);
		
		srvMembershipSalesVO.setSrvMemId(0);
		srvMembershipSalesVO.setSrvMemQuotId(0);
		srvMembershipSalesVO.setSrvSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
		srvMembershipSalesVO.setSrvMemNo("");
		srvMembershipSalesVO.setSrvMemBillNo("");
		srvMembershipSalesVO.setSrvMemPacId(3);
		srvMembershipSalesVO.setSrvMemPacAmt(BigDecimal.ZERO);
		srvMembershipSalesVO.setSrvMemBsAmt(BigDecimal.ZERO);
		srvMembershipSalesVO.setSrvMemPv(0);
		srvMembershipSalesVO.setSrvFreq(CommonUtils.intNvl(memMap.get("srvMemItmPriod")));
		srvMembershipSalesVO.setSrvStartDt(defaultDate);
		srvMembershipSalesVO.setSrvExprDt(defaultDate);
		srvMembershipSalesVO.setSrvDur(12);
		srvMembershipSalesVO.setSrvStusCodeId(SalesConstants.STATUS_COMPLETED);
		srvMembershipSalesVO.setSrvRem((String)params.get("txtRemark"));
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
    }
    
    private void preprocSalesOrderM(SalesOrderMVO salesOrderMVO, Map<String, Object> params, SessionVO sessionVO, String ordReqType) throws Exception {
    	
    	if(SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
            salesOrderMVO.setSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
            salesOrderMVO.setTotAmt(new BigDecimal(String.valueOf(params.get("ordPrice"))));
            salesOrderMVO.setTotPv(new BigDecimal(String.valueOf(params.get("ordPv"))));
            salesOrderMVO.setMthRentAmt(new BigDecimal(String.valueOf(params.get("ordRentalFees"))));
            salesOrderMVO.setDefRentAmt(new BigDecimal(String.valueOf(params.get("ordRentalFees"))));
            salesOrderMVO.setPromoId("1".equals((String)params.get("btnCurrentPromo")) ? CommonUtils.intNvl(params.get("hiddenCurrentPromotionID"))
                    																   : CommonUtils.intNvl(params.get("cmbPromotion")));
            salesOrderMVO.setUpdUserId(sessionVO.getUserId());
            salesOrderMVO.setPromoDiscPeriodTp(CommonUtils.intNvl(params.get("promoDiscPeriodTp")));
            salesOrderMVO.setPromoDiscPeriod(CommonUtils.intNvl(params.get("promoDiscPeriod")));
            salesOrderMVO.setNorAmt(new BigDecimal(String.valueOf(params.get("orgOrdPrice"))));
            salesOrderMVO.setNorRntFee(new BigDecimal(String.valueOf(params.get("orgOrdRentalFees"))));
            salesOrderMVO.setDiscRntFee(new BigDecimal(String.valueOf(params.get("ordRentalFees"))));
    /*
            SalesOrderM.TotalAmt = double.Parse(txtPrice.Text.Trim());
            SalesOrderM.TotalPV = double.Parse(txtPV.Text.Trim());
            SalesOrderM.MthRentAmt = double.Parse(txtOrderRentalFees.Text.Trim());
            SalesOrderM.DefRentAmt = double.Parse(txtOrderRentalFees.Text.Trim());
            SalesOrderM.PromoID = btnCurrentPromo.Checked ? int.Parse(hiddenCurrentPromotionID.Value) : int.Parse(cmbPromotion.SelectedValue);
*/
    	}
    	else if(SalesConstants.ORDER_REQ_TYPE_CD_AEXC.equals(ordReqType)) {
    		
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    		Date defaultDate = sdf.parse(SalesConstants.DEFAULT_DATE2);
    		
    		salesOrderMVO.setSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
    		salesOrderMVO.setRefNo("");
    		salesOrderMVO.setSalesDt(defaultDate);
//          salesOrderMaster.CustomerID = int.Parse(hiddenCustomerID.Value);
    		salesOrderMVO.setCustCntId(0);
    		salesOrderMVO.setCustAddId(0);
    		salesOrderMVO.setMemId(0);
    		salesOrderMVO.setBrnchId(0);
    		salesOrderMVO.setAppTypeId(CommonUtils.intNvl(params.get("cmbAppType")));
    		salesOrderMVO.setDscntAmt(BigDecimal.ZERO);
    		salesOrderMVO.setTaxAmt(BigDecimal.ZERO);
    		salesOrderMVO.setPromoId(CommonUtils.intNvl(params.get("cmbPromotion")));
    		salesOrderMVO.setBindingNo("");
    		salesOrderMVO.setCcPromoId(0);
    		salesOrderMVO.setRem("");
    		salesOrderMVO.setPvMonth(0);
    		salesOrderMVO.setPvYear(0);
    		salesOrderMVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
    		salesOrderMVO.setUpdUserId(sessionVO.getUserId());
    		salesOrderMVO.setSyncChk(SalesConstants.IS_FALSE);
    		salesOrderMVO.setCustPoNo("");
    		salesOrderMVO.setRenChkId(0);
    		salesOrderMVO.setInstPriod(CommonUtils.intNvl(params.get("cmbAppType")) == 68 ? CommonUtils.intNvl(params.get("txtInstallmentDuration")) : 0);
    		salesOrderMVO.setDoNo("");
    		salesOrderMVO.setDeptCode("");;
    		salesOrderMVO.setGrpCode("");
    		salesOrderMVO.setOrgCode("");
    		salesOrderMVO.setSalesOrdIdOld(0);
    		salesOrderMVO.setEditTypeId(0);
    		salesOrderMVO.setCustBillId(0);
    		salesOrderMVO.setMthRentAmt(BigDecimal.ZERO);
    		salesOrderMVO.setLok(SalesConstants.IS_FALSE);
    		salesOrderMVO.setAeonStusId(0);
    		salesOrderMVO.setCommDt(SalesConstants.DEFAULT_DATE2);
    		salesOrderMVO.setCrtUserId(sessionVO.getUserId());
    		salesOrderMVO.setPayComDt(SalesConstants.DEFAULT_DATE2);
    		salesOrderMVO.setDefRentAmt(BigDecimal.ZERO);
    		salesOrderMVO.setRefDocId(0);
    		salesOrderMVO.setRentPromoId(0);
    		salesOrderMVO.setSalesHmId(0);
    		salesOrderMVO.setSalesSmId(0);
    		salesOrderMVO.setSalesGmId(0);
    	}
    	else if(SalesConstants.ORDER_REQ_TYPE_CD_OTRN.equals(ordReqType)) {
    		
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    		Date defaultDate = sdf.parse(SalesConstants.DEFAULT_DATE2);
    		
    		salesOrderMVO.setSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
    		salesOrderMVO.setSalesOrdNo("");    		
    		salesOrderMVO.setRefNo("");    		
    	  //salesOrderMVO.setSalesDt(defaultDate); //DateTime.Now;
    		salesOrderMVO.setCustId(CommonUtils.intNvl(params.get("txtHiddenCustID")));
    		salesOrderMVO.setCustCntId(CommonUtils.intNvl(params.get("txtHiddenContactID")));
    		salesOrderMVO.setCustAddId(CommonUtils.intNvl(params.get("txtHiddenAddressID")));
    		salesOrderMVO.setMemId(0);
    		salesOrderMVO.setBrnchId(0);
    		salesOrderMVO.setAppTypeId(CommonUtils.intNvl(params.get("hiddenAppTypeID")));
    		salesOrderMVO.setDscntAmt(BigDecimal.ZERO);
    		salesOrderMVO.setTaxAmt(BigDecimal.ZERO);
    		salesOrderMVO.setTotAmt(BigDecimal.ZERO);
    		salesOrderMVO.setPromoId(0);    		
    		salesOrderMVO.setBindingNo("");    		
    		salesOrderMVO.setCcPromoId(0);    		
    		salesOrderMVO.setRem("");
    		salesOrderMVO.setPvMonth(0);
    		salesOrderMVO.setPvYear(0);    		
    		salesOrderMVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);    		
    		salesOrderMVO.setUpdUserId(sessionVO.getUserId());
    		salesOrderMVO.setSyncChk(SalesConstants.IS_FALSE);    		
    		salesOrderMVO.setCustPoNo("");
    		salesOrderMVO.setRenChkId(0);
    		salesOrderMVO.setInstPriod(0);
    		salesOrderMVO.setDoNo("");
    		salesOrderMVO.setDeptCode("");;
    		salesOrderMVO.setGrpCode("");
    		salesOrderMVO.setOrgCode("");
    		salesOrderMVO.setSalesOrdIdOld(0);
    		salesOrderMVO.setEditTypeId(0);
    		salesOrderMVO.setCustBillId(CommonUtils.intNvl(params.get("hiddenAppTypeID")) == SalesConstants.APP_TYPE_CODE_ID_RENTAL ? "new".equals((String)params.get("btnBillGroup")) ? 0 : CommonUtils.intNvl(params.get("txtHiddenBillGroupID")) : 0);
    		salesOrderMVO.setMthRentAmt(BigDecimal.ZERO);
    		salesOrderMVO.setLok(SalesConstants.IS_FALSE);
    		salesOrderMVO.setAeonStusId(0);
    		salesOrderMVO.setCommDt(SalesConstants.DEFAULT_DATE2);
    		salesOrderMVO.setCrtUserId(sessionVO.getUserId());
    		salesOrderMVO.setPayComDt(SalesConstants.DEFAULT_DATE2);
    		salesOrderMVO.setDefRentAmt(BigDecimal.ZERO);
    		salesOrderMVO.setRefDocId(0);
    		salesOrderMVO.setRentPromoId(0);
    		salesOrderMVO.setSalesHmId(0);
    		salesOrderMVO.setSalesSmId(0);
    		salesOrderMVO.setSalesGmId(0);
    	}
    }
    
    private void preprocSalesOrderD(SalesOrderDVO salesOrderDVO, Map<String, Object> params, SessionVO sessionVO) {
    	
    	salesOrderDVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    	salesOrderDVO.setItmStkId(CommonUtils.intNvl((String)params.get("cmbOrderProduct")));
    	salesOrderDVO.setItmPrcId(CommonUtils.intNvl((String)params.get("hiddenPriceID")));
    	salesOrderDVO.setItmPrc(new BigDecimal((String)params.get("ordPrice")));
    	salesOrderDVO.setItmPv(new BigDecimal((String)params.get("ordPv")));
    	salesOrderDVO.setUpdUserId(sessionVO.getUserId());
/*
        OrderID = Request["OrderID"] != null ? Request["OrderID"].ToString() : string.Empty;
        SalesOrderD.SalesOrderID = int.Parse(OrderID);
        SalesOrderD.ItemStkID = int.Parse(cmbOrderProduct.SelectedValue);
        SalesOrderD.ItemPriceID = int.Parse(hiddenPriceID.Value);
        SalesOrderD.ItemPrice = int.Parse(hiddenPriceID.Value);
        SalesOrderD.ItemPV = double.Parse(txtPV.Text.Trim());
        SalesOrderD.Updator = li.UserID;
        SalesOrderD.Updated = DateTime.Now;
*/
    }

    private void preprocSalesOrderSchemeConversion(SalesOrderSchemeConversionVO salesOrderSchemeConversionVO, Map<String, Object> params, SessionVO sessionVO) {
    	EgovMap schmMap = orderRequestMapper.selectSchemePriceSettingByPromoCode(params);
/*
        conversion.SalesOrderID = int.Parse(hidOrderID.Value);
        conversion.SalesAppTypeID = int.Parse(hidOrderAppTypeID.Value);
        conversion.SalesOrderPromoID = int.Parse(hidOrderPromoID.Value);
        conversion.SalesOrderPreRPF = sps.SchemeNormalRPF;
        conversion.SalesOrderPrePrice = sps.SchemeNormalPrice;
        conversion.SalesOrderPrePV = Convert.ToInt32(sps.SchemeNormalPV);
        conversion.SalesOrderPreSrvFreq = sps.SchemeNormalServiceFreq;
        conversion.SalesOrderNewRPF = sps.SchemeRPF;
        conversion.SalesOrderNewPrice = sps.SchemePrice;
        conversion.SalesOrderNewPV = Convert.ToInt32(sps.SchemePV);
        conversion.SalesOrderNewSrvFreq = sps.SchemeServiceFreq;
        conversion.ConversionStatusID = sps.SchemePriceStatusID;
        conversion.ConversionRemark = txtRemark.Text.Trim();
        conversion.ConversionCreator = li.UserID;
        conversion.ConversionCreated = DateTime.Now;
        conversion.ConversionSchemeID = int.Parse(cmbScheme.SelectedValue);
 */
    	salesOrderSchemeConversionVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    	salesOrderSchemeConversionVO.setSalesAppTypeId(CommonUtils.intNvl((String)params.get("appTypeId")));
    	salesOrderSchemeConversionVO.setSalesOrdPromoId(CommonUtils.intNvl((String)params.get("schemePromoId")));
    	salesOrderSchemeConversionVO.setSalesOrdPreRpf((BigDecimal)schmMap.get("schemeNormalRpf"));
    	salesOrderSchemeConversionVO.setSalesOrdPrePrc((BigDecimal)schmMap.get("schemeNormalPrc"));
    	salesOrderSchemeConversionVO.setSalesOrdPrePv((BigDecimal)schmMap.get("schemeNormalPv"));
    	salesOrderSchemeConversionVO.setSalesOrdPreSrvFreq(Integer.parseInt(String.valueOf((BigDecimal)schmMap.get("schemeNormalSvcFreq"))));
    	salesOrderSchemeConversionVO.setSalesOrdNwRpf((BigDecimal)schmMap.get("schemeRpf"));
    	salesOrderSchemeConversionVO.setSalesOrdNwPrc((BigDecimal)schmMap.get("schemePrc"));
    	salesOrderSchemeConversionVO.setSalesOrdNwPv((BigDecimal)schmMap.get("schemePv"));
    	salesOrderSchemeConversionVO.setSalesOrdNwSrvFreq(Integer.parseInt(String.valueOf((BigDecimal)schmMap.get("schemeSvcFreq"))));
    	salesOrderSchemeConversionVO.setCnvrStusId(Integer.parseInt(String.valueOf((BigDecimal)schmMap.get("schemePrcStusId"))));
    	salesOrderSchemeConversionVO.setCnvrRem((String)params.get("txtRemark"));
    	salesOrderSchemeConversionVO.setCnvrCrtUserId(sessionVO.getUserId());
    	salesOrderSchemeConversionVO.setCnvrSchemeId(CommonUtils.intNvl((String)params.get("cmbScheme")));
    }
    
    private void preprocDiscountEntry(DiscountEntryVO discountEntryVO, SalesOrderSchemeConversionVO salesOrderSchemeConversionVO, Map<String, Object> params, SessionVO sessionVO) {
/*
        Data.LoginInfo li = Session["login"] as Data.LoginInfo;
        DiscountEntry discount = new DiscountEntry();
        Orders oo = new Orders();
        discount.OrderID = int.Parse(hidOrderID.Value);
        discount.DCType = 765;
        discount.DCAmountPerInstallment = Convert.ToDouble(conversion.SalesOrderPrePrice - conversion.SalesOrderNewPrice);
        discount.DCStartInstallment = oo.GetRentalInstStartMonth(int.Parse(hidOrderID.Value));
        discount.DCEndInstallment = 60;
        discount.Remarks = "Scheme Conversion - " + cmbScheme.Text.Trim();
        discount.CreatedAt = DateTime.Now;
        discount.CreatedBy = li.UserID;
        discount.DCStatusID = 1;
        discount.ContractID = 0;
*/
    	EgovMap rMap = orderRequestMapper.selectRentalInstStartMonth(params);
    	
    	discountEntryVO.setOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    	discountEntryVO.setDcType(765);
    	discountEntryVO.setDcAmtPerInstlmt(salesOrderSchemeConversionVO.getSalesOrdPrePrc().subtract(salesOrderSchemeConversionVO.getSalesOrdNwPrc()));
    	discountEntryVO.setDcStartInstlmt(rMap == null ? 0 : Integer.parseInt(String.valueOf((BigDecimal)rMap.get("rentInstNo"))));
    	discountEntryVO.setDcEndInstlmt(60);
    	discountEntryVO.setRem("Scheme Conversion - " + (String)params.get("cmbSchemeSchmText"));
    	discountEntryVO.setCrtUserId(sessionVO.getUserId());
    	discountEntryVO.setDcStusId(SalesConstants.STATUS_ACTIVE);
    	discountEntryVO.setCntrctId(0);
    }
    
    private List<EgovMap> preprocSrvConfigFilter(List<EgovMap> partList, SalesOrderSchemeConversionVO conversion, Map<String, Object> params, SessionVO sessionVO) {
    	
    	List<EgovMap> filterList = orderRequestMapper.selectSrvConfigFilterList(params);

    	for(EgovMap pMap : partList) {
    		for(EgovMap fMap : filterList) {
    			if(Integer.parseInt(String.valueOf((BigDecimal)fMap.get("srvFilterStkId"))) == Integer.parseInt(String.valueOf((BigDecimal)pMap.get("schemeStockId"))) 
    					&& Integer.parseInt(String.valueOf((BigDecimal)fMap.get("srvFilterPriod"))) != Integer.parseInt(String.valueOf((BigDecimal)pMap.get("schemePartPriod")))) {
    				fMap.put("srvFilterPriod", (int)pMap.get("schemePartPriod"));
    				fMap.put("srvFilterUpdUserId", 349);
    				fMap.put("srvFilterRem", "Scheme Conversion - " + (String)params.get("cmbSchemeSchmText"));
    			}
    		}
    	}
    	
    	boolean isExist;
    	
    	for(EgovMap pMap : partList) {
    		
    		isExist = false;
    		
    		for(EgovMap fMap : filterList) {
    			if(Integer.parseInt(String.valueOf((BigDecimal)fMap.get("srvFilterStkId"))) == Integer.parseInt(String.valueOf((BigDecimal)pMap.get("schemeStockId")))
    					&& Integer.parseInt(String.valueOf((BigDecimal)fMap.get("srvFilterPriod"))) == Integer.parseInt(String.valueOf((BigDecimal)pMap.get("schemePartPriod")))) {
    				isExist = true;
    			}
    		}
    		
    		logger.debug("isExist:"+isExist);
    		
    		if(!isExist) {
    			EgovMap newMap = new EgovMap();
    			
    			newMap.put("srvFilterId", 0);
    			newMap.put("srvConfigId", 0);
    			newMap.put("srvFilterStkId", Integer.parseInt(String.valueOf((BigDecimal)pMap.get("schemeStockId"))));
    			newMap.put("srvFilterPriod", Integer.parseInt(String.valueOf((BigDecimal)pMap.get("schemePartPriod"))));
    			newMap.put("srvFilterStusId", SalesConstants.STATUS_ACTIVE);
    			newMap.put("srvFilterRem", "Scheme Conversion - " + (String)params.get("cmbSchemeSchmText"));
    			newMap.put("srvFilterPrvChgDt", SalesConstants.DEFAULT_DATE);
    			newMap.put("srvFilterCrtUserId", 349);
    			newMap.put("srvFilterExprDt", SalesConstants.DEFAULT_DATE);
    			
    			filterList.add(newMap);
    		}
    	}
    	
    	return filterList;
    }
    
    private void preprocSrvMembershipSalesList(List<EgovMap> svmList, SalesOrderSchemeConversionVO conversion, Map<String, Object> params, SessionVO sessionVO) {

    	if(svmList != null) {
    		for(EgovMap eMap : svmList) {
    			eMap.put("srvFreq", conversion.getSalesOrdNwSrvFreq());
    			eMap.put("srvUpdUserId", sessionVO.getUserId());
    			eMap.put("srvRem", "Scheme Conversion - " + (String)params.get("cmbSchemeSchmText"));
    		}
    	}
    }
    
    private void preprocSrvConfigPeriodList(List<EgovMap> periodList, SalesOrderSchemeConversionVO conversion, Map<String, Object> params, SessionVO sessionVO) {

    	if(periodList != null) {
    		for(EgovMap eMap : periodList) {
    			eMap.put("srvPrdDur", conversion.getSalesOrdNwSrvFreq());
    			eMap.put("srvPrdUpdUserId", sessionVO.getUserId());
    			eMap.put("srvPrdRem", "Scheme Conversion - " + (String)params.get("cmbSchemeSchmText"));
    		}
    	}
    }
    
    private void preprocSalesOrderM(SalesOrderMVO som, SalesOrderSchemeConversionVO conversion, Map<String, Object> params, SessionVO sessionVO) {

    	som.setSalesOrdId(conversion.getSalesOrdId());
    	som.setTotPv(conversion.getSalesOrdNwPv());
    	som.setTotAmt(conversion.getSalesOrdNwRpf());
    	som.setUpdUserId(sessionVO.getUserId());
    	som.setRem("Scheme Conversion - " + (String)params.get("cmbSchemeSchmText"));
    	som.setCnvrSchemeId(CommonUtils.intNvl((String)params.get("cmbScheme")));
    }
    
    private void preprocInstallation(InstallationVO installationVO, Map<String, Object> params, SessionVO sessionVO) throws Exception {

    	String PreInstDate = (String)params.get("dpPreferInstDate");
    	
    	installationVO.setInstallId(0);
    	installationVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    	installationVO.setAddId(CommonUtils.intNvl((String)params.get("txtHiddenInstAddressID")));
    	installationVO.setCntId(CommonUtils.intNvl((String)params.get("txtHiddenInstContactID")));
    	installationVO.setPreCallDt(CommonUtils.getAddDay(PreInstDate, -1, SalesConstants.DEFAULT_DATE_FORMAT1));
    	installationVO.setPreDt(PreInstDate);
    	installationVO.setPreTm(this.convert24Tm((String)params.get("tpPreferInstTime")));
    	installationVO.setActDt(SalesConstants.DEFAULT_DATE);
    	installationVO.setActTm(SalesConstants.DEFAULT_TM);
    	installationVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
    	installationVO.setInstct((String)params.get("txtInstSpecialInstruction"));
    	installationVO.setUpdUserId(sessionVO.getUserId());
    	installationVO.setBrnchId(CommonUtils.intNvl((String)params.get("cmbDSCBranch")));
    	installationVO.setEditTypeId(0);
    	installationVO.setIsTradeIn(SalesConstants.IS_FALSE);
    }
    
    private void preprocRentPaySet(RentPaySetVO rentPaySetVO, Map<String, Object> params, SessionVO sessionVO) throws Exception {

    	int rentPaymode = CommonUtils.intNvl(params.get("cmbRentPaymode"));
    	
    	rentPaySetVO.setRentPayId(0);
    	rentPaySetVO.setSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
    	rentPaySetVO.setModeId(rentPaymode);
    	rentPaySetVO.setCustCrcId(rentPaymode == 131 ? CommonUtils.intNvl(params.get("txtHiddenRentPayCRCID"))     : 0);
    	rentPaySetVO.setCustAccId(rentPaymode == 132 ? CommonUtils.intNvl(params.get("txtHiddenRentPayBankAccID")) : 0);
    	rentPaySetVO.setBankId(rentPaymode == 131 ? CommonUtils.intNvl(params.get("hiddenRentPayCRCBankID")) : rentPaymode == 132 ? CommonUtils.intNvl(params.get("hiddenRentPayBankAccBankID")) : 0);
      //rentPaySetMaster.DDApplyDate = DateTime.Now;
    	rentPaySetVO.setDdSubmitDt(SalesConstants.DEFAULT_DATE);
    	rentPaySetVO.setDdStartDt(SalesConstants.DEFAULT_DATE);
    	rentPaySetVO.setDdRejctDt(SalesConstants.DEFAULT_DATE);
    	rentPaySetVO.setFailResnId(0);
    	rentPaySetVO.setUpdUserId(sessionVO.getUserId());
    	rentPaySetVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
    	rentPaySetVO.setIs3rdParty("Y".equals((String)params.get("btnThirdParty")) ? SalesConstants.IS_TRUE : SalesConstants.IS_FALSE);
    	rentPaySetVO.setCustId("Y".equals((String)params.get("btnThirdParty")) ? CommonUtils.intNvl(params.get("txtHiddenThirdPartyID")) : CommonUtils.intNvl(params.get("txtHiddenCustID")));
    	rentPaySetVO.setEditTypeId(0);
    	rentPaySetVO.setNricOld((String)params.get("txtRentPayIC"));
    	rentPaySetVO.setIssuNric(CommonUtils.isNotEmpty(params.get("txtRentPayIC")) ? (String)params.get("txtRentPayIC") : "Y".equals((String)params.get("btnThirdParty")) ? (String)params.get("txtThirdPartyNRIC") : (String)params.get("txtCustIC"));
    	rentPaySetVO.setAeonCnvr(SalesConstants.IS_FALSE);
    	rentPaySetVO.setRem("");
    	rentPaySetVO.setLastApplyUser(sessionVO.getUserId());
    }
    
    private void preprocCustBillMaster(CustBillMasterVO custBillMasterVO, Map<String, Object> params, SessionVO sessionVO) throws Exception {

    	custBillMasterVO.setCustBillId(0);
    	custBillMasterVO.setCustBillSoId(CommonUtils.intNvl(params.get("salesOrdId")));
    	custBillMasterVO.setCustBillCustId(CommonUtils.intNvl(params.get("txtHiddenCustID")));
    	custBillMasterVO.setCustBillCntId(CommonUtils.intNvl(params.get("txtHiddenContactID")));
    	custBillMasterVO.setCustBillAddId(CommonUtils.intNvl(params.get("txtHiddenAddressID")));
    	custBillMasterVO.setCustBillStusId(SalesConstants.STATUS_ACTIVE);
    	custBillMasterVO.setCustBillRem((String)params.get("txtBillGroupRemark"));
      //customerBillMaster.CustBillUpdateAt = DateTime.Now;
    	custBillMasterVO.setCustBillUpdUserId(sessionVO.getUserId());
    	custBillMasterVO.setCustBillGrpNo("");
      //customerBillMaster.CustBillCreateAt = DateTime.Now;
    	custBillMasterVO.setCustBillCrtUserId(sessionVO.getUserId());
    	custBillMasterVO.setCustBillPayTrm(0);
    	custBillMasterVO.setCustBillInchgMemId(0);
    	custBillMasterVO.setCustBillEmail("");
    	custBillMasterVO.setCustBillIsEstm(SalesConstants.IS_FALSE);
    	custBillMasterVO.setCustBillIsSms(CommonUtils.intNvl(params.get("txtHiddenThirdPartyID")) == SalesConstants.CUST_TYPE_CODE_ID_IND ? SalesConstants.IS_TRUE : SalesConstants.IS_FALSE);
    	custBillMasterVO.setCustBillIsPost(CommonUtils.intNvl(params.get("txtHiddenThirdPartyID")) != SalesConstants.CUST_TYPE_CODE_ID_IND ? SalesConstants.IS_TRUE : SalesConstants.IS_FALSE);
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
/*
    @Override
	public ReturnMessage requestSchmConv(Map<String, Object> params, SessionVO sessionVO) throws Exception {


		List<EgovMap> svmList = orderRequestMapper.selectSrvMembershipSaleList(params);

		for(EgovMap mmmmap : svmList) {
			logger.debug("mmmmap->"+mmmmap);
		}
		
		List<EgovMap> schmMapList2 = orderRequestMapper.selectSrvConfigFilterList2(params);
		
		for(EgovMap mmap : schmMapList2) {
			logger.debug("mmap->"+mmap);
		}
		
		List<SrvConfigFilterVO> schmMapList = orderRequestMapper.selectSrvConfigFilterList(params);
		
		for(SrvConfigFilterVO vo : schmMapList) {
			logger.debug("vo->"+vo.getSrvFilterId());
		}
		
		EgovMap schmMap2 = orderRequestMapper.selectSchemePriceSettingByPromoCode(params);
		
		logger.debug("schmMap2->"+schmMap2);
		
        String msg = "Order Scheme Successfully Saved";

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        //message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        message.setMessage(msg);
        
        return message;
	}
*/
    @Override
	public ReturnMessage requestSchmConv(Map<String, Object> params, SessionVO sessionVO) throws Exception {

		EgovMap somMap = orderRegisterMapper.selectSalesOrderM(params);
//		EgovMap sodMap = orderRequestMapper.selectSalesOrderD(params);
//		
//		int stusCodeId = CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("stusCodeId")));
//		int appTypeId  = CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("appTypeId")));
		
//		params.put("stusCodeId", stusCodeId);
//		params.put("appTypeId",  appTypeId);
//
		SalesOrderSchemeConversionVO conversion = new SalesOrderSchemeConversionVO();
		this.preprocSalesOrderSchemeConversion(conversion, params, sessionVO);
		
		DiscountEntryVO discount = new DiscountEntryVO();
		
		if(conversion.getSalesOrdNwPrc().compareTo(conversion.getSalesOrdPrePrc()) < 0) {
			this.preprocDiscountEntry(discount, conversion, params, sessionVO);
		}
		
		List<EgovMap> partList = orderRequestMapper.selectSchemePartSettingBySchemeIDList(params);
		List<EgovMap> filterList = this.preprocSrvConfigFilter(partList, conversion, params, sessionVO);
		List<EgovMap> svmList = orderRequestMapper.selectSrvMembershipSaleList(params);

		this.preprocSrvMembershipSalesList(svmList, conversion, params, sessionVO);
		
		SalesOrderMVO som = new SalesOrderMVO();
		
		this.preprocSalesOrderM(som, conversion, params, sessionVO);
		
		List<EgovMap> periodList = orderRequestMapper.selectServiceConfigPeriodEffectiveList(params);
    					
		this.preprocSrvConfigPeriodList(periodList, conversion, params, sessionVO);
		
		if(conversion != null) {
			orderRequestMapper.insertSalesOrderSchemeConversion(conversion);
		}
		
		if(som != null) {
			SalesOrderMVO inputSom = new SalesOrderMVO();
			
			inputSom.setSalesOrdId(som.getSalesOrdId());
			inputSom.setTotAmt(som.getTotAmt());
			inputSom.setTotPv(som.getTotPv());
			inputSom.setUpdUserId(som.getUpdUserId());
			inputSom.setRem(CommonUtils.nvl((String)somMap.get("rem"))+";"+som.getRem());
			inputSom.setCnvrSchemeId(som.getCnvrSchemeId());
			
			orderRequestMapper.updateSalesOrderMSchem(inputSom);
		}
		
		if(svmList != null && svmList.size() > 0) {
			for(EgovMap mMap : svmList)	{
				orderRequestMapper.updateSrvMembershipSales(mMap);
			}
		}
		
		if(periodList != null && periodList.size() > 0) {
			for(EgovMap cMap : periodList)	{
				orderRequestMapper.updateSrvConfigPeriod(cMap);
			}
		}
		
		EgovMap dcMap = new EgovMap();
		
		dcMap.put("salesOrdId", params.get("salesOrdId"));
		dcMap.put("updUserId", sessionVO.getUserId());
		dcMap.put("dcStusId", 8);
		
		orderRequestMapper.updateDiscountEntryStatus(dcMap);
		
		if(discount != null) {
			orderRequestMapper.insertDiscountEntry(discount);			
		}
		
		int configId = 0;
		
		EgovMap cfMap = orderRequestMapper.selectSrvConfiguration2(params);
		
		if(cfMap != null) configId = Integer.parseInt(String.valueOf((BigDecimal)cfMap.get("srvConfigId")));
		
		logger.info("configId : "+configId);
		logger.info("filterList.size() : "+filterList.size());

		if(filterList != null && filterList.size() > 0) {
			for(EgovMap fMap : filterList) {

				int iSrvFilterId = Integer.parseInt(String.valueOf(fMap.get("srvFilterId")));
				
				if(iSrvFilterId > 0) {
					orderRequestMapper.updateSrvConfigFilter(fMap);
				}
				else {
					fMap.put("srvConfigId", configId);
					
					orderRequestMapper.insertSrvConfigFilter(fMap);
				}
			}
		}
		
//		if(somMap != null) throw new Exception();
				
        String msg = "Order Scheme Successfully Saved";

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        //message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        message.setMessage(msg);
        
        return message;
	}
    
	@Override
	public ReturnMessage requestOwnershipTransfer(Map<String, Object> params, SessionVO sessionVO) throws Exception {

        //GET ORDER
		EgovMap somMap = orderRegisterMapper.selectSalesOrderM(params);

		int stusCodeId = CommonUtils.intNvl(somMap.get("stusCodeId"));
		int appTypeId  = CommonUtils.intNvl(somMap.get("appTypeId"));
		
		//SALES ORDER MASTER
		SalesOrderMVO salesOrderMVO =  new SalesOrderMVO();
		this.preprocSalesOrderM(salesOrderMVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_OTRN);
		
		//INSTALLATION MASTER
		InstallationVO installationVO = new InstallationVO();
		this.preprocInstallation(installationVO, params, sessionVO);
		
		//RENT PAY SET | CUSTOMER BILL MASTER |
		RentPaySetVO rentPaySetVO = new RentPaySetVO();
		CustBillMasterVO custBillMasterVO = new CustBillMasterVO();
		
		if(appTypeId == SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
			this.preprocRentPaySet(rentPaySetVO, params, sessionVO);
		}
		
		//2018.01.01
		if(appTypeId == SalesConstants.APP_TYPE_CODE_ID_RENTAL || "Y".equals(params.get("isNewVer"))) {
    		if("new".equals((String)params.get("btnBillGroup"))) {
    			this.preprocCustBillMaster(custBillMasterVO, params, sessionVO);
    		}
		}
		
		//ORDER EXCHANGE
		SalesOrderExchangeVO salesOrderExchangeVO = new SalesOrderExchangeVO();		
		this.preprocSalesOrderExchange(salesOrderExchangeVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_OTRN);
		
		//ORDER LOG LIST
        SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();
        this.preprocSalesOrderLog(salesOrderLogVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_OTRN);
		
        int CurrentCustBillID = CommonUtils.intNvl(somMap.get("custBillId"));
        
        //UPDATE ORDER MASTER
        orderRequestMapper.updateSalesOrderMOtran(salesOrderMVO);
        
        //UPDATE INSTALLATION
        orderRequestMapper.updateInstallationOtran(installationVO);
        
        //IF ORDER == RENTAL
        if(appTypeId == 66) {
        	//UPDATE RENTAL PAYMENT SETTING
        	orderRequestMapper.updateRentPaySetOtran(rentPaySetVO);
        }

        //2018.01.01
        if(appTypeId == 66 || "Y".equals(params.get("isNewVer"))) {
        	//INSERT CUSTOMER BILL MASTER (NEW*)
        	logger.debug("@#### isNewVer:"+params.get("isNewVer"));
        	
        	String nextDocNo_BillGroup = orderRegisterMapper.selectDocNo(DocTypeConstants.BILLGROUP_NO);
        	
        	custBillMasterVO.setCustBillGrpNo(nextDocNo_BillGroup);
        	
        	orderRegisterMapper.insertCustBillMaster(custBillMasterVO);
        	
        	salesOrderMVO.setCustBillId(custBillMasterVO.getCustBillId());
        	
        	orderRegisterMapper.updateCustBillId(salesOrderMVO);
        	
        	//Check current CustBillMaster
        	
        	params.put("custBillId", CurrentCustBillID);
        	
        	EgovMap bilMap = billingGroupMapper.selectCustBillMaster(params);
        	
        	if(bilMap != null) {
        		if(CommonUtils.intNvl(bilMap.get("custBillSoId")) == CommonUtils.intNvl(somMap.get("salesOrdId"))) {
        			// ---> Is Main Order in old group
        			params.put("custBillId", CommonUtils.intNvl(bilMap.get("custBillId")));
        			params.put("custId", CommonUtils.intNvl(bilMap.get("custBillCustId")));
        			params.put("stusCodeId", 4);
        			
        			EgovMap somMap2 = orderRequestMapper.selectSalesOrderMOtran(params);
        			
        			if(somMap2 != null) {
        				// Min Complete Order : Set as main
        				CustBillMasterVO tempVO2 = new CustBillMasterVO();
        				
        				tempVO2.setCustBillId(CommonUtils.intNvl(bilMap.get("custBillId")));
        				tempVO2.setCustBillSoId(CommonUtils.intNvl(somMap2.get("salesOrdId")));
        				tempVO2.setCustBillUpdUserId(sessionVO.getUserId());
        				
        				orderRequestMapper.updateCustBillMasterOtran(tempVO2);
        			}
        			else {
        				// Min Active Order : Set as main
            			params.put("custBillId", CommonUtils.intNvl(bilMap.get("custBillId")));
            			params.put("custId", CommonUtils.intNvl(bilMap.get("custBillCustId")));
            			params.put("stusCodeId", 1);
            			
            			EgovMap somMap3 = orderRequestMapper.selectSalesOrderMOtran(params);
        				
            			if(somMap3 != null) {
            				CustBillMasterVO tempVO3 = new CustBillMasterVO();
    
            				tempVO3.setCustBillId(CommonUtils.intNvl(bilMap.get("custBillId")));
            				tempVO3.setCustBillSoId(CommonUtils.intNvl(somMap2.get("salesOrdId")));
            				tempVO3.setCustBillUpdUserId(sessionVO.getUserId());
            				
            				orderRequestMapper.updateCustBillMasterOtran(tempVO3);
            			}
        			}
        		}
        	}
        }
        
        EgovMap sodMap = orderRequestMapper.selectSalesOrderD(params);
        
        salesOrderExchangeVO.setSoExchgOldAppTypeId(CommonUtils.intNvl(somMap.get("appTypeId")));
        salesOrderExchangeVO.setSoExchgNwAppTypeId(CommonUtils.intNvl(somMap.get("appTypeId")));
        salesOrderExchangeVO.setSoExchgOldStkId(CommonUtils.intNvl(sodMap.get("itmStkId")));
        salesOrderExchangeVO.setSoExchgNwStkId(CommonUtils.intNvl(sodMap.get("itmStkId")));
        salesOrderExchangeVO.setSoExchgOldPrcId(CommonUtils.intNvl(sodMap.get("itmPrcId")));
        salesOrderExchangeVO.setSoExchgNwPrcId(CommonUtils.intNvl(sodMap.get("itmPrcId")));
        salesOrderExchangeVO.setSoExchgOldPrc(CommonUtils.isNotEmpty(somMap.get("totAmt")) ? (BigDecimal)somMap.get("totAmt") : BigDecimal.ZERO);
        salesOrderExchangeVO.setSoExchgNwPrc(CommonUtils.isNotEmpty(somMap.get("totAmt")) ? (BigDecimal)somMap.get("totAmt") : BigDecimal.ZERO);
        salesOrderExchangeVO.setSoExchgOldPv(CommonUtils.isNotEmpty(somMap.get("totPv")) ? (BigDecimal)somMap.get("totPv") : BigDecimal.ZERO);
        salesOrderExchangeVO.setSoExchgNwPv(CommonUtils.isNotEmpty(somMap.get("totPv")) ? (BigDecimal)somMap.get("totPv") : BigDecimal.ZERO);
        salesOrderExchangeVO.setSoExchgOldRentAmt(CommonUtils.isNotEmpty(somMap.get("mthRentAmt")) ? (BigDecimal)somMap.get("mthRentAmt") : BigDecimal.ZERO);
        salesOrderExchangeVO.setSoExchgNwRentAmt(CommonUtils.isNotEmpty(somMap.get("mthRentAmt")) ? (BigDecimal)somMap.get("mthRentAmt") : BigDecimal.ZERO);
        salesOrderExchangeVO.setSoExchgOldPromoId(CommonUtils.intNvl(somMap.get("promoId")));
        salesOrderExchangeVO.setSoExchgNwPromoId(CommonUtils.intNvl(somMap.get("promoId")));
        salesOrderExchangeVO.setSoExchgOldSrvConfigId(0);
        salesOrderExchangeVO.setSoExchgNwSrvConfigId(0);
        salesOrderExchangeVO.setSoExchgOldCallEntryId(0);
        salesOrderExchangeVO.setSoExchgNwCallEntryId(0);
        salesOrderExchangeVO.setSoExchgStkRetMovId(0);
        salesOrderExchangeVO.setSoExchgRem("");
        salesOrderExchangeVO.setSoExchgOldDefRentAmt(CommonUtils.isNotEmpty(somMap.get("defRentAmt")) ? (BigDecimal)somMap.get("defRentAmt") : BigDecimal.ZERO);
        salesOrderExchangeVO.setSoExchgNwDefRentAmt(CommonUtils.isNotEmpty(somMap.get("defRentAmt")) ? (BigDecimal)somMap.get("defRentAmt") : BigDecimal.ZERO);
        salesOrderExchangeVO.setSoExchgUnderFreeAsId(0);
        
        orderRequestMapper.insertSalesOrderExchange(salesOrderExchangeVO);
        
    	//INSERT ORDER LOG >> OWNERSHIP TRANSFER REQUEST
    	if(salesOrderLogVO != null) {
    		salesOrderLogVO.setRefId(salesOrderExchangeVO.getSoExchgId());
    		
    		orderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);
    	}
    	
    	//INSERT ORDER LOG >> CUSTOMER IN-USE
        EgovMap lv = new EgovMap();
        EgovMap logMap = new EgovMap();
        
    	logMap.put("salesOrderId", CommonUtils.intNvl(params.get("salesOrdId")));
    	logMap.put("prgrsId", 5);
    	
        lv = orderDetailMapper.selectLatestOrderLogByOrderID(logMap);

        SalesOrderLogVO OrderLog = new SalesOrderLogVO();
        
        OrderLog.setLogId(0);
        OrderLog.setSalesOrdId(salesOrderExchangeVO.getSoId());
        OrderLog.setPrgrsId(5);
      //OrderLog.LogDate = DateTime.Now;
        OrderLog.setRefId(lv != null ? CommonUtils.intNvl(lv.get("refId")) : 0);
        OrderLog.setIsLok(SalesConstants.IS_FALSE);
        OrderLog.setLogCrtUserId(salesOrderExchangeVO.getSoExchgCrtUserId());
      //OrderLog.LogCreated = DateTime.Now;
        
        orderRegisterMapper.insertSalesOrderLog(OrderLog);

		String msg = "Order Number : " + (String)somMap.get("salesOrdNo") + "<br/>Ownership successfully transferred.";
        
		ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        //message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        message.setMessage(msg);
        
        return message;
	}
	
	@Override
	public ReturnMessage requestApplicationExchange(Map<String, Object> params, SessionVO sessionVO) throws Exception {

		EgovMap somMap = orderRegisterMapper.selectSalesOrderM(params);

		int stusCodeId = CommonUtils.intNvl(somMap.get("stusCodeId"));
		int appTypeId  = CommonUtils.intNvl(somMap.get("appTypeId"));
		
		params.put("stusCodeId", stusCodeId);
		params.put("appTypeId",  appTypeId);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date defaultDate = sdf.parse(SalesConstants.DEFAULT_DATE2);
		
		//ORDER EXCHANGE
		SalesOrderExchangeVO orderExchangeMasterVO = new SalesOrderExchangeVO();		
		this.preprocSalesOrderExchange(orderExchangeMasterVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_AEXC);
        
		//SALES ORDER MASTER
		SalesOrderMVO salesOrderMVO =  new SalesOrderMVO();
		this.preprocSalesOrderM(salesOrderMVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_AEXC);

		salesOrderMVO.setSalesOrdNo((String) somMap.get("salesOrdNo"));
        salesOrderMVO.setCustId(CommonUtils.intNvl(somMap.get("custId")));
		
        if(appTypeId == 66 && (CommonUtils.intNvl(params.get("cmbAppType")) == 67 || CommonUtils.intNvl((String)params.get("cmbAppType")) == 68)) {
        	salesOrderMVO.setTotAmt(new BigDecimal((String)params.get("txtPrice")));
        	salesOrderMVO.setTotPv(new BigDecimal((String)params.get("txtPV")));
        }
        else {
        	salesOrderMVO.setTotAmt((BigDecimal) somMap.get("totAmt"));
        	salesOrderMVO.setTotPv((BigDecimal) somMap.get("totPv"));
        }

		//MEMBERSHIP SALES
		SrvMembershipSalesVO srvMembershipSalesVO = new SrvMembershipSalesVO();
		
		if(appTypeId == 66) {
			this.preprocSrvMembershipSales(srvMembershipSalesVO, params, sessionVO);
		}
		
		//ORDER LOG LIST
        SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();
        this.preprocSalesOrderLog(salesOrderLogVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_AEXC);
        
        //Ben-2015-03-12
        EgovMap irv = null;
        EgovMap info = null;
        
		if(appTypeId == 66 && orderExchangeMasterVO.getSoCurStusId() == 25) {
			List<EgovMap> irvlistMap = orderRequestMapper.selectInstallResultsBySalesOrderID(params);
			int installEntryID = CommonUtils.intNvl(irvlistMap.get(0).get("installEntryId"));
			
			EgovMap params1 = new EgovMap();
			params1.put("installEntryId", installEntryID);
			irv = installationResultListMapper.getInstallResultByInstallEntryID(params1);
			
			EgovMap params2 = new EgovMap();
			params2.put("installEntryId", irv.get("installEntryId"));			
			info = installationResultListMapper.getOrderInfo(params2);
		}
		
		if(somMap != null) {
			EgovMap cstMap = orderModifyMapper.selectCustInfo(somMap);
			EgovMap sodMap = orderRequestMapper.selectSalesOrderD(params);
			EgovMap scfMap = orderRequestMapper.selectSrvConfiguration(params);
			
        	params.put("opt", "4");
        	EgovMap cenMap = orderRequestMapper.selectCallEntry(params); 
        	EgovMap insMapMax = orderRequestMapper.selectInstallEntry(params);
        	
        	int srvConfigId = 0;
        	int callEntryId = 0;
        	
        	if(scfMap != null) {
        		srvConfigId = CommonUtils.intNvl(scfMap.get("srvConfigId"));
        		callEntryId = CommonUtils.intNvl(cenMap.get("callEntryId"));
        	}
        	
        	int installEntryId = 0;
        	
        	if(insMapMax != null) {
        		installEntryId = CommonUtils.intNvl(insMapMax.get("installEntryId"));
        	}
        	
        	//EXCHANGE MASTER
        	orderExchangeMasterVO.setInstallEntryId(installEntryId);
        	orderExchangeMasterVO.setSoExchgOldPrcId(CommonUtils.intNvl(sodMap.get("itmPrcId")));
        	orderExchangeMasterVO.setSoExchgOldPrc((BigDecimal) somMap.get("totAmt"));
        	orderExchangeMasterVO.setSoExchgOldPv((BigDecimal) somMap.get("totPv"));
        	orderExchangeMasterVO.setSoExchgOldRentAmt((BigDecimal) somMap.get("mthRentAmt"));
        	orderExchangeMasterVO.setSoExchgOldPromoId(CommonUtils.intNvl(somMap.get("promoId")));
        	orderExchangeMasterVO.setSoExchgOldSrvConfigId(srvConfigId);
        	orderExchangeMasterVO.setSoExchgNwSrvConfigId(srvConfigId);
        	orderExchangeMasterVO.setSoExchgOldCallEntryId(callEntryId);
        	orderExchangeMasterVO.setSoExchgNwCallEntryId(callEntryId);
        	orderExchangeMasterVO.setSoExchgOldDefRentAmt((BigDecimal) somMap.get("defRentAmt"));
        	orderExchangeMasterVO.setSoExchgOldCustId(CommonUtils.intNvl(somMap.get("custId")));
        	orderExchangeMasterVO.setSoExchgNwCustId(CommonUtils.intNvl(somMap.get("custId")));
        	
        	orderRequestMapper.insertSalesOrderExchange(orderExchangeMasterVO);
        	
        	//SALES ORDER MASTER
        	orderRequestMapper.updateSalesOrderMAexc(salesOrderMVO);
        	
        	//SALES ORDER DETAILS
        	SalesOrderDVO salesOrderDVO = new SalesOrderDVO();
        	salesOrderDVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
        	salesOrderDVO.setItmPrcId(orderExchangeMasterVO.getSoExchgNwPrcId());
        	salesOrderDVO.setItmPrc(orderExchangeMasterVO.getSoExchgNwPrc());
        	salesOrderDVO.setItmPv(orderExchangeMasterVO.getSoExchgNwPv());
        	salesOrderDVO.setUpdUserId(orderExchangeMasterVO.getSoExchgUpdUserId());
        	
        	orderRequestMapper.updateSalesOrderDAexc(salesOrderDVO);
        	
        	if(scfMap != null) {
        		//CONFIG PERIOD
        		SrvConfigPeriodVO srvConfigPeriodVO = new SrvConfigPeriodVO();
        		srvConfigPeriodVO.setSrvConfigId(CommonUtils.intNvl(scfMap.get("srvConfigId")));
        		srvConfigPeriodVO.setSrvPrdUpdUserId(sessionVO.getUserId());
        		
        		orderRequestMapper.updateSrvConfigPeriodAexc(srvConfigPeriodVO);
        	}
        	
        	//EXCHANGE FROM RENTAL
        	if(orderExchangeMasterVO.getSoExchgOldAppTypeId() == 66 && orderExchangeMasterVO.getSoCurStusId() == 25) {
        		//DEACTIVATE RENTAL MEMBERSHIP
        		SrvMembershipSalesVO srvMembershipSalesVO2 = new SrvMembershipSalesVO();
        		srvMembershipSalesVO2.setSrvSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
        		srvMembershipSalesVO2.setSrvUpdUserId(sessionVO.getUserId());
        		
        		orderRequestMapper.updateSrvMembershipSalesAexc(srvMembershipSalesVO2);
        		
        		//ADD NEW MEMBERSHIP
        		params.put("ORDER_BY", "ASC");
        		EgovMap insMapMin = orderRequestMapper.selectInstallEntry(params);
        		
                Date memStartDate = defaultDate;
                Date memEndDate = defaultDate;
                
        		if(insMapMin != null) {
        			EgovMap irMapMin = orderRequestMapper.selectInstallResult(params);
        			
        			if(irMapMin != null) {
        				
        				SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd", Locale.getDefault(Locale.Category.FORMAT));
        				
        				memStartDate = df.parse((String)irMapMin.get("installDt"));
        			}
        			
        			String MemNo = orderRegisterMapper.selectDocNo(DocTypeConstants.MEMBERSHIP_NO);
        			String MemBillNo = orderRegisterMapper.selectDocNo(DocTypeConstants.MEMBERSHIP_BILL);
        			
        			srvMembershipSalesVO.setSrvMemNo(MemNo);
        			srvMembershipSalesVO.setSrvMemBillNo(MemBillNo);
        			srvMembershipSalesVO.setSrvStartDt(memStartDate);
        			
        			orderRequestMapper.insertSrvMembershipSales(srvMembershipSalesVO);
        		}
        		
        		//RESCHEDULE PURCHASED MEMBERSHIP
        		String checkDate = CommonUtils.getNowDate().substring(0, 6)+"01";
        		String startDate = CommonUtils.getAddMonth(checkDate, 1, SalesConstants.DEFAULT_DATE_FORMAT3);
        		
        		params.put("srvStartDt", checkDate);
        		
        		List<EgovMap> pmMap = orderRequestMapper.selectPurchaseMembershipList(params);
        		
        		for(EgovMap map : pmMap) {
        			String expireDate = CommonUtils.getAddDay(CommonUtils.getAddMonth(startDate, CommonUtils.intNvl(map.get("srvDur")) + 1, SalesConstants.DEFAULT_DATE_FORMAT3), -1, SalesConstants.DEFAULT_DATE_FORMAT3);
        			
        			map.put("srvStartDt", startDate);
        			map.put("srvExprDt", expireDate);
        			map.put("srvRem", "Application type exchange re-schedule membership date.");
        			map.put("srvUpdUserId", orderExchangeMasterVO.getSoExchgUpdUserId());

        			startDate = CommonUtils.getAddMonth(expireDate.substring(0, 6)+"01", 1, SalesConstants.DEFAULT_DATE_FORMAT3);
        			
        			orderRequestMapper.updateSrvMembershipSalesAexc2(map);
        		}
        	}
        	
        	//AFTER INSTALL CASE
        	if(orderExchangeMasterVO.getSoCurStusId() == 25) {
        		if(orderExchangeMasterVO.getSoExchgOldAppTypeId() == 67 || orderExchangeMasterVO.getSoExchgOldAppTypeId() == 68) {
/*
                    var qryLastBill = entity.AccTradeLedgers
                            .Where(itm => (itm.TradeSOID == OrderExchangeMaster.SOID
                                && itm.TradeAmount > 0
                                && itm.TradeDocTypeID == 164))
                                .OrderByDescending(itm => itm.TradeRunID)
                                .FirstOrDefault();
                        if (qryLastBill != null && qryLastBill.TradeAmount > 0)
                        {

                        }
*/
        		}
        		
        		if(orderExchangeMasterVO.getSoExchgNwPrc().compareTo(BigDecimal.ZERO) > 0 
        				&& (orderExchangeMasterVO.getSoExchgOldAppTypeId() != 67 && orderExchangeMasterVO.getSoExchgOldAppTypeId() != 68)) {
        			
        			AccTradeLedgerVO tradeLedgerBill = new AccTradeLedgerVO();
        			AccTRXVO trxPosBill = new AccTRXVO();
        			AccTRXVO trxNegBill = new AccTRXVO();
        			
                    //Ben-2015-03-12
                    String InvoiceNum = orderRegisterMapper.selectDocNo(DocTypeConstants.RENT_CONV_TAX_INV_NO);
                    
                    //TRADE LEDGER (BILL)
                    tradeLedgerBill.setTradeRunId(0);
                    tradeLedgerBill.setTradeId(0);
                    tradeLedgerBill.setTradeSoId(orderExchangeMasterVO.getSoId());
                    //tradeLedgerBill.TradeDocNo = qryMaxInstallEntry.InstallEntryNo;
                    tradeLedgerBill.setTradeDocNo(InvoiceNum);
                    tradeLedgerBill.setTradeDocTypeId(164);
                    tradeLedgerBill.setTradeAmt(orderExchangeMasterVO.getSoExchgNwPrc());
                    tradeLedgerBill.setTradeBatchNo("");
                    tradeLedgerBill.setTradeInstNo(0);
                    tradeLedgerBill.setTradeUpdUserId(sessionVO.getUserId());
                    tradeLedgerBill.setTradeIsSync(SalesConstants.IS_FALSE);
                    
                    orderRequestMapper.insertAccTradeLedger(tradeLedgerBill);
                    
                    int TaxCodeID = 0;
                    int TaxRate = 0;
                    
                    int ZRLocationID = CommonUtils.intNvl(somMap.get("gstChk"));
                    
                    String eurcId = productLostMapper.getRSCertificateId(String.valueOf(params.get("salesOrdId")));
                    
                    int RLCertificateID = CommonUtils.intNvl(eurcId);
                    
                    if(ZRLocationID != 0) {
                        TaxCodeID = 39;
                        TaxRate = 0;
                    }
                    else {
                        if(RLCertificateID != 0) {
                            TaxCodeID = 28;
                            TaxRate = 0;
                        }
                        else {
                            TaxCodeID = 32;
                            TaxRate = 6;
                        }
                    }
                    
                    //AccOrderBill
                    AccOrderBillVO OrderBill = new AccOrderBillVO();
                    
                    OrderBill.setAccBillTaskId(0);
                  //OrderBill.AccBillRefDate = DateTime.Now;
                    OrderBill.setAccBillRefNo("1000");
                    OrderBill.setAccBillOrdId(Integer.parseInt(Long.toString(salesOrderMVO.getSalesOrdId())));
                    OrderBill.setAccBillOrdNo(salesOrderMVO.getSalesOrdNo());
                    OrderBill.setAccBillTypeId(1159);
                    OrderBill.setAccBillModeId(1164);
                    OrderBill.setAccBillSchdulId(0);
                    OrderBill.setAccBillSchdulPriod(0);
                    OrderBill.setAccBillAdjId(0);
                    OrderBill.setAccBillSchdulAmt(salesOrderMVO.getTotAmt());
                    OrderBill.setAccBillAdjAmt(BigDecimal.ZERO);
                    
                    BigDecimal val1 = new BigDecimal("100");
                    BigDecimal val2 = new BigDecimal("106");
                    
                    BigDecimal gstRate = val1.divide(val2, MathContext.DECIMAL32);
                    
                    if(TaxRate > 0) {
                        //OrderBill.AccBillTaxesAmount = OrderBill.AccBillScheduleAmount - (OrderBill.AccBillScheduleAmount * 100 / 106);
                    	BigDecimal gstAmt = OrderBill.getAccBillSchdulAmt().multiply(gstRate);
                    	
                    	gstAmt = gstAmt.setScale(0, BigDecimal.ROUND_FLOOR);
                    	
                    	OrderBill.setAccBillTxsAmt(OrderBill.getAccBillSchdulAmt().subtract(gstAmt));
                    }
                    else {
                        //OrderBill.AccBillTaxesAmount = 0;
                    	OrderBill.setAccBillTxsAmt(BigDecimal.ZERO);
                    }
                    
                    OrderBill.setAccBillNetAmt(salesOrderMVO.getTotAmt());
                    OrderBill.setAccBillStus(SalesConstants.STATUS_ACTIVE);
                    OrderBill.setAccBillRem(InvoiceNum);
                  //OrderBill.AccBillCreateAt = saveView.OrderExchangeMaster.SOExchgCreateAt;
                    OrderBill.setAccBillCntrctId(orderExchangeMasterVO.getSoExchgCrtUserId());
                    OrderBill.setAccBillGrpId(0);
                  //OrderBill.AccBillTaxCodeID = 0;
                  //OrderBill.AccBillTaxRate = 0;
                    OrderBill.setAccBillTaxRate(TaxRate);
                    OrderBill.setAccBillTaxCodeId(TaxCodeID);
                    
                    orderRequestMapper.insertAccOrderBill(OrderBill);
                    
                    //GetCustomerInfo
                    int CustomerID = salesOrderMVO.getCustId();
                    logger.debug("CustomerID :"+CustomerID);
                    
                    String BillContactPerson = "";
                    String areaId;
                	String addrDtl;
                	String street;
/*
                    String BillAddress1      = "";
                    String BillAddress2      = "";
                    String BillAddress3      = "";
                    String BillAddress4      = "";
                    String BillPostCode      = "";
                    String BillState         = "";
                    String BillCountry       = "";
*/
                    EgovMap cMapParam = new EgovMap();
                    
                    cMapParam.put("custId", CustomerID);
                    
                    EgovMap custBasicMap = customerMapper.selectCustomerViewBasicInfo(cMapParam);
                    
                    cMapParam.put("custAddId", custBasicMap.get("custAddId"));
                    cMapParam.put("custCntcId", custBasicMap.get("custCntcId"));
                    
                    EgovMap custAddrBasicMap = customerMapper.selectCustomerViewMainAddress(cMapParam);
                    EgovMap custCntcBasicMap = customerMapper.selectCustomerViewMainContact(cMapParam);
                    
                    BillContactPerson = (String) custCntcBasicMap.get("name1");

                    areaId = (String) custAddrBasicMap.get("areaId");
                    addrDtl    = (String) custAddrBasicMap.get("addrDtl");
                    street  = (String) custAddrBasicMap.get("street");
                    
                    //TaxInvoiceOutright
                    AccTaxInvoiceOutrightVO TaxInvoiceOutright = new AccTaxInvoiceOutrightVO();
                    
                    TaxInvoiceOutright.setTaxInvcRefNo(InvoiceNum);
                  //TaxInvoiceOutright.TaxInvoiceRefDate = DateTime.Now;
                    TaxInvoiceOutright.setTaxInvcCustName((String) custBasicMap.get("name"));
                    TaxInvoiceOutright.setTaxInvcCntcPerson(BillContactPerson);
                    TaxInvoiceOutright.setAreaId(areaId);
                    TaxInvoiceOutright.setTaxInvcStateName(addrDtl);
                    TaxInvoiceOutright.setTaxInvcCnty(street);
                    TaxInvoiceOutright.setTaxInvcTaskId(0);
                  //TaxInvoiceOutright.TaxInvoiceCreated = DateTime.Now;
                    TaxInvoiceOutright.setTaxInvcRem(String.valueOf((BigDecimal)irv.get("installEntryId")));
                    
                    BigDecimal totAmt = salesOrderMVO.getTotAmt();
                    
                    if(TaxRate > 0) {
                        //TaxInvoiceOutright.TaxInvoiceCharges = (System.Convert.ToDecimal(saveView.SalesOrderMaster.TotalAmt) * 100 / 106);
                    	
                    	BigDecimal taxInvcChrg = totAmt.multiply(gstRate).setScale(0, BigDecimal.ROUND_FLOOR);
                    	                    	
                    	TaxInvoiceOutright.setTaxInvcChrg(taxInvcChrg);
                    }
                    else {
                        TaxInvoiceOutright.setTaxInvcChrg(salesOrderMVO.getTotAmt());
                    }
                    
                    TaxInvoiceOutright.setTaxInvcOverdu(BigDecimal.ZERO);
                    TaxInvoiceOutright.setTaxInvcAmtDue(salesOrderMVO.getTotAmt());
                    TaxInvoiceOutright.setAreaId(areaId);
                    TaxInvoiceOutright.setAddrDtl(addrDtl);
                    TaxInvoiceOutright.setStreet(street);
                    
                    orderRequestMapper.insertAccTaxInvoiceOutright(TaxInvoiceOutright);
                    
                    logger.debug("@#### TaxInvoiceOutright.getTaxInvcId() :"+TaxInvoiceOutright.getTaxInvcId());
                    
                    AccTaxInvoiceOutright_SubVO TaxinvoiceOutrightD = new AccTaxInvoiceOutright_SubVO();
                    
                    TaxinvoiceOutrightD.setTaxInvcId(TaxInvoiceOutright.getTaxInvcId());
                    TaxinvoiceOutrightD.setInvcItmOrdNo(salesOrderMVO.getSalesOrdNo());
                    TaxinvoiceOutrightD.setInvcItmPoNo("");
                    TaxinvoiceOutrightD.setInvcItmGstRate(TaxRate);
                    
                    if(TaxRate > 0) {
                        //TaxinvoiceOutrightD.InvoiceItemGSTTaxes = Convert.ToDecimal((Convert.ToDecimal(string.Format("{0:0.00}", (System.Convert.ToDecimal(saveView.SalesOrderMaster.TotalAmt)))) - (Convert.ToDecimal(string.Format("{0:0.00}", (System.Convert.ToDecimal(saveView.SalesOrderMaster.TotalAmt) * 100 / 106))))));
                        //TaxinvoiceOutrightD.InvoiceItemRentalFee = Convert.ToDecimal(string.Format("{0:0.00}", (System.Convert.ToDecimal(saveView.SalesOrderMaster.TotalAmt) * 100 / 106)));
                    	TaxinvoiceOutrightD.setInvcItmGstTxs(totAmt.subtract(totAmt.multiply(gstRate).setScale(0, BigDecimal.ROUND_FLOOR)));
                    	TaxinvoiceOutrightD.setInvcItmRentalFee(totAmt.multiply(gstRate).setScale(0, BigDecimal.ROUND_FLOOR));
                    }
                    else
                    {
                        //TaxinvoiceOutrightD.InvoiceItemGSTTaxes = 0;
                        //TaxinvoiceOutrightD.InvoiceItemRentalFee = (decimal)saveView.SalesOrderMaster.TotalAmt;                    	
                    	TaxinvoiceOutrightD.setInvcItmGstTxs(BigDecimal.ZERO);
                    	TaxinvoiceOutrightD.setInvcItmRentalFee(totAmt);
                    }
                    TaxinvoiceOutrightD.setInvcItmAmtDue(totAmt);
                    TaxinvoiceOutrightD.setInvcItmProductCtgry((String) info.get("codename1"));
                    TaxinvoiceOutrightD.setInvcItmProductModel((String) info.get("stkDesc"));
                    TaxinvoiceOutrightD.setInvcItmProductSerialNo((String) irv.get("serialNo"));
                    
                    EgovMap iav = orderRequestMapper.selectInstallationAddress(params);
                    
                    TaxinvoiceOutrightD.setAreaId((String) iav.get("areaId"));
                    TaxinvoiceOutrightD.setAddrDtl((String) iav.get("addrDtl"));
                    TaxinvoiceOutrightD.setStreet((String) iav.get("street"));
                    
                    /*
                    TaxinvoiceOutrightD.InvoiceItemAdd1 = iav.InstallationAddress1;
                    TaxinvoiceOutrightD.InvoiceItemAdd2 = iav.InstallationAddress2;
                    TaxinvoiceOutrightD.InvoiceItemAdd3 = iav.InstallationAddress3;
                    TaxinvoiceOutrightD.InvoiceItemPostCode = iav.InstallationPostCode;
                    TaxinvoiceOutrightD.InvoiceItemStateName = iav.InstallationStateName;
                    TaxinvoiceOutrightD.InvoiceItemCountry = iav.InstallationCountryName;
                    */
                    
                    orderRequestMapper.insertAccTaxInvoiceOutright_Sub(TaxinvoiceOutrightD);
        		}
        	}
        	
        	//INSERT ORDER LOG >> OWNERSHIP TRANSFER REQUEST
        	if(salesOrderLogVO != null) {
        		salesOrderLogVO.setRefId(orderExchangeMasterVO.getSoExchgId());
        		
        		orderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);
        	}
        	
            boolean isLock = true;
            int ProgressID = 0;
            EgovMap lv = new EgovMap();
            EgovMap logMap = new EgovMap();
            
            if(orderExchangeMasterVO.getSoCurStusId() == 25) {
                //INSERT ORDER LOG >> CUSTOMER IN-USE
                //lv = cm.GetLatestOrderLogByOrderID(qryOrder.SalesOrderID, 5);
            	logMap.put("salesOrderId", CommonUtils.intNvl(params.get("salesOrdId")));
            	logMap.put("prgrsId", 5);
            	
                lv = orderDetailMapper.selectLatestOrderLogByOrderID(logMap);
                
                isLock = false;
                ProgressID = 5;
            }
            else {
                //INSERT ORDER LOG >> INSTALLATION CALL LOG (NEW INSTALLATION)
                //lv = cm.GetLatestOrderLogByOrderID(qryOrder.SalesOrderID, 2);
            	logMap.put("salesOrderId", CommonUtils.intNvl(params.get("salesOrdId")));
            	logMap.put("prgrsId", 2);
            	
                lv = orderDetailMapper.selectLatestOrderLogByOrderID(logMap);
                
                ProgressID = 2;
            }
            
            SalesOrderLogVO OrderLog = new SalesOrderLogVO();
            
            OrderLog.setLogId(0);
            OrderLog.setSalesOrdId(orderExchangeMasterVO.getSoId());
            OrderLog.setPrgrsId(ProgressID);
          //OrderLog.LogDate = DateTime.Now;
            OrderLog.setRefId(lv != null ? CommonUtils.intNvl(lv.get("refId")) : 0);
            OrderLog.setIsLok(isLock == false ? SalesConstants.IS_FALSE : SalesConstants.IS_TRUE);
            OrderLog.setLogCrtUserId(orderExchangeMasterVO.getSoExchgCrtUserId());
          //OrderLog.LogCreated = DateTime.Now;
            
            orderRegisterMapper.insertSalesOrderLog(OrderLog);
		}
		
//		if(true) throw new Exception(); //For Test
        
		String msg = "Order Number : " + (String)somMap.get("salesOrdNo") + "<br/>Application type successfully exchanged.";
        
		ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        //message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        message.setMessage(msg);
        
        return message;
	}

	@Override
	public ReturnMessage requestProductExchange(Map<String, Object> params, SessionVO sessionVO) throws Exception {

		EgovMap somMap = orderRegisterMapper.selectSalesOrderM(params);
		EgovMap sodMap = orderRequestMapper.selectSalesOrderD(params);
		
		int stusCodeId = CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("stusCodeId")));
		int appTypeId  = CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("appTypeId")));
		
		params.put("stusCodeId", stusCodeId);
		params.put("appTypeId",  appTypeId);
		
		//ORDER EXCHANGE
		SalesOrderExchangeVO orderExchangeMasterVO = new SalesOrderExchangeVO();		
		this.preprocSalesOrderExchange(orderExchangeMasterVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_PEXC);
		
		//CALL ENTRY
		CallEntryVO callEntryMasterVO = new CallEntryVO();
		this.preprocCallEntryMaster(callEntryMasterVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_PEXC);
		
		//CANCEL CALL ENTRY/RESULT | STOCK MOVEMENT | STOCK RETURN | SALESORDERM | SALESORDERED
		CallEntryVO cancCallEntryMasterVO = new CallEntryVO();
		CallResultVO cancCallResultDetailsVO = new CallResultVO();
		InvStkMovementVO stkMovementMasterVO = new InvStkMovementVO();
		StkReturnEntryVO stkReturnMasterVO = new StkReturnEntryVO();
		SalesOrderMVO salesOrderMVO = new SalesOrderMVO();
		SalesOrderDVO salesOrderDVO = new SalesOrderDVO();
		
		if(SalesConstants.STATUS_ACTIVE == stusCodeId) { //Active
			this.preprocCancelCallEntryMaster(cancCallEntryMasterVO, params, sessionVO);
			this.preprocCancelCallResultDetails(cancCallResultDetailsVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_PEXC);
			
			this.preprocSalesOrderM(salesOrderMVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_PEXC);
			this.preprocSalesOrderD(salesOrderDVO, params, sessionVO);
		}
		else { //Completed
			this.preprocStkMovementMaster(stkMovementMasterVO, params, sessionVO);
			this.preprocStkReturnMaster(stkReturnMasterVO, params, sessionVO);
		}
		
		//ORDER LOG LIST
        SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();        
        this.preprocSalesOrderLog(salesOrderLogVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_PEXC);
		
        //SALES ORDER EXCHANGE
        orderExchangeMasterVO.setSoExchgOldPrcId(CommonUtils.intNvl(String.valueOf((BigDecimal)sodMap.get("itmPrcId"))));
        orderExchangeMasterVO.setSoExchgOldPrc((BigDecimal)somMap.get("totAmt"));
        orderExchangeMasterVO.setSoExchgOldPv((BigDecimal)somMap.get("totPv"));
        orderExchangeMasterVO.setSoExchgOldRentAmt((BigDecimal)somMap.get("mthRentAmt"));
        orderExchangeMasterVO.setSoExchgOldDefRentAmt((BigDecimal)somMap.get("defRentAmt"));
        orderExchangeMasterVO.setSoExchgOldCustId(CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("custId"))));
        orderExchangeMasterVO.setSoExchgNwCustId(CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("custId"))));

        int callEntryId = 0;
        
        if(orderExchangeMasterVO.getSoCurStusId() == 24) { //BEFORE INSTALL
        	params.put("opt", "2");
        	EgovMap callEntryMap2 = orderRequestMapper.selectCallEntry(params);
        	
        	if(callEntryMap2 != null) {
        		callEntryId = CommonUtils.intNvl(callEntryMap2.get("callEntryId"));
        	}
        }
        else { //AFTER INSTALL
        	EgovMap lastInstallMap = orderRequestMapper.selecLastInstall(params);
        	
        	params.put("opt", "3");
        	EgovMap callEntryMap3 = orderRequestMapper.selectCallEntry(params);
        	
        	EgovMap srvConfingMap = orderRequestMapper.selectSrvConfiguration(params);
        	
        	if(callEntryMap3 != null) {        	
        		callEntryId = CommonUtils.intNvl(callEntryMap3.get("callEntryId"));
        	}
        	orderExchangeMasterVO.setSoExchgOldSrvConfigId(CommonUtils.intNvl(String.valueOf((BigDecimal)srvConfingMap.get("srvConfigId"))));
        	orderExchangeMasterVO.setSoExchgNwSrvConfigId(CommonUtils.intNvl(String.valueOf((BigDecimal)srvConfingMap.get("srvConfigId"))));
        	orderExchangeMasterVO.setInstallEntryId(CommonUtils.intNvl(String.valueOf((BigDecimal)lastInstallMap.get("installEntryId"))));
        }
        
    	orderExchangeMasterVO.setSoExchgOldCallEntryId(CommonUtils.intNvl(callEntryId));

    	orderRequestMapper.insertSalesOrderExchange(orderExchangeMasterVO);
        
        if(orderExchangeMasterVO.getSoCurStusId() == 24) {
        	//BEFORE INSTALL CASE
        	params.put("callEntryId", orderExchangeMasterVO.getSoExchgOldCallEntryId());
        	
			EgovMap ccleMap = orderRequestMapper.selectCallEntryByEntryId(params);
			
			cancCallResultDetailsVO.setCallEntryId(CommonUtils.intNvl(String.valueOf((BigDecimal)ccleMap.get("callEntryId"))));
			
			orderRegisterMapper.insertCallResult(cancCallResultDetailsVO);
			
			ccleMap.put("stusCodeId", cancCallEntryMasterVO.getStusCodeId());
			ccleMap.put("resultId",   cancCallResultDetailsVO.getCallResultId());
			ccleMap.put("updUserId",  cancCallEntryMasterVO.getUpdUserId());
			
			orderRequestMapper.updateCallEntry2(ccleMap);
			
			//modified by chia // 19-10-2015
			orderRequestMapper.updateSalesOrderM(salesOrderMVO);
			
			orderRequestMapper.updateSalesOrderD(salesOrderDVO);
        }
        else {
        	//AFTER INSTALL CASE
        	stkMovementMasterVO.setInstallEntryId(orderExchangeMasterVO.getInstallEntryId());        	
        	orderRequestMapper.insertInvStkMovement(stkMovementMasterVO);
        	
        	orderExchangeMasterVO.setSoExchgStkRetMovId(stkMovementMasterVO.getMovId());
        	orderRequestMapper.updateSoExchgStkRetMovId(orderExchangeMasterVO);
        	
            //GET REQUEST NUMBER
            String retNo = orderRegisterMapper.selectDocNo(DocTypeConstants.RET_NO);
            
            logger.info("!@#### GET NEW RET_NO  :"+retNo);
            
            stkReturnMasterVO.setRetnNo(retNo);
            stkReturnMasterVO.setMovId(stkMovementMasterVO.getMovId());
            stkReturnMasterVO.setRefId(orderExchangeMasterVO.getSoExchgId());
            stkReturnMasterVO.setStockId(orderExchangeMasterVO.getSoExchgOldStkId());
            
            orderRequestMapper.insertStkReturnEntry(stkReturnMasterVO);
            
            EgovMap buConfigMap = orderRequestMapper.selectSrvConfiguration(params);
            
            if(buConfigMap != null) {
            	List<EgovMap> buPeriodMap  = orderRequestMapper.selectSrvConfigPeriod(buConfigMap);
            	List<EgovMap> buSettingMap = orderRequestMapper.selectSrvConfigSetting(buConfigMap);
            	List<EgovMap> buFilterMap  = orderRequestMapper.selectSrvConfigFilter(buConfigMap);
            	
            	SalesOrderExchangeBUSrvConfigVO salesOrderExchangeBUSrvConfigVO = new SalesOrderExchangeBUSrvConfigVO();
            	
            	salesOrderExchangeBUSrvConfigVO.setBuSrvConfigId(0);
            	salesOrderExchangeBUSrvConfigVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
            	salesOrderExchangeBUSrvConfigVO.setSrvConfigId(CommonUtils.intNvl(String.valueOf((BigDecimal)buConfigMap.get("srvConfigId"))));
            	
            	orderRequestMapper.insertSalesOrderExchangeBUSrvConfig(salesOrderExchangeBUSrvConfigVO);
            	
            	if(buPeriodMap != null && buPeriodMap.size() > 0) {
            		
            		SalesOrderExchangeBUSrvPeriodVO salesOrderExchangeBUSrvPeriodVO = null;
            		
            		for(EgovMap eMap : buPeriodMap) {
            			salesOrderExchangeBUSrvPeriodVO = new SalesOrderExchangeBUSrvPeriodVO();
            			salesOrderExchangeBUSrvPeriodVO.setBuSrvPriodId(0);
            			salesOrderExchangeBUSrvPeriodVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
            			salesOrderExchangeBUSrvPeriodVO.setSrvPrdId(CommonUtils.intNvl(String.valueOf((BigDecimal)eMap.get("srvPrdId"))));
            			
            			orderRequestMapper.insertSalesOrderExchangeBUSrvPeriod(salesOrderExchangeBUSrvPeriodVO);
            		}
            	}
            	
            	if(buSettingMap != null && buSettingMap.size() > 0) {
            		
            		SalesOrderExchangeBUSrvSettingVO salesOrderExchangeBUSrvSettingVO = null;
            		
            		for(EgovMap eMap : buSettingMap) {
            			salesOrderExchangeBUSrvSettingVO = new SalesOrderExchangeBUSrvSettingVO();
            			salesOrderExchangeBUSrvSettingVO.setBuSrvSetngId(0);
            			salesOrderExchangeBUSrvSettingVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
            			salesOrderExchangeBUSrvSettingVO.setSrvSettId(CommonUtils.intNvl(String.valueOf((BigDecimal)eMap.get("srvSettId"))));
            			
            			orderRequestMapper.insertSalesOrderExchangeBUSrvSetting(salesOrderExchangeBUSrvSettingVO);
            		}
            	}
            	
            	if(buFilterMap != null && buFilterMap.size() > 0) {
            		
            		SalesOrderExchangeBUSrvFilterVO salesOrderExchangeBUSrvFilterVO = null;
            		
            		for(EgovMap eMap:buFilterMap) {
            			salesOrderExchangeBUSrvFilterVO = new SalesOrderExchangeBUSrvFilterVO();
            			salesOrderExchangeBUSrvFilterVO.setBuSrvFilterId(0);
            			salesOrderExchangeBUSrvFilterVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
            			salesOrderExchangeBUSrvFilterVO.setSrvFilterId(CommonUtils.intNvl(String.valueOf((BigDecimal)eMap.get("srvFilterId"))));
            			
            			orderRequestMapper.insertSalesOrderExchangeBUSrvFilter(salesOrderExchangeBUSrvFilterVO);
            		}
            	}
            }
        }
        
        callEntryMasterVO.setDocId(orderExchangeMasterVO.getSoExchgId());
        orderRegisterMapper.insertCallEntry(callEntryMasterVO);
        
        orderExchangeMasterVO.setSoExchgNwCallEntryId(callEntryMasterVO.getCallEntryId());
        
        //INSERT ORDER LOG >> OWNERSHIP TRANSFER REQUEST
        salesOrderLogVO.setRefId(callEntryMasterVO.getCallEntryId());
        
        orderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);
        
        String msg = "Order Number : " + (String)somMap.get("salesOrdNo") + "<br/>Product exchange request successfully saved.";

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        //message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        message.setMessage(msg);
        
        return message;
	}
	
	@Override
	public ReturnMessage requestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception {

		//logger.info("!@###### OrderModifyServiceImpl.updateNric");
		
		EgovMap somMap = orderRegisterMapper.selectSalesOrderM(params);
		EgovMap sodMap = orderRequestMapper.selectSalesOrderD(params);
		
		int stusCodeId = CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("stusCodeId")));
		int appTypeId  = CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("appTypeId")));
		
        //GET REQUEST NUMBER
        String reqNo = orderRegisterMapper.selectDocNo(DocTypeConstants.CANCEL_REQUEST);
        
        logger.info("!@#### GET NEW REQ_NO  :"+reqNo);
        
        int LatestOrderCallEntryID = 0;
        
        if(SalesConstants.STATUS_ACTIVE == stusCodeId) {
        	//Active
        	params.put("opt", "1");
        	EgovMap callEntryMap1 = orderRequestMapper.selectCallEntry(params);
        	
        	if(callEntryMap1 != null) {
        		LatestOrderCallEntryID = CommonUtils.intNvl(callEntryMap1.get("callEntryId"));
        	}
        }
        else {
        	//Complete
        	EgovMap ineMap = orderRequestMapper.selectInstallEntry(params);
        	
        	if(ineMap != null) {
        		LatestOrderCallEntryID = CommonUtils.intNvl(String.valueOf((BigDecimal)ineMap.get("callEntryId")));
        	}
        }
        
		SalesReqCancelVO salesReqCancelVO = new SalesReqCancelVO();
		CallEntryVO callEntryMasterVO = new CallEntryVO();
		CallResultVO callResultVO = new CallResultVO();
		CallResultVO cancCallResultVO = new CallResultVO();
		
		params.put("stusCodeId", stusCodeId);
		params.put("appTypeId",  appTypeId);
		params.put("callEntryId",  LatestOrderCallEntryID);		
		params.put("tempOrdId",  params.get("salesOrdId"));		
		
		this.preprocSalesReqCancel(salesReqCancelVO, params, sessionVO);
		this.preprocCallEntryMaster(callEntryMasterVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_CANC);
		this.preprocCallResultDetails(callResultVO, params, sessionVO);
		this.preprocCancelCallResultDetails(cancCallResultVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_CANC);
		
		salesReqCancelVO.setSoReqPrevCallEntryId(LatestOrderCallEntryID);
		salesReqCancelVO.setSoReqCurStkId(CommonUtils.intNvl(String.valueOf((BigDecimal)sodMap.get("itmStkId"))));
		salesReqCancelVO.setSoReqCurAmt((BigDecimal)somMap.get("totAmt"));
		salesReqCancelVO.setSoReqCurPv((BigDecimal)somMap.get("totPv"));
		salesReqCancelVO.setSoReqCurrAmt((BigDecimal)somMap.get("mthRentAmt"));
		salesReqCancelVO.setSoReqNo(reqNo);
		
		orderRequestMapper.insertSalesReqCancel(salesReqCancelVO);
		
		//PREVIOUS CALL LOG
		if(stusCodeId == SalesConstants.STATUS_ACTIVE) {
			EgovMap ccleMap = orderRequestMapper.selectCallEntryByEntryId(params);
			
			cancCallResultVO.setCallEntryId(CommonUtils.intNvl(String.valueOf((BigDecimal)ccleMap.get("callEntryId"))));
			
			orderRegisterMapper.insertCallResult(cancCallResultVO);
			
			ccleMap.put("stusCodeId", cancCallResultVO.getCallStusId());
			ccleMap.put("resultId",   cancCallResultVO.getCallResultId());
			ccleMap.put("updUserId",  cancCallResultVO.getCallCrtUserId());
			
			orderRequestMapper.updateCallEntry2(ccleMap);
		}
		
		//CANCELLATION CALL LOG
		callEntryMasterVO.setDocId(salesReqCancelVO.getSoReqId());
		
		orderRegisterMapper.insertCallEntry(callEntryMasterVO);
		
		callResultVO.setCallEntryId(callEntryMasterVO.getCallEntryId());
		
		orderRegisterMapper.insertCallResult(callResultVO);
		
		Map<String, Object> tempMap = new HashMap<String, Object>();
		
		tempMap.put("soReqSeq", salesReqCancelVO.getSoReqId());
		tempMap.put("updCallEntryId", callResultVO.getCallEntryId());
		
		ccpCalculateMapper.updateOrderRequest(tempMap);
		
		callEntryMasterVO.setResultId(callResultVO.getCallResultId());
		
		orderRequestMapper.updateCallEntry(callEntryMasterVO);
		
        //RENTAL SCHEME
        if(appTypeId == 66) {
        	EgovMap stsMap = ccpCalculateMapper.rentalSchemeStatusByOrdId(params);
        	
        	if(stsMap != null) {
            	stsMap.put("stusCodeId", "RET");
            	stsMap.put("isSync", SalesConstants.IS_FALSE);
            	stsMap.put("salesOrdId", params.get("salesOrdId"));
            	
            	orderRequestMapper.updateRentalScheme(stsMap);
        	}
        }
        
        //INSERT ORDER LOG >> CANCELLATION CALL LOG
        SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();
        
        this.preprocSalesOrderLog(salesOrderLogVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_CANC);
        
        salesOrderLogVO.setRefId(callEntryMasterVO.getCallEntryId());
        
        orderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);
        
        String msg = "Order Number : " + (String)somMap.get("salesOrdNo")
                   + "<br/>Order cancellation request successfully saved.<br/>" 
        		   + "Request Number : " + reqNo + "<br />";
        
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return message;
	}
	
	private void preprocSalesOrderLog(SalesOrderLogVO salesOrderLogVO, Map<String, Object> params, SessionVO sessionVO, String ordReqType) {
		
		salesOrderLogVO.setLogId(0);
		salesOrderLogVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
		salesOrderLogVO.setPrgrsId(11);
		salesOrderLogVO.setRefId(0);
		salesOrderLogVO.setIsLok(SalesConstants.IS_TRUE);
		salesOrderLogVO.setLogCrtUserId(sessionVO.getUserId());

		if(SalesConstants.ORDER_REQ_TYPE_CD_CANC.equals(ordReqType)) {
    		salesOrderLogVO.setPrgrsId(11);
		}
		else if(SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
    		salesOrderLogVO.setPrgrsId(3);
		}
		else if(SalesConstants.ORDER_REQ_TYPE_CD_AEXC.equals(ordReqType)) {
    		salesOrderLogVO.setPrgrsId(6);
		}
		else if(SalesConstants.ORDER_REQ_TYPE_CD_OTRN.equals(ordReqType)) {
    		salesOrderLogVO.setPrgrsId(7);
		}
	}
	
	private void preprocCancelCallResultDetails(CallResultVO callResultVO, Map<String, Object> params, SessionVO sessionVO, String ordReqType) {
		
		if(SalesConstants.ORDER_REQ_TYPE_CD_CANC.equals(ordReqType)) {
    		callResultVO.setCallResultId(0);
    		callResultVO.setCallEntryId(0);
    		callResultVO.setCallStusId(SalesConstants.STATUS_CANCELLED);
    		callResultVO.setCallDt(SalesConstants.DEFAULT_DATE);
    		callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE);
    		callResultVO.setCallFdbckId(0);
    		callResultVO.setCallCtId(0);
    		callResultVO.setCallRem("(Call-log cancelled - Order Cancellation Request) "+(String)params.get("txtRemark"));
    		callResultVO.setCallCrtUserId(sessionVO.getUserId());
    		callResultVO.setCallCrtUserIdDept(0);
    		callResultVO.setCallHcId(0);
    		callResultVO.setCallRosAmt(BigDecimal.ZERO);
    		callResultVO.setCallSms(SalesConstants.IS_FALSE);
    		callResultVO.setCallSmsRem("");
		}
		else if(SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
    		callResultVO.setCallResultId(0);
    		callResultVO.setCallEntryId(0);
    		callResultVO.setCallStusId(SalesConstants.STATUS_CANCELLED);
    		callResultVO.setCallDt(SalesConstants.DEFAULT_DATE);
    		callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE);
    		callResultVO.setCallFdbckId(0);
    		callResultVO.setCallCtId(0);
    		callResultVO.setCallRem("Call-log cancelled - Product Exchange Requested.");
    		callResultVO.setCallCrtUserId(sessionVO.getUserId());
    		callResultVO.setCallCrtUserIdDept(0);
    		callResultVO.setCallHcId(0);
    		callResultVO.setCallRosAmt(BigDecimal.ZERO);
    		callResultVO.setCallSms(SalesConstants.IS_FALSE);
    		callResultVO.setCallSmsRem("");
		}
	}
	
	private void preprocCallResultDetails(CallResultVO callResultVO, Map<String, Object> params, SessionVO sessionVO) {
		
		callResultVO.setCallResultId(0);
		callResultVO.setCallEntryId(0);
		callResultVO.setCallStusId(SalesConstants.STATUS_ACTIVE);
		callResultVO.setCallDt((String)params.get("dpCallLogDate"));
		callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE);
		callResultVO.setCallFdbckId(CommonUtils.intNvl((String)params.get("cmbReason")));
		callResultVO.setCallCtId(0);
		callResultVO.setCallRem((String)params.get("txtRemark"));
		callResultVO.setCallCrtUserId(sessionVO.getUserId());
		callResultVO.setCallCrtUserIdDept(0);
		callResultVO.setCallHcId(0);
		callResultVO.setCallRosAmt(BigDecimal.ZERO);
		callResultVO.setCallSms(SalesConstants.IS_FALSE);
		callResultVO.setCallSmsRem("");
/*
        CallResultDetails.CallResultID = 0;
        CallResultDetails.CallEntryID = 0; //NEED UPDATE
        CallResultDetails.CallStatusID = 1;
        CallResultDetails.CallCallDate = dpCallLogDate.SelectedDate;
        CallResultDetails.CallActionDate = defaultDate;
        CallResultDetails.CallFeedBackID = int.Parse(cmbReason.SelectedValue);
        CallResultDetails.CallCTID = 0;
        CallResultDetails.CallRemark = txtRemark.Text.Trim();
        CallResultDetails.CallCreateBy = li.UserID;
        CallResultDetails.CallCreateAt = DateTime.Now;
        CallResultDetails.CallCreateByDept = 0;
        CallResultDetails.CallHCID = 0;
        CallResultDetails.CallROSAmt = 0;
        CallResultDetails.CallSMS = false;
        CallResultDetails.CallSMSRemark = "";
 */
	}
	
	private void preprocCancelCallEntryMaster(CallEntryVO callEntryVO, Map<String, Object> params, SessionVO sessionVO)
    {
		callEntryVO.setCallEntryId(0);
		callEntryVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
		callEntryVO.setTypeId(257);
		callEntryVO.setStusCodeId(SalesConstants.STATUS_CANCELLED);
		callEntryVO.setResultId(0);
		callEntryVO.setDocId(0);
		callEntryVO.setCrtUserId(sessionVO.getUserId());
		callEntryVO.setCallDt(SalesConstants.DEFAULT_DATE);
		callEntryVO.setIsWaitForCancl(SalesConstants.IS_FALSE);
		callEntryVO.setHapyCallerId(0);
		callEntryVO.setUpdUserId(sessionVO.getUserId());
		callEntryVO.setOriCallDt(SalesConstants.DEFAULT_DATE);
    }
	
	private void preprocCallEntryMaster(CallEntryVO callEntryVO, Map<String, Object> params, SessionVO sessionVO, String ordReqType) {
		
		if(SalesConstants.ORDER_REQ_TYPE_CD_CANC.equals(ordReqType)) {
    		callEntryVO.setCallEntryId(0);
    		callEntryVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    		callEntryVO.setTypeId(CommonUtils.intNvl(SalesConstants.CALL_ENTRY_TYPE_ID));
    		callEntryVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
    		callEntryVO.setResultId(0);
    		callEntryVO.setDocId(0);
    		callEntryVO.setCrtUserId(sessionVO.getUserId());
    		callEntryVO.setCallDt((String)params.get("dpCallLogDate"));
    		callEntryVO.setIsWaitForCancl(SalesConstants.IS_TRUE);
    		callEntryVO.setHapyCallerId(0);
    		callEntryVO.setUpdUserId(sessionVO.getUserId());
    		callEntryVO.setOriCallDt((String)params.get("dpCallLogDate"));
		}
		else if(SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
    		callEntryVO.setCallEntryId(0);
    		callEntryVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    		callEntryVO.setTypeId(258);
    		callEntryVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
    		callEntryVO.setResultId(0);
    		callEntryVO.setDocId(0);
    		callEntryVO.setCrtUserId(sessionVO.getUserId());
    		callEntryVO.setCallDt((String)params.get("dpCallLogDate"));
    		callEntryVO.setIsWaitForCancl(SalesConstants.IS_FALSE);
    		callEntryVO.setHapyCallerId(0);
    		callEntryVO.setUpdUserId(sessionVO.getUserId());
    		callEntryVO.setOriCallDt((String)params.get("dpCallLogDate"));
		}
	}
	
	private void preprocSalesReqCancel(SalesReqCancelVO salesReqCancelVO, Map<String, Object> params, SessionVO sessionVO) {

		salesReqCancelVO.setSoReqId(0);
		salesReqCancelVO.setSoReqSoId(CommonUtils.intNvl((String)params.get("salesOrdId")));
		salesReqCancelVO.setSoReqStusId(SalesConstants.STATUS_ACTIVE);
		salesReqCancelVO.setSoReqCurStusId((int)params.get("stusCodeId") == 1 ? 24 :25);
		salesReqCancelVO.setSoReqResnId(CommonUtils.intNvl((String)params.get("cmbReason")));
		salesReqCancelVO.setSoReqPrevCallEntryId(0);
		salesReqCancelVO.setSoReqCurCallEntryId(0);		
		salesReqCancelVO.setSoReqCrtUserId(sessionVO.getUserId());
		salesReqCancelVO.setSoReqUpdUserId(sessionVO.getUserId());
		salesReqCancelVO.setSoReqCurStkId(0);
		salesReqCancelVO.setSoReqCurAppTypeId((int)params.get("appTypeId"));
		salesReqCancelVO.setSoReqCurAmt(BigDecimal.ZERO);
		salesReqCancelVO.setSoReqCurPv(BigDecimal.ZERO);
		salesReqCancelVO.setSoReqCurrAmt(BigDecimal.ZERO);
		salesReqCancelVO.setSoReqActualCanclDt(SalesConstants.DEFAULT_DATE);
		
		//salesReqCancelVO.setSoReqCanclTotOtstnd(new BigDecimal( (String)params.get("txtTotalAmount")));
		//salesReqCancelVO.setSoReqCanclPnaltyAmt(new BigDecimal((String)params.get("txtPenaltyCharge")));
		//salesReqCancelVO.setSoReqCanclAdjAmt(new BigDecimal((String)params.get("txtPenaltyAdj")));
		//salesReqCancelVO.setSoReqCanclRentalOtstnd(new BigDecimal((String)params.get("txtCurrentOutstanding")));

	 
		//edit by hgham 2017-12-30
		 salesReqCancelVO.setSoReqCanclTotOtstnd( new BigDecimal(CommonUtils.intNvl((params.get("txtTotalAmount")))));
		 salesReqCancelVO.setSoReqCanclPnaltyAmt(new BigDecimal(CommonUtils.intNvl(params.get("txtPenaltyCharge"))));
	     salesReqCancelVO.setSoReqCanclAdjAmt(new BigDecimal(CommonUtils.intNvl(params.get("txtPenaltyAdj"))));
	     salesReqCancelVO.setSoReqCanclRentalOtstnd(new BigDecimal(CommonUtils.intNvl(params.get("txtCurrentOutstanding"))));


		
		salesReqCancelVO.setSoReqCanclObPriod(CommonUtils.intNvl((String)params.get("txtObPeriod")));
		salesReqCancelVO.setSoReqCanclUnderCoolPriod(SalesConstants.IS_FALSE);
		salesReqCancelVO.setSoReqCanclTotUsedPriod(CommonUtils.intNvl((String)params.get("txtTotalUseMth")));
		salesReqCancelVO.setSoReqNo("");
		salesReqCancelVO.setSoReqster(CommonUtils.intNvl((String)params.get("cmbRequestor")));
		salesReqCancelVO.setSoReqPreRetnDt((int)params.get("stusCodeId") == 4 ? (String)params.get("dpReturnDate") : SalesConstants.DEFAULT_DATE);
		salesReqCancelVO.setSoReqRem((String)params.get("txtRemark"));
/*		
        OrderReqCancelMaster.SOReqID = 0;
        OrderReqCancelMaster.SOReqSOID = int.Parse(OrderID);
        OrderReqCancelMaster.SOReqStatusID = 1;
        OrderReqCancelMaster.SOReqCurStatusID = int.Parse(hiddenOrderStatusID.Value) == 1 ? 24 : 25;
        OrderReqCancelMaster.SOReqReasonID = int.Parse(cmbReason.SelectedValue);
        OrderReqCancelMaster.SOReqPrevCallEntryID = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqCurCallEntryID = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqCreateAt = DateTime.Now;
        OrderReqCancelMaster.SOReqCreateBy = li.UserID;
        OrderReqCancelMaster.SOReqUpdateAt = DateTime.Now;
        OrderReqCancelMaster.SOReqUpdateBy = li.UserID;
        OrderReqCancelMaster.SOReqCurStkID = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqCurAppTypeID = int.Parse(hiddenAppTypeID.Value);
        OrderReqCancelMaster.SOReqCurAmt = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqCurPV = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqCurRentAmt = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqActualCancelDate = defaultDate;
        OrderReqCancelMaster.SOReqCancelTotalOutstanding = double.Parse(txtTotalAmount.Text);
        OrderReqCancelMaster.SOReqCancelPenaltyAmt = double.Parse(txtPenaltyCharge.Text);
        OrderReqCancelMaster.SOReqCancelObPeriod = int.Parse(txtObPeriod.Text);
        OrderReqCancelMaster.SOReqCancelIsUnderCoolPeriod = false;
        OrderReqCancelMaster.SOReqCancelRentalOutstanding = double.Parse(txtCurrentOutstanding.Text);
        OrderReqCancelMaster.SOReqCancelTotalUsedPeriod = int.Parse(txtTotalUseMth.Text);
        OrderReqCancelMaster.SOReqNo = ""; //NEED UPDATE
        OrderReqCancelMaster.SOReqCancelAdjustmentAmt = double.Parse(txtPenaltyAdj.Text);
        OrderReqCancelMaster.SORequestor = int.Parse(cmbRequestor.SelectedValue);
        OrderReqCancelMaster.SOReqPreReturnDate = int.Parse(hiddenOrderStatusID.Value) == 4 ? dpReturnDate.SelectedDate : defaultDate;
        OrderReqCancelMaster.SOReqRemark = txtRemark.Text.Trim();
*/
	}
	
	@Override
	public EgovMap selectCompleteASIDByOrderIDSolutionReason(Map<String, Object> params) {
		return orderRequestMapper.selectCompleteASIDByOrderIDSolutionReason(params);
	}

	@Override
	public List<EgovMap> selectSalesOrderSchemeList(Map<String, Object> params) {
		return orderRequestMapper.selectSalesOrderSchemeList(params);
	}
	
	@Override
	public EgovMap selectSchemePriceSettingByPromoCode(Map<String, Object> params) {
		return orderRequestMapper.selectSchemePriceSettingByPromoCode(params);
	}

	@Override
	public List<EgovMap> selectSchemePartSettingBySchemeIDList(Map<String, Object> params) {
		return orderRequestMapper.selectSchemePartSettingBySchemeIDList(params);
	}
	
	@Override
	public EgovMap selectOrderSimulatorViewByOrderNo(Map<String, Object> params) {
		return this.selectOrderSimulatorViewByOrderNo2(params);
	}

	private EgovMap selectOrderSimulatorViewByOrderNo2(Map<String, Object> params) {
		
		EgovMap view = orderRequestMapper.selectOrderSimulatorViewByOrderNo(params);
		
		int CurrentBillMth = 0;
		int LastBillMth = 0;
		String installDate = SalesConstants.DEFAULT_DATE3;
		BigDecimal TotalOutstanding = BigDecimal.ZERO;
		BigDecimal OutrightPrice = BigDecimal.ZERO;
		BigDecimal TotalBillAmt = BigDecimal.ZERO;
		BigDecimal TotalBillRPF = BigDecimal.ZERO;
		BigDecimal TotalDNBill = BigDecimal.ZERO;
		BigDecimal TotalCNBill = BigDecimal.ZERO;
		BigDecimal TotalDNRPF = BigDecimal.ZERO;
		BigDecimal TotalCNRPF = BigDecimal.ZERO;
		
		
		if(view != null) {
			int salesOrdId = Integer.parseInt(String.valueOf(view.get("salesOrdId")));
			int appTypeId = Integer.parseInt(String.valueOf(view.get("appTypeId")));
			int orderStatusID = Integer.parseInt(String.valueOf(view.get("stusCodeId")));
			String rentalStatus = String.valueOf(view.get("stusCodeId1"));
			
			params.put("salesOrdId", salesOrdId);
			
			if(appTypeId == SalesConstants.APP_TYPE_CODE_ID_RENTAL && orderStatusID == SalesConstants.STATUS_COMPLETED) {

				//Get first install date
				EgovMap irMap = orderRequestMapper.selectInstallResult(params);
				
				if(irMap != null) installDate = (String) irMap.get("installDt");
				
				//Get outright price
				int tracePromoID = 600;

				if(CommonUtils.intNvl(view.get("ordDt")) > 20140701) {
					tracePromoID = 577;
				}
				
				params.put("promoId", tracePromoID);
				params.put("promoItmStkId", view.get("itmStkId"));
				
				EgovMap opMap = orderRequestMapper.selectPromoD(params);
				
				if(opMap != null) {
					OutrightPrice = (BigDecimal) opMap.get("promoItmPrc");
				}
				
				//Get Order Ledger Record
				EgovMap rlMap = orderRequestMapper.selectAccRentLedger(params);
				
				if(CommonUtils.intNvl(rlMap.get("cnt")) > 0) {
					//Get Order Total Bill (Except RPF)
					EgovMap tbMap = orderRequestMapper.selectAccRentLedger2(params);
					
					if(CommonUtils.intNvl(tbMap.get("cnt")) > 0) {
						TotalBillAmt = (BigDecimal) tbMap.get("rentAmt");
					}
					
					//Get Order Tota DN Bill (Except RPF)
					EgovMap dnMap = orderRequestMapper.selectTotalDNBill(params);
					
					if(CommonUtils.intNvl(dnMap.get("cnt")) > 0) {
						TotalDNBill = (BigDecimal) dnMap.get("rentAmt");
					}
					
					//Get Order Tota CN Bill (Except RPF)
					EgovMap cnMap = orderRequestMapper.selectTotalCNBill(params);
					
					if(CommonUtils.intNvl(cnMap.get("cnt")) > 0) {
						TotalCNBill = (BigDecimal) cnMap.get("cnAmount");
					}
					
					//Get Order Total Bill RPF
					EgovMap tbMap2 = orderRequestMapper.selectAccRentLedger2(params);
					
					if(CommonUtils.intNvl(tbMap2.get("cnt")) > 0) {
						TotalBillRPF = (BigDecimal) tbMap2.get("rentAmt");
					}
					
					//Get Order Tota DN RPF
					EgovMap dnMap2 = orderRequestMapper.selectTotalDNBill2(params);
					
					if(CommonUtils.intNvl(dnMap2.get("cnt")) > 0) {
						TotalDNRPF = (BigDecimal) dnMap.get("rentAmt");
					}
					
					//Get Order Total CN RPF
					EgovMap cnMap2 = orderRequestMapper.selectTotalCNBill2(params);
					
					if(CommonUtils.intNvl(cnMap2.get("cnt")) > 0) {
						TotalCNRPF = (BigDecimal) cnMap2.get("cnAmount");
					}
					
					//Get Order Total Outstanding
					TotalOutstanding = (BigDecimal) rlMap.get("rentAmt");
				}
				
				
                //Get Last Bill Month
				if(CommonUtils.intNvl(rlMap.get("cnt")) > 0) {
					EgovMap lbMap = orderRequestMapper.selectLastBill(params);
					
					if(lbMap != null) {
						LastBillMth = CommonUtils.intNvl(lbMap.get("rentInstNo"));
					}
                }
                
				//Get Current Bill Month
				EgovMap qryMaxBillMonth = orderRequestMapper.selectRentalInst(params);
				
				if(qryMaxBillMonth != null) {
					if(Integer.parseInt(((String)qryMaxBillMonth.get("rentInstDt")).substring(0, 6)+"01") <= CommonUtils.intNvl(CommonUtils.getNowDate())) {
						CurrentBillMth = CommonUtils.intNvl(qryMaxBillMonth.get("rentInstNo"));
					}
					else {
						EgovMap qryCurrentBillMonth = orderRequestMapper.selectRentalInst2(params);
						
						if(qryCurrentBillMonth != null) {
							CurrentBillMth = CommonUtils.intNvl(qryCurrentBillMonth.get("rentInstNo"));
						}
					}
				}
			}
		}

		view.put("currentbillmth", CurrentBillMth);
		view.put("lastbillmth", LastBillMth);
		view.put("installdate", installDate);
		view.put("totaloutstanding", TotalOutstanding);
		view.put("outrightprice", OutrightPrice);
		view.put("totalbillamt", TotalBillAmt);
		view.put("totalbillrpf", TotalBillRPF);
		view.put("totaldnbill", TotalDNBill);
		view.put("totalcnbill", TotalCNBill);
		view.put("totaldnrpf", TotalDNRPF);
		view.put("totalcnrpf", TotalCNRPF);
		
		return view;
	}

	@Override
	public EgovMap selectValidateInfo(Map<String, Object> params) {
		
		String isInValid = "Valid", msgT = "", msg = "";
				
		EgovMap view = this.selectOrderSimulatorViewByOrderNo2(params);
		EgovMap RESULT = new EgovMap();
		
		int salesOrdId = Integer.parseInt(String.valueOf(view.get("salesOrdId")));
		int appTypeId = Integer.parseInt(String.valueOf(view.get("appTypeId")));
		int orderStatusID = Integer.parseInt(String.valueOf(view.get("stusCodeId")));
		String rentalStatus = String.valueOf(view.get("stusCodeId1"));
		
		int CurrentBillMth = 0;
		int LastBillMth = 0;
		String installDate = "";
		BigDecimal TotalOutstanding = BigDecimal.ZERO;
		
		if(view != null) {
			logger.debug("CurrentBillMth:"+(int) view.get("currentbillmth"));
			CurrentBillMth = (int) view.get("currentbillmth");
			LastBillMth = (int) view.get("lastbillmth");
			installDate = (String) view.get("installdate");
			TotalOutstanding = (BigDecimal) view.get("totaloutstanding");
		}
		
		if(view == null || salesOrdId == 0) {
			msgT = "Invalid Order";
			msg  = "Invalid order number.";
			isInValid = "isInValid";
		}
		else {
			if(appTypeId != SalesConstants.APP_TYPE_CODE_ID_RENTAL
					&& appTypeId != SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT
					&& appTypeId != SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT) {
				msgT = "Invalid Application Type";
				msg  = "Only Outright/Instalment/Rental order is allowed.";
				isInValid = "isInValid";
			}
			else if(appTypeId == SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
				if(SalesConstants.RENTAL_STATUS_SUS.equals(rentalStatus)
						|| SalesConstants.RENTAL_STATUS_TER.equals(rentalStatus)
						|| SalesConstants.RENTAL_STATUS_RET.equals(rentalStatus)
						|| SalesConstants.RENTAL_STATUS_WOF.equals(rentalStatus)) {
					msgT = "Contact CRT";
					msg  = "This order is under SUS/TER/RET/WOF. Contact CRT.";
					isInValid = "isInValid";
				}
				else if(orderStatusID == 4) {
					if(CurrentBillMth > LastBillMth) {
						msgT = "Unbill Amount Exist";
						msg  = "This order come with un-bill amount. Contact CRT.";
						isInValid = "isInValid";
					}
					else if(LastBillMth >= 24) {
						msgT = "Unbill Amount Exist";
						msg  = "This order come with un-bill amount. Contact CRT.";
						isInValid = "isInValid";
					}
					else if(Integer.parseInt(installDate) <= 19000101) {
						msgT = "Invalid Install Date";
						msg  = "Invalid install date.";
						isInValid = "isInValid";
					}
					else if(TotalOutstanding.compareTo(BigDecimal.ZERO) < 0) {
						msgT = "Advanced Payment Exist";
						msg  = "This order has advanced payment.";
						isInValid = "isInValid";
					}
					else if(TotalOutstanding.compareTo(BigDecimal.ZERO) > 0) {
						msgT = "Outstanding Exist";
						msg  = "This order has outstanding.";
						isInValid = "isInValid";
					}
				}
			}
		}
		
        RESULT.put("IS_IN_VALID", isInValid);
        RESULT.put("MSG_T", msgT);
        RESULT.put("MSG", msg);
        
		return RESULT;
	}
	
	@Override
	public EgovMap selectValidateInfoSimul(Map<String, Object> params) {
		
		String isInValid = "Valid", msgT = "", msg = "";
				
		EgovMap view = this.selectOrderSimulatorViewByOrderNo2(params);
		EgovMap RESULT = new EgovMap();
		
		int salesOrdId = CommonUtils.intNvl(view.get("salesOrdId"));
		int appTypeId = CommonUtils.intNvl(view.get("appTypeId"));
		int orderStatusID = CommonUtils.intNvl(view.get("stusCodeId"));
		String rentalStatus = String.valueOf(view.get("stusCodeId1"));
		
		int CurrentBillMth = 0;
		int LastBillMth = 0;
		String installDate = "";
		BigDecimal TotalOutstanding = BigDecimal.ZERO;
		BigDecimal OutrightPrice = BigDecimal.ZERO;
		
		if(view != null) {
			logger.debug("CurrentBillMth:"+(int) view.get("currentbillmth"));
			CurrentBillMth = (int) view.get("currentbillmth");
			LastBillMth = (int) view.get("lastbillmth");
			installDate = (String) view.get("installdate");
			TotalOutstanding = (BigDecimal) view.get("totaloutstanding");
			OutrightPrice = (BigDecimal) view.get("outrightprice");
		}
		
		if(view == null || salesOrdId == 0) {
			msgT = "Invalid Order";
			msg  = "Invalid order number.";
			isInValid = "isInValid";
		}
		else {
			if(appTypeId != SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
				msgT = "Non-Rental Order";
				msg  = "This is non-rental sales order.";
				isInValid = "isInValid";
			}
			else {
				if(orderStatusID != 4) {
					msgT = "Non-Complete Order";
					msg  = "This is non-complete sales order.";
					isInValid = "isInValid";
				}
				else {
    				if(SalesConstants.RENTAL_STATUS_SUS.equals(rentalStatus)
    						|| SalesConstants.RENTAL_STATUS_TER.equals(rentalStatus)
    						|| SalesConstants.RENTAL_STATUS_RET.equals(rentalStatus)
    						|| SalesConstants.RENTAL_STATUS_WOF.equals(rentalStatus)) {
    					msgT = "Contact CRT";
    					msg  = "This order is under SUS/TER/RET/WOF. Contact CRT.";
    					isInValid = "isInValid";
    				}
    				else {
    					logger.debug("CurrentBillMth"+CurrentBillMth);
    					logger.debug("LastBillMth"+LastBillMth);
    					if(CurrentBillMth > LastBillMth) {
    						msgT = "Unbill Amount Exist";
    						msg  = "This order come with un-bill amount. Contact CRT.";
    						isInValid = "isInValid";
    					}
    					else if(LastBillMth >= 48) {
    						msgT = "Exceed 48 Billing Month";
    						msg  = "This order exceeded 48th billing month.";
    						isInValid = "isInValid";
    					}
    					else if(OutrightPrice.compareTo(BigDecimal.ZERO) == 0) {
    						msgT = "Outright Price Missing";
    						msg  = "Unable to retrieve outright price.";
    						isInValid = "isInValid";
    					}
    					else if(Integer.parseInt(installDate) <= 19000101) {
    						msgT = "Invalid Install Date";
    						msg  = "Invalid install date.";
    						isInValid = "isInValid";
    					}
    				}
				}
			}
		}
		
        RESULT.put("IS_IN_VALID", isInValid);
        RESULT.put("MSG_T", msgT);
        RESULT.put("MSG", msg);
        
		return RESULT;
	}

	@Override
	public EgovMap selectObligtPriod(Map<String, Object> params) {
		return orderRequestMapper.selectObligtPriod(params);
	}

	@Override
	public EgovMap selectPenaltyAmt(Map<String, Object> params) {
		return orderRequestMapper.selectPenaltyAmt(params);
	}

}
