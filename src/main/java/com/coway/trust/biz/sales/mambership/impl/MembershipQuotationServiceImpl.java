/**
 *
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.joda.time.LocalDate;
import org.joda.time.Months;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.sales.mambership.MembershipQuotationService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Service("membershipQuotationService")
public class MembershipQuotationServiceImpl extends EgovAbstractServiceImpl implements MembershipQuotationService {

	private static final Logger logger = LoggerFactory.getLogger(MembershipQuotationServiceImpl.class);

	@Resource(name = "membershipQuotationMapper")
	private MembershipQuotationMapper membershipQuotationMapper;

	@Resource(name = "membershipRentalQuotationMapper")
	private MembershipRentalQuotationMapper membershipRentalQuotationMapper;


	@Resource(name = "membershipConvSaleMapper")
	private MembershipConvSaleMapper membershipConvSaleMapper;

	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Override
	public List<EgovMap> quotationList(Map<String, Object> params) {
		return membershipQuotationMapper.quotationList(params);
	}


	@Override
	public List<EgovMap> newOListuotationList(Map<String, Object> params) {
		return membershipQuotationMapper.newOListuotationList(params);
	}


	@Override
	public  EgovMap newGetExpDate(Map<String, Object> params) {
		return membershipQuotationMapper.newGetExpDate(params);
	}


	@Override
	public List<EgovMap> getSrvMemCode(Map<String, Object> params) {
		return membershipQuotationMapper.getSrvMemCode(params);
	}


	@Override
	public  EgovMap mPackageInfo(Map<String, Object> params) {

		String zeroRatYn = "Y";
		String eurCertYn = "Y";

        params.put("srvSalesOrderId", params.get("ORD_ID"));

        logger.debug("zeroRat ==========================>>  " + membershipRentalQuotationMapper.selectGSTZeroRateLocation(params));
        logger.debug("EURCert ==========================>>  " + membershipRentalQuotationMapper.selectGSTEURCertificate(params));

		int zeroRat =  membershipRentalQuotationMapper.selectGSTZeroRateLocation(params);
		if(zeroRat > 0 ){
			zeroRatYn = "N";
		}

		int EURCert = membershipRentalQuotationMapper.selectGSTEURCertificate(params);
		if(EURCert > 0 ){
			eurCertYn = "N";
		}

		EgovMap result = membershipQuotationMapper.mPackageInfo(params);

		if(result == null){
			result = new EgovMap();
		}

		 logger.debug("zeroRat ==========================>>  " + zeroRatYn);
	     logger.debug("eurCertYn ==========================>>  " + eurCertYn);


		result.put("zeroRatYn", zeroRatYn);
		result.put("eurCertYn", eurCertYn);

//		return membershipQuotationMapper.mPackageInfo(params);
		return result;
	}

	@Override
	public List<EgovMap> getPromotionCode(Map<String, Object> params) {
		return membershipQuotationMapper.getPromotionCode(params);
	}


	@Override
	public EgovMap    getFilterCharge(Map<String, Object> params) {
		return  membershipQuotationMapper.getFilterCharge(params);
		// return  (EgovMap)  params.get("p1");
	}



	@Override
	public List<EgovMap> getFilterPromotionCode(Map<String, Object> params) {
		return membershipQuotationMapper.getFilterPromotionCode(params);
	}

	@Override
	public EgovMap  getFilterPromotionAmt(Map<String, Object> params) {
		return membershipQuotationMapper.getFilterPromotionAmt(params);
	}




	@Override
	public List<EgovMap> getPromoPricePercent(Map<String, Object> params) {
		return membershipQuotationMapper.getPromoPricePercent(params);
	}
	@Override
	public List<EgovMap> getFilterChargeList(Map<String, Object> params) {
//		return membershipQuotationMapper.getFilterChargeList(params);
		membershipQuotationMapper.getFilterCharge(params);
		return (List<EgovMap>) params.get("p1");
	}

	@Override
	public double getFilterChargeListSum(Map<String, Object> params) {

		membershipQuotationMapper.getFilterCharge(params);

		List<EgovMap> list = (List<EgovMap>) params.get("p1");

		int sum = 0;

		 logger.debug("zeroRat ==========================>>  " + params.get("zeroRatYn"));
	     logger.debug("eurCertYn ==========================>>  " + params.get("eurCertYn"));

		for(EgovMap result : list ){

			logger.debug("PRC ==========================>>  " + result.get("prc"));

			double prc = Math.floor(Double.parseDouble(result.get("prc").toString()));

		     logger.debug("PRC ==========================>>  " + prc);

			if("N".equals(params.get("zeroRatYn"))||"N".equals(params.get("eurCertYn"))){

				//sum  += Math.floor((double)(prc  * 100 / 106 )); -- without GST 6% edited by TPY 23/05/2018
				sum  += Math.floor((double)(prc));

			     logger.debug("SUM 111 :: ==========================>>  " + sum);

			}else{
				sum  += prc;

			     logger.debug("SUM 222 :: ==========================>>  " + sum);
			}

		}


		return sum ;//membershipQuotationMapper.getFilterChargeListSum(params);
	}



	@Override
	public List<EgovMap> getOrderCurrentBillMonth(Map<String, Object> params) {
		return membershipQuotationMapper.getOrderCurrentBillMonth(params);
	}



	@Override
	public EgovMap    getOderOutsInfo(Map<String, Object> params) {

		  membershipQuotationMapper.getOderOutsInfo(params)  ;

		  EgovMap   map =  (EgovMap)  ((ArrayList)params.get("p1")).get(0);
 		  logger.debug("map =============>" +map.toString());

		return    map;
	}

	@Override
	public EgovMap  getOutrightMemLedge(Map<String, Object> params) {
		return membershipQuotationMapper.getOutrightMemLedge(params);
	}


	@Override
	public String  insertQuotationInfo(Map<String, Object> params) {

		boolean isVerifyGSTEURCertificate   = true;
		boolean verifyGSTZeroRateLocation = true;

		String docNo = "";

		int zeroRat =  membershipRentalQuotationMapper.selectGSTZeroRateLocation(params);
		if(zeroRat > 0 ){
			verifyGSTZeroRateLocation = false;
		}

		int EURCert = membershipRentalQuotationMapper.selectGSTEURCertificate(params);
		if(EURCert > 0 ){
			isVerifyGSTEURCertificate = false;
		}


	/*	  ////////	 get taxRate////////////////
		 int  TAXRATE = membershipConvSaleMapper.getTaxRate(params);
		  ////////	 InvoiceNum  채번 ////////////////

		 if( TAXRATE ==6){
			 isVerifyGSTEURCertificate =false;
			 verifyGSTZeroRateLocation =false;
		 }*/


		int sstValue = CommonUtils.intNvl(commonMapper.getSstTaxRate());
		params.put("srvMemPacSst", sstValue);

		if(sstValue > 0 ){
			 DecimalFormat df = new DecimalFormat("#0.00");

			 double   srvMemPacAmt =  0;
			 double   srvMemPacNetAmt  =  0;
			 double   cvtMemPacNetAmt = 0;

			 srvMemPacAmt 	  	= params.containsKey("srvMemPacAmt") ? Double.parseDouble(params.get("srvMemPacAmt").toString()) : 0.00;
			 srvMemPacNetAmt 	= params.containsKey("srvMemPacNetAmt") ? Double.parseDouble(params.get("srvMemPacNetAmt").toString()): 0.00;

			 srvMemPacAmt 	= Double.parseDouble(df.format((srvMemPacAmt)));
			 srvMemPacNetAmt 	= Double.parseDouble(df.format((srvMemPacNetAmt)));

	         double taxAmt = Double.parseDouble(df.format((srvMemPacAmt - srvMemPacNetAmt)));

			 params.put("srvMemPacAmt", srvMemPacAmt);
			 params.put("srvMemPacNetAmt", srvMemPacNetAmt);
			 params.put("srvMemPacTaxes", taxAmt);


		}else{

    			if(!isVerifyGSTEURCertificate ){

        		 	//params.put("srvMemPacNetAmt", params.get("srvMemPacAmt"));
        		 	params.put("srvMemPacAmt", params.get("srvMemPacAmt"));
        		 	params.put("srvMemPacNetAmt", params.get("srvMemPacNetAmt"));
        		    params.put("srvMemPacTaxes", "0");
    		/*
    //		 }else if(verifyGSTZeroRateLocation){

    			 	params.put("srvMemPacNetAmt", params.get("srvMemPacAmt"));
    			    params.put("srvMemPacTaxes", "0");
    			    params.put("srvMemBSAmt", params.get("srvMemBSAmt"));
    			    params.put("srvMemBSNetAmt", params.get("srvMemBSAmt"));
    			    params.put("srvMemBSTaxes", "0");*/

    		 }else {

    			 double   srvMemPacAmt =  0;
    			 double   srvMemPacNetAmt  =  0;
    			 double   cvtMemPacNetAmt = 0;

    			 srvMemPacAmt 	  	= CommonUtils.intNvl((String)params.get("srvMemPacAmt"));
    			 srvMemPacNetAmt 	= CommonUtils.intNvl((String)params.get("srvMemPacNetAmt"));

    			 //srvMemPacNetAmt = (srvMemPacAmt  * 100 / 106  ) *100; -- without GST 6% edited by TPY 23/05/2018
    			 srvMemPacNetAmt = srvMemPacAmt  * 100 ;
    			 cvtMemPacNetAmt = Math.round(srvMemPacNetAmt);

    			 srvMemPacNetAmt  = cvtMemPacNetAmt / 100;

    			 params.put("srvMemPacNetAmt", srvMemPacNetAmt);
    			 params.put("srvMemPacTaxes", srvMemPacAmt - srvMemPacNetAmt);
    		 }
		}


		if(!isVerifyGSTEURCertificate || !verifyGSTZeroRateLocation){

		    params.put("srvMemBSAmt", params.get("srvMemBSAmt"));
		    params.put("srvMemBSNetAmt", params.get("srvMemBSAmt"));
		    params.put("srvMemBSTaxes", "0");

		}else{

			 double   srvMemBSNetAmt =0;
			 double	  srvMemBSAmt=0;

			 srvMemBSNetAmt  	= CommonUtils.intNvl((String)params.get("srvMemBSNetAmt"));
			 srvMemBSAmt			= CommonUtils.intNvl((String)params.get("srvMemBSAmt"));

			 //srvMemBSNetAmt	=Math.round((double)(srvMemBSAmt  * 100 / 106 )*100)/100; -- without GST 6% edited by TPY 23/05/2018
			 srvMemBSNetAmt	=Math.round((double)(srvMemBSAmt)*100)/100;
			 params.put("srvMemBSNetAmt",srvMemBSNetAmt );
			 params.put("srvMemBSTaxes",srvMemBSAmt - srvMemBSNetAmt );

		}

		params.put("DOCNO", "20");
		EgovMap  docNoMp = membershipQuotationMapper.getEntryDocNo(params);
		docNo = docNoMp.get("docno").toString();
		params.put("srvMemQuotNo",docNoMp.get("docno"));
		EgovMap   seqMap = membershipQuotationMapper.getSAL0093D_SEQ (params);

		logger.debug("seqMap =============>" +seqMap.toString());

		String  SAL0093D_SEQ = String.valueOf(seqMap.get("seq"));

		if("".equals(SAL0093D_SEQ)){
			throw new ApplicationException(AppConstants.FAIL, "can't  get SAL0095d_SEQ !!");
		}

		logger.debug("SAL0093D_SEQ =============>");
		logger.debug("SAL0093D_SEQ : {}", SAL0093D_SEQ);
		logger.debug("SAL0093D_NO : {}", docNoMp.get("docno"));

		params.put("SAL0093D_SEQ" , SAL0093D_SEQ);
		params.put("SAL0093D_NO" , 		docNoMp.get("docno"));



		//1. insert
		membershipQuotationMapper.insertQuotationInfo(params);

		String isFilter =(String) params.get("isFilterCharge");


		 if("TRUE".equals(isFilter)){
			 //2. get getMembershipFilterChargeList 프로시져 호출
			 //3. 프로시져 result foreach

			 params.put("ORD_ID" , params.get("srvSalesOrderId"));
			 params.put("PROMO_ID" , params.get("srvPromoId"));

			 membershipQuotationMapper.getFilterCharge(params) ;

			 logger.debug("map =============>" +params.toString());

			 ArrayList  list = (ArrayList) params.get("p1");
			 EgovMap  eFilterMap = null;

			 if(list.size() >0 ){
				 for(int a =0; a<list.size() ; a++){

					 eFilterMap = new EgovMap();
					 Map rMap  = (Map) list.get(a);


					 eFilterMap.put("SrvMemQuotFilterID", SAL0093D_SEQ);
					 eFilterMap.put("StkID", rMap.get("filterId"));

					 eFilterMap.put("StkPeriod", rMap.get("lifePriod") );
					 eFilterMap.put("StkLastChangeDate", rMap.get("lastChngDt"));

					 eFilterMap.put("StkFilterPrice", rMap.get("oriPrc"));
					 eFilterMap.put("StkChargePrice", Math.floor(Double.parseDouble(rMap.get("prc").toString())));

//					 if(verifyGSTZeroRateLocation){
					/* if(isVerifyGSTEURCertificate){

						 eFilterMap.put("StkNetAmt", rMap.get("prc"));
						 eFilterMap.put("StkTaxes", rMap.get("0"));

					 }else*/
					 if(!verifyGSTZeroRateLocation || !isVerifyGSTEURCertificate){

						 double chargePrice =  Math.floor(Double.parseDouble(rMap.get("prc").toString())); //CommonUtils.intNvl(String.valueOf(rMap.get("prc")));

						 //double stkNetAmt = Math.floor((float)(chargePrice  * 100 / 106 ) *100)/100; -- without GST 6% edited by TPY 23/05/2018

						 double stkNetAmt = Math.floor((float)(chargePrice) *100)/100;

						 eFilterMap.put("StkChargePrice", stkNetAmt);
						 eFilterMap.put("StkNetAmt", stkNetAmt);
						 eFilterMap.put("StkTaxes", "0");


						 logger.debug("stkNetAmt 111 =============>" +stkNetAmt);

					 }else {

						 double   chargePrice =  Math.floor(Double.parseDouble(rMap.get("prc").toString())); //CommonUtils.intNvl(String.valueOf(rMap.get("prc")));
						 double   stkNetAmt  =  0;

						 //stkNetAmt = Math.floor((float)(chargePrice  * 100 / 106 )*100)/100; -- without GST 6% edited by TPY 23/05/2018
						 stkNetAmt = Math.floor((float)(chargePrice)*100)/100;
						 eFilterMap.put("StkNetAmt", stkNetAmt);
						 eFilterMap.put("StkTaxes", chargePrice -stkNetAmt  );

						 logger.debug("stkNetAmt 222 =============>" +stkNetAmt);

					 }

					 membershipQuotationMapper.insertSrvMembershipQuot_Filter(eFilterMap);
				 }
			 }
		 }



		 return docNo;
	}


	@Override
	public EgovMap    getMembershipFilterChargeList(Map<String, Object> params) {
		 return  membershipQuotationMapper.getMembershipFilterChargeList(params);
	}


	@Override
	public void    insertSrvMembershipQuot_Filter(Map<String, Object> params) {
		  membershipQuotationMapper.insertSrvMembershipQuot_Filter(params);
	}



	@Override
	public EgovMap    getSAL0093D_SEQ(Map<String, Object> params) {
		return  membershipQuotationMapper.getSAL0093D_SEQ(params);
	}


	@Override
	public Map<String, Object> mSubscriptionEligbility(Map<String, Object> params) {

		EgovMap list = membershipQuotationMapper.mSubscriptionEligbility(params);
		Map<String, Object>  data =  new HashMap<String, Object>();

		if(list != null){

    		// Check material's status
    		if(!list.get("status").toString().equals("1")){
    			data.put("result", false);
    			data.put("title", "Message");
    			data.put("message", "This order is not valid for membership.");

    		}else {
    			// Get month range of EOS and EOM
    			EgovMap svmDateRange = membershipQuotationMapper.getSVMConfig(params);
    			int svmDateRange_SOLED = Integer.parseInt(svmDateRange.get("svmSoled").toString());
    			int svmDateRange_EOM = Integer.parseInt(svmDateRange.get("svmEom").toString());

    			// Today
    			LocalDate now = LocalDate.now();
    			// Check sales order last service date
    			EgovMap lastServiceDate = membershipQuotationMapper.getSalesOrderLastExpiredDate(params);

    			// Get app type id
    			int appType = Integer.parseInt(list.get("appType").toString());
    			// Get existence of service package id = 9
    			String servicePacIdExist = membershipQuotationMapper.getServicePacIdExist(params).get("pacExist").toString();


    			if(appType == 66 ){

   	    			if(lastServiceDate != null){

	    				LocalDate lastServiceDt = LocalDate.parse(lastServiceDate.get("lastSrvMemExprDate").toString());
	    				int lastService_MonthsBetween = Months.monthsBetween(now, lastServiceDt).getMonths();

	    				if(lastService_MonthsBetween > svmDateRange_SOLED){
    						data.put("result", false);
        					data.put("title", "Early Subscription > "+ svmDateRange_SOLED +" months");
        					data.put("message", "The order is <strong>too early to subscribe for SVM</strong>, kindly subscribe the membership within "+ svmDateRange_SOLED +" months period form the order expired date.");
						}
	    			}

				}else{

					if(lastServiceDate != null){

	    				LocalDate lastServiceDt = LocalDate.parse(lastServiceDate.get("lastSrvMemExprDate").toString());
	    				int lastService_MonthsBetween = Months.monthsBetween(now, lastServiceDt).getMonths();

	    				if(lastService_MonthsBetween > svmDateRange_SOLED){
	    					if(servicePacIdExist.equals("Y")){
		    					data.put("result", false);
		    					data.put("title", "Warning");
		    					data.put("message", "The order is <strong>too early to subscribe for SVM</strong>.");
		    				}
						}

					}else{

						if(servicePacIdExist.equals("Y")){
	    					data.put("result", false);
	    					data.put("title", "Warning");
	    					data.put("message", "The order is <strong>too early to subscribe for SVM</strong>.");
	    				}
					}
				}

    			//Check end of membership
    			if(list.containsKey("eom") == true){
    				//Parse EOM date
    				LocalDate eom = LocalDate.parse(list.get("eom").toString());

    				int EOM_MonthsBetween = Months.monthsBetween(now, eom).getMonths();

    				if(EOM_MonthsBetween < svmDateRange_EOM){
    					data.put("result", false);
        				data.put("title", "End of Membership");
        				data.put("message", "The order is <strong>end of membership soon</strong> <i>(within "+ svmDateRange_EOM +" months period)</i><strong> - not entitled to subscribe SVM</strong></br> Kindly suggest customer to do Ex-Trade for this model.");
            		}
        		}
    		}
    	}

		return data;
	}


	@Override
	public List<EgovMap> mActiveQuoOrder(Map<String, Object> params) {
		return membershipQuotationMapper.mActiveQuoOrder(params);
	}

	@Override
	public List<EgovMap> selectSrchMembershipQuotationPop(Map<String, Object> params) {
		return membershipQuotationMapper.selectSrchMembershipQuotationPop(params);
	}


	@Override
	public void updateStus(Map<String, Object> params) {
		  membershipQuotationMapper.update_SAL0093D_Stus(params);

	}

	@Override
    public  EgovMap getMaxPeriodEarlyBirdPromo(Map<String, Object> params) {
        return membershipQuotationMapper.getMaxPeriodEarlyBirdPromo(params);
    }

	@Override
	public List<EgovMap> mEligibleEVoucher(Map<String, Object> params) {
		return membershipQuotationMapper.mEligibleEVoucher(params);
	}

}



