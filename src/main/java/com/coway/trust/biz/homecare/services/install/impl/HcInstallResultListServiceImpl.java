package com.coway.trust.biz.homecare.services.install.impl;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.services.install.HcInstallResultListService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("hcInstallResultListService")
public class HcInstallResultListServiceImpl extends EgovAbstractServiceImpl implements HcInstallResultListService {

	@Resource(name = "installationResultListService")
    private InstallationResultListService installationResultListService;

    @Resource(name = "hcInstallResultListMapper")
    private HcInstallResultListMapper hcInstallResultListMapper;

    @Resource(name = "hcOrderListService")
    private HcOrderListService hcOrderListService;

    @Autowired
	private MessageSourceAccessor messageAccessor;

    /**
     * Insert Installation Result
     * @Author KR-SH
     * @Date 2019. 12. 20.
     * @param params
     * @param sessionVO
     * @return
     * @throws ParseException
     * @see com.coway.trust.biz.homecare.services.install.HcInstallResultListService#insertInstallationResultSerial(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
     */
    @Override
    public ReturnMessage hcInsertInstallationResultSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception {
    	ReturnMessage message = new ReturnMessage();
    	String rmsg = "";

		ReturnMessage rtnMsg = installationResultListService.insertInstallationResultSerial(params, sessionVO);
		if("99".equals(rtnMsg.getCode())){
			throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnMsg.getMessage()));
		}
		rmsg = rtnMsg.getMessage();

    	// another order  --  Frame Order Search.
    	params.put("ordNo", CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")));
    	EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);

    	if(!"".equals(CommonUtils.nvl(hcOrder.get("anoOrdNo")))) { // hava another order
    		params.put("anoOrdNo", CommonUtils.nvl(hcOrder.get("anoOrdNo")));
    		EgovMap anotherOrder = hcInstallResultListMapper.getAnotherInstallInfo(params);

    		params.put("installEntryId", CommonUtils.nvl(anotherOrder.get("installEntryId")));
    		params.put("hidSalesOrderId", CommonUtils.nvl(anotherOrder.get("salesOrdId")));
    		params.put("hiddeninstallEntryNo", CommonUtils.nvl(anotherOrder.get("installEntryNo")));
    		params.put("rcdTms", CommonUtils.nvl(anotherOrder.get("rcdTms")));
    		params.put("hidEntryId", CommonUtils.nvl(anotherOrder.get("installEntryId")));
    		params.put("hidSerialRequireChkYn", "N");


    		/* hidden input Start - KR-JIN */
    		EgovMap callType = installationResultListService.selectCallType(anotherOrder);
    		if(callType != null){
    			params.put("hidCallType", callType.get("typeId"));
    		}

    		EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
    		if(installResult != null){
    			params.put("hidCustomerId", installResult.get("custId"));
    			params.put("hidSirimNo",  installResult.get("sirimNo"));
    			// hidSerialNo
    			params.put("hidStockIsSirim", installResult.get("isSirim"));
    			params.put("hidStockGrade", installResult.get("stkGrad"));
    			params.put("hidSirimTypeId", installResult.get("stkCtgryId"));
    			params.put("hidAppTypeId", installResult.get("codeId"));
    			params.put("hidProductId", installResult.get("installStkId"));
    			params.put("hidCustAddressId", installResult.get("custAddId"));
    			params.put("hidCustContactId", installResult.get("custCntId"));
    			params.put("hiddenBillId", installResult.get("custBillId"));
    			params.put("hiddenCustomerPayMode", installResult.get("codeName"));

    			params.put("hidTaxInvDSalesOrderNo", installResult.get("salesOrdNo"));
    			params.put("hidTradeLedger_InstallNo", installResult.get("installEntryNo"));
    		}

    		EgovMap stock = installationResultListService.getStockInCTIDByInstallEntryIDForInstallationView(installResult);
    		if(stock != null){
    			params.put("hidActualCTMemCode", stock.get("memCode"));
    			params.put("hidActualCTId", stock.get("movToLocId"));
    		}

    		EgovMap sirimLoc = installationResultListService.getSirimLocByInstallEntryID(installResult);
    		if(sirimLoc != null){
    			params.put("hidSirimLoc", sirimLoc.get("whLocCode"));
    		}

            EgovMap orderInfo = new EgovMap();
            if (installResult.get("codeid1").toString().equals("258")) { // PRODUCT EXCHANGE
            	orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
            } else { // NEW PRODUCT INSTALLATION
            	orderInfo = installationResultListService.getOrderInfo(params);
            }

            if(orderInfo != null){
            	params.put("hidCategoryId", orderInfo.get("stkCtgryId"));

            	if(CommonUtils.intNvl(callType.get("typeId")) == 258){
            		params.put("hidPromotionId", orderInfo.get("c8"));
            		params.put("hidPriceId", orderInfo.get("c11"));
            		params.put("hiddenOriPriceId", orderInfo.get("c11"));
    				params.put("hiddenOriPrice", orderInfo.get("c12"));
    				params.put("hiddenOriPV", orderInfo.get("c13"));
    				params.put("hiddenProductItem", orderInfo.get("c7"));
    				params.put("hidPERentAmt", orderInfo.get("c17"));
    				params.put("hidPEDefRentAmt", orderInfo.get("c18"));
    				params.put("hidInstallStatusCodeId", orderInfo.get("c19"));
    				params.put("hidPEPreviousStatus", orderInfo.get("c20"));
    				params.put("hidDocId", orderInfo.get("docId"));
    				params.put("hidOldPrice", orderInfo.get("c15"));
    				params.put("hidExchangeAppTypeId", orderInfo.get("c21"));
            	}else{
            		params.put("hidPromotionId", orderInfo.get("c2"));
    				params.put("hidPriceId", orderInfo.get("itmPrcId"));
    				params.put("hiddenOriPriceId", orderInfo.get("itmPrcId"));
    				params.put("hiddenOriPrice", orderInfo.get("c5"));
    				params.put("hiddenOriPV", orderInfo.get("c6"));
    				params.put("hiddenCatogory", orderInfo.get("codename1"));
    				params.put("hiddenProductItem", orderInfo.get("stkDesc"));
    				params.put("hidPERentAmt", orderInfo.get("c7"));
    				params.put("hidPEDefRentAmt", orderInfo.get("c8"));
    				params.put("hidInstallStatusCodeId", orderInfo.get("c9"));
            	}
            }
            /* customerContractInfo */
            // hiddenCustomerType
            // hidCustomerContact
            // hidInatallation_ContactPerson

            /* customerInfo */
            // hidCustomerName

            /* installation */
            //hidInstallation_AddDtl
            //hidInstallation_AreaID
            //hiddenInstallPostcode
            //hiddenInstallStateName

            if(installResult.get("codeid1").toString().equals("257")){
            	params.put("hidOutright_Price", orderInfo.get("c5"));
            }
            if(installResult.get("codeid1").toString().equals("258")){
            	params.put("hidOutright_Price", orderInfo.get("c12"));
            }

            int promotionId = 0;
            if ("258".equals(CommonUtils.nvl(installResult.get("codeid1")))) {
            	promotionId = CommonUtils.intNvl(orderInfo.get("c8"));
            } else {
            	promotionId = CommonUtils.intNvl(orderInfo.get("c2"));
            }

            EgovMap promotionView = new EgovMap();
            List<EgovMap> CheckCurrentPromo = installationResultListService.checkCurrentPromoIsSwapPromoIDByPromoID(promotionId);
            if (CheckCurrentPromo.size() > 0) {
            	promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(promotionId, CommonUtils.intNvl(installResult.get("installStkId")), true);

            } else {
            	if (promotionId != 0) {
            		promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(promotionId, CommonUtils.intNvl(installResult.get("installStkId")), false);

            	} else {
            		promotionView.put("promoId", "0");
            		promotionView.put("promoPrice", CommonUtils.nvl(params.get("codeId")) == "258" ? CommonUtils.nvl(orderInfo.get("c15")) : CommonUtils.nvl(orderInfo.get("c5")));
            		promotionView.put("promoPV", CommonUtils.nvl(params.get("codeId")) == "258" ? CommonUtils.nvl(orderInfo.get("c16")) : CommonUtils.nvl(orderInfo.get("c6")));
            		promotionView.put("swapPromoId", "0");
            		promotionView.put("swapPromoPV", "0");
            		promotionView.put("swapPormoPrice", "0");
            	}
            }

            params.put("hidPromoId", promotionView.get("promoId"));
            params.put("hidPromoPrice", promotionView.get("promoPrice"));
            params.put("hidPromoPV", promotionView.get("promoPV"));
            params.put("hidSwapPromoId", promotionView.get("swapPromoId"));
            params.put("hidSwapPromoPrice", promotionView.get("swapPormoPrice"));
            params.put("hidSwapPromoPV", promotionView.get("swapPromoPV"));
            /* hidden input End - KR-JIN */

    		rtnMsg = installationResultListService.insertInstallationResultSerial(params, sessionVO);
    		if("99".equals(rtnMsg.getCode())){
    			throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnMsg.getMessage()));
    		}
    		rmsg = rtnMsg.getMessage();
    	}

    	message.setCode(AppConstants.SUCCESS);
    	if(StringUtils.isBlank(rmsg)){
    		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    	}else{
    		message.setMessage(rmsg);
    	}

    	return message;
    }

	/**
	 * Select Homecare Installation List
	 * @Author KR-SH
	 * @Date 2019. 12. 20.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.install.HcInstallResultListService#hcInstallationListSearch(java.util.Map)
	 */
	@Override
	public List<EgovMap> hcInstallationListSearch(Map<String, Object> params) {
		return hcInstallResultListMapper.hcInstallationListSearch(params);
	}
}
