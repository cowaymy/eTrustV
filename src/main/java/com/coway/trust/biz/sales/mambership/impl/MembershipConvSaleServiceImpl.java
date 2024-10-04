/**
 *
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.sales.mambership.MembershipConvSaleService;
import com.coway.trust.biz.sales.pos.impl.PosMapper;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Service("membershipConvSaleService")

public class MembershipConvSaleServiceImpl extends EgovAbstractServiceImpl implements MembershipConvSaleService {

	private static Logger logger = LoggerFactory.getLogger(MembershipConvSaleServiceImpl.class);

	@Resource(name = "membershipConvSaleMapper")
	private MembershipConvSaleMapper membershipConvSaleMapper;

	@Resource(name = "membershipRentalQuotationMapper")
	private MembershipRentalQuotationMapper membershipRentalQuotationMapper;


	@Resource(name = "posMapper")
	private PosMapper posMapper;

	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;



	@Override
	public EgovMap  getHasBill(Map<String, Object> params) {
		return membershipConvSaleMapper.getHasBill(params);
	}

	@Override
	public String SAL0095D_insert(Map<String, Object> params) {

		boolean   hasBill =false;
		EgovMap   sal0001dData=null;
		EgovMap   sal0090dData=null;
		EgovMap   sal0093dData=null;
		EgovMap   hasbillMap_PAY0024D=null;
		String 	   memNo ="";
		String  	   memBillNo ="";
		String 	   trType="";

		int o =-1;

		 //채번
		 String  srvMemId = String.valueOf(membershipConvSaleMapper.getSAL0095D_SEQ(params).get("seq"));
		 params.put("srvMemId", srvMemId);

		 //
		hasbillMap_PAY0024D =membershipConvSaleMapper.getHasBill(params);

		if( null != hasbillMap_PAY0024D ){
			 hasBill =true;
		}


		logger.debug("hasBill  =========== ==>");
		logger.debug("hasBil ,{}" +hasBill);
		logger.debug("hasBill  =========== ==>");


		//GET sal0093dData
		sal0093dData = membershipConvSaleMapper.getSAL0093D_Data(params);


		if(hasBill == false){

			 params.put("DOCNO","12");
			 memNo =  String.valueOf(membershipConvSaleMapper.getDocNo(params));

			 params.put("DOCNO","19");
			 memBillNo  = String.valueOf(membershipConvSaleMapper.getDocNo(params));

			 params.put("srvMemNo", memNo);
			 params.put("srvMemBillNo", memBillNo);

				logger.debug("=================srvMemNo  =========== ==>");
				logger.debug("srvMemNo==>" +memNo);
				logger.debug("srvMemBillNo==>" + memBillNo);
				logger.debug("hasBill  =================================>");


			 /////////////////////////////////////////////////////
			 //master
		     params.put("srvMemQuotId",  String.valueOf(sal0093dData.get("srvMemQuotId")));
		     params.put("srvMemSalesMemId",  String.valueOf(sal0093dData.get("srvSalesMemId")));
		     params.put("srvMemPacNetAmt",  String.valueOf(sal0093dData.get("srvMemPacNetAmt")));
			 o = membershipConvSaleMapper.SAL0095D_insert(params) ;
			/////////////////////////////////////////////////////


			logger.debug("=================SAL0095D_insert  =========== ==>");
			logger.debug("["+	o+"]");
			logger.debug("hasBill  =================================>");


		 }

		 sal0001dData = membershipConvSaleMapper.getSAL0001D_Data(params);
		 sal0090dData = membershipConvSaleMapper.getSAL0090D_Data(params);


		 if( null != sal0090dData ){

			 Map<String , Object> sal0088dDataMap = new HashMap<String , Object> ();
			 sal0088dDataMap.put ("srvConfigId" , sal0090dData.get("srvConfigId"));
			 sal0088dDataMap.put("srvMbrshId" , srvMemId);
			 sal0088dDataMap.put ("srvPrdStartDt",  "01/01/1900");
			 sal0088dDataMap.put ("srvPrdExprDt","01/01/1900");
			 sal0088dDataMap.put("srvPrdDur",params.get("srvFreq"));
			 sal0088dDataMap.put("srvPrdStusId",  "1");
			 sal0088dDataMap.put ("srvPrdRem", "");
			 sal0088dDataMap.put ("srvPrdCrtDt",  new Date());
			 sal0088dDataMap.put ("srvPrdCrtUserId",  params.get("userId"));
			 sal0088dDataMap.put("srvPrdUpdDt", new Date());


			logger.debug("sal0088dDataMap  ==>"+sal0088dDataMap.toString());
			int  s88dCnt  = membershipConvSaleMapper.SAL0088D_insert(sal0088dDataMap);
			logger.debug("s88dCnt  ==>"+s88dCnt);

			logger.debug("params  ==>"+params.toString());
			 int s90upDataCnt =membershipConvSaleMapper.update_SAL0090D_Stus(params);
			logger.debug("s90upDataCnt  ==>"+s90upDataCnt);

		 }


		 if(null !=sal0093dData ){

			 Map<String , Object> sal0093dDataMap = new HashMap<String , Object> ();
			 sal0093dDataMap.put ("srvMemId" , srvMemId);
			 sal0093dDataMap.put ("srvMemQuotID" , sal0093dData.get("srvMemQuotId"));

			 logger.debug("sal0093dDataMap  ==>"+sal0093dDataMap.toString());
			 int  s93upDataCnt =membershipConvSaleMapper.update_SAL0093D_Stus(sal0093dDataMap);
		     logger.debug("s93upDataCnt  ==>"+s93upDataCnt);
		 }

		 /////////////processBills///////////////////
		 this.processBills(hasBill , params  , sal0093dData);
		 /////////////processBills///////////////////


		 return memNo;

	}


	public  void  processBills(boolean hasBill , Map<String, Object> params  , Map<String, Object>    sal0093dData){

		 // int  TAXRATE   =0;
		 String  invoiceNum  ="";
         double totalCharges = 0.00;
         double totalTaxes = 0.00;
         double totalAmountDue = 0.00;



         String zeroRatYn = "Y";
 		 String eurCertYn = "Y";

         params.put("srvSalesOrderId", params.get("srvSalesOrdId"));

         int zeroRat =  membershipRentalQuotationMapper.selectGSTZeroRateLocation(params);
 		 int EURCert = membershipRentalQuotationMapper.selectGSTEURCertificate(params);

 		 //int package_TAXRATE  =6; -- without GST 6% edited by TPY 23/05/2018

		int package_TAXRATE = 0;
		int package_TAXCODE = 0;

		EgovMap getSstRelatedInfo = commonMapper.getSstRelatedInfo();

		if(getSstRelatedInfo != null){

	 		 package_TAXRATE  = Integer.parseInt(getSstRelatedInfo.get("taxRate").toString());
	 		 package_TAXCODE = Integer.parseInt(getSstRelatedInfo.get("codeId").toString());

		}else{
	 		 package_TAXRATE  =0;
	 		 package_TAXCODE = 32;
		}

 		 //int  filter_TAXRATE  =6; -- without GST 6% edited by TPY 23/05/2018
 		 int  filter_TAXRATE  =0;
 		 int  filter_TAXCODE =32;


 		 //package
 		 if(EURCert > 0 ) {
 			package_TAXRATE =0 ;
 			package_TAXCODE =28 ;

 		 }


 		 //FILTER
 		 if(zeroRat > 0 ){
  			filter_TAXRATE =0 ;
  			filter_TAXCODE =39 ;
  		 }

 		 if(EURCert > 0 ) {
 			filter_TAXRATE =0 ;
 			filter_TAXCODE =28 ;
 		 }




          logger.debug("zeroRat ==========================>>  " + zeroRatYn);
          logger.debug("EURCert ==========================>>  " + eurCertYn);




		  ////////	 get taxRate////////////////
		  // TAXRATE = membershipConvSaleMapper.getTaxRate(params);
		  ////////	 InvoiceNum  채번 ////////////////





		 if(hasBill ==false){

  		    ////////	 InvoiceNum  채번 ////////////////
  		    params.put("DOCNO","127");
 		    invoiceNum =  String.valueOf(membershipConvSaleMapper.getDocNo(params));
 			////////	 InvoiceNum  채번 ////////////////
	 	 }

	     DecimalFormat df = new DecimalFormat("#0.00");
		 double filterCharge = 0.00;
         double filterPaid = 0.00;

         double srvMemBsAmt   =  Double.parseDouble(CommonUtils.nvl(params.get("srvMemBsAmt")));
         double srvMemPacAmt =  Double.parseDouble(CommonUtils.nvl(params.get("srvMemPacAmt")));
         double srvMemPacNetAmt =  Double.parseDouble(CommonUtils.nvl(params.get("srvMemPacNetAmt")));

         if(srvMemBsAmt> 0 && (srvMemBsAmt >srvMemPacAmt)){
        	filterCharge  =  Double.parseDouble(df.format(srvMemBsAmt - srvMemPacAmt));
         }



		  //--------------------------------------------------------------------//
	     //                           PACKAGE            BILLING                           	       //
	     //--------------------------------------------------------------------//
         double packageCharge = 0;
         double packagePaid = 0;

         if (srvMemPacAmt > 0){
             packageCharge = srvMemPacAmt;
         }


         if (packageCharge > 0) {

        	 //bill
       	  	  Map<String , Object> pay0007dMap = new HashMap<String , Object> ();
       	      pay0007dMap.put("billTypeId","223");
		      pay0007dMap.put("billSoId",params.get("srvSalesOrdId"));
		      pay0007dMap.put("billMemId","0");
		      pay0007dMap.put("billAsId","0" );
		      pay0007dMap.put("billPayTypeId","386");


 		      if(hasBill){
 		    	  pay0007dMap.put("billNo", "0");
 	 		      pay0007dMap.put("billMemShipNo","0");

 		      }else{

 		    	  pay0007dMap.put("billNo", params.get("srvMemBillNo"));
 	 		      pay0007dMap.put("billMemShipNo",params.get("srvMemNo") );

		    		logger.debug("=================packageCharge  =========== ==>");
					logger.debug("srvMemNo==>" +params.get("srvMemNo"));
					logger.debug("srvMemBillNo==>" + params.get("srvMemBillNo"));
					logger.debug("hasBill  =================================>");

 		      }
		      pay0007dMap.put("billDt",new Date());
		      pay0007dMap.put("billAmt", packageCharge);
		      pay0007dMap.put("billRem","");
		      pay0007dMap.put("billIsPaid","0");
		      pay0007dMap.put("billIsComm","0");
		      pay0007dMap.put("updUserId",params.get("userId"));
		      pay0007dMap.put("updDt",new Date());
		      pay0007dMap.put("syncChk","0");
		      pay0007dMap.put("coursId","0");
		      pay0007dMap.put("stusId","1");

 		      logger.debug("package  pay0007dMap  ==>"+pay0007dMap.toString());
			  int  pay0007dMapCnt =membershipConvSaleMapper.PAY0007D_insert(pay0007dMap);
		     logger.debug("package pay0007dMapCnt  ==>"+pay0007dMapCnt);

//		     DecimalFormat df = new DecimalFormat("#0.00");

		     ////////////////////Invoice  sum////////////////////
		     //totalCharges       =totalCharges +   packageCharge  -   ( packageCharge - (packageCharge  *  100 / 106)); -- without GST 6% edited by TPY 23/05/2018
		     //totalTaxes          = totalTaxes   +   (packageCharge  -  (packageCharge  *  100 / 106)); -- without GST 6% edited by TPY 23/05/2018
		     if(getSstRelatedInfo != null){
		    	 totalCharges = srvMemPacNetAmt;
		    	 totalTaxes = Double.parseDouble(df.format(srvMemPacNetAmt * (package_TAXRATE / 100.00))) ;
    		 }else{
    			 totalCharges = totalCharges +   packageCharge  -   ( packageCharge - (packageCharge));
    			 totalTaxes = totalTaxes   +   (packageCharge  -  (packageCharge));
    		 }
		     totalAmountDue  = totalAmountDue + packageCharge ;
		     ////////////////////Invoice  sum////////////////////




		      //Ledger
		      Map<String , Object> pay0024dMap = new HashMap<String , Object> ();
		      if(hasBill){
 		    	  pay0024dMap.put("srvMemId",params.get("srvMemId"));
 	 		      pay0024dMap.put("srvMemDocNo",params.get("srvMemId") );
 	 		  }else{
 		    	  pay0024dMap.put("srvMemId",params.get("srvMemId"));
 	 		      pay0024dMap.put("srvMemDocNo",params.get("srvMemBillNo") );
 	 		  }

		      pay0024dMap.put("srvMemDocTypeId","386");
              pay0024dMap.put("srvMemDtTm",new Date());
              pay0024dMap.put("srvMemAmt",packageCharge);
              pay0024dMap.put("srvMemInstNo","0");
              pay0024dMap.put("srvMemBatchNo",invoiceNum);   //srvMemBatchNo
              pay0024dMap.put("srvMemUpdUserId",params.get("userId"));
              pay0024dMap.put("srvMemUpdDt","");
              pay0024dMap.put("srvMemOrdId",sal0093dData.get("srvSalesOrdId"));
              pay0024dMap.put("srvMemQotatId",sal0093dData.get("srvMemQuotId"));
              pay0024dMap.put("r01","");




              logger.debug("package  pay0024dMapCnt  ==>"+pay0024dMap.toString());
  			  int  pay0024dMapCnt =membershipConvSaleMapper.PAY0024D_insert(pay0024dMap);
  		      logger.debug("package pay0024dMapCnt  ==>"+pay0024dMapCnt);


  		    ////////////AccOrderBill////////////////////
 		    Map<String , Object> pay0016dMap = new HashMap<String , Object> ();
  		    pay0016dMap.put("accBillTaskId","0");
      	    pay0016dMap.put("accBillRefDt",new Date());
      	    pay0016dMap.put("accBillRefNo","1000");
      	    pay0016dMap.put("accBillOrdId",params.get("srvSalesOrdId"));
      	    pay0016dMap.put("accBillTypeId","1159");
      	    pay0016dMap.put("accBillModeId","1143");
      	    pay0016dMap.put("accBillSchdulId","0");
      	    pay0016dMap.put("accBillSchdulPriod","0");
      	    pay0016dMap.put("accBillAdjId","0");
      	    pay0016dMap.put("accBillSchdulAmt",packageCharge);
      	    pay0016dMap.put("accBillAdjAmt","0");
      	    pay0016dMap.put("accBillNetAmt",packageCharge);
      	    pay0016dMap.put("accBillStus","1");
      	    pay0016dMap.put("accBillRem",invoiceNum);
      	    pay0016dMap.put("accBillCrtDt",new Date());
      	    pay0016dMap.put("accBillCrtUserId",params.get("updator"));
      	    pay0016dMap.put("accBillGrpId","0");

      	    pay0016dMap.put("accBillTaxCodeId",package_TAXCODE);
      	    pay0016dMap.put("accBillTaxRate"   ,package_TAXRATE);

      	    if(getSstRelatedInfo != null){
      	    	pay0016dMap.put("accBillTxsAmt",Double.toString(totalTaxes));

      	    }else{
      	    	 if(package_TAXRATE ==6){
                 	  //pay0016dMap.put("accBillTxsAmt",Double.toString( packageCharge - (packageCharge  * 100 / 106))); -- without GST 6% edited by TPY 23/05/2018
         	    	pay0016dMap.put("accBillTxsAmt",Double.toString( packageCharge - (packageCharge)));
         	    }else{
         	    	pay0016dMap.put("accBillTxsAmt","0");
         	    }
      	    }

      	    pay0016dMap.put("accBillAcctCnvr","0");
      	    pay0016dMap.put("accBillCntrctId","0");

      	     logger.debug("filter  pay0016dMap  ==>"+pay0016dMap.toString());
     		 int  pay0016dMapCnt =membershipConvSaleMapper.PAY0016D_insert(pay0016dMap);
     	     logger.debug("filter pay0016dMapCnt  ==>"+pay0016dMapCnt);
  		    ////////////AccOrderBill////////////////////
         }





		 //--------------------------------------------------------------------//
	     //                           FILTER     FILTER BILLING                           	   	   //
	     //--------------------------------------------------------------------//

         if(filterCharge > 0){

        	  ///////////////bill//////////////////////////////
        	  Map<String , Object> pay0007dMap = new HashMap<String , Object> ();
        	  pay0007dMap.put("billTypeId","542");
 		      pay0007dMap.put("billSoId",params.get("srvSalesOrdId"));
 		      pay0007dMap.put("billMemId","0");
 		      pay0007dMap.put("billAsId","0" );
 		      pay0007dMap.put("billPayTypeId","541");

 		      if(hasBill){

 		    	  pay0007dMap.put("billNo", "0");
 	 		      pay0007dMap.put("billMemShipNo","0");
 		      }else{

 		    		logger.debug("=================filterCharge  =========== ==>");
 					logger.debug("srvMemNo==>" +params.get("srvMemNo"));
 					logger.debug("srvMemBillNo==>" + params.get("srvMemBillNo"));
 					logger.debug("hasBill  =================================>");


 		    	  pay0007dMap.put("billNo", params.get("srvMemBillNo"));
 	 		      pay0007dMap.put("billMemShipNo",params.get("srvMemNo") );
 		      }

 		      pay0007dMap.put("billDt",new Date());
 		      pay0007dMap.put("billAmt", filterCharge);
 		      pay0007dMap.put("billRem","");
 		      pay0007dMap.put("billIsPaid","0");
 		      pay0007dMap.put("billIsComm","0");
 		      pay0007dMap.put("updUserId",params.get("userId"));
 		      pay0007dMap.put("updDt",new Date());
 		      pay0007dMap.put("syncChk","0");
 		      pay0007dMap.put("coursId","0");
 		      pay0007dMap.put("stusId","1");

 		     logger.debug("pay0007dMap  ==>"+pay0007dMap.toString());
			 int  pay0007dMapCnt =membershipConvSaleMapper.PAY0007D_insert(pay0007dMap);
		     logger.debug("pay0007dMapCnt  ==>"+pay0007dMapCnt);
		     ///////////////bill//////////////////////////////







		     ////////////////////Invoice  sum////////////////////

		     /*if(TAXRATE  !=0){
		    	 totalCharges       = totalCharges + filterCharge ;
			     totalTaxes          = 0;
			     totalAmountDue  = totalAmountDue + filterCharge ;
			 }else{
		    	     totalCharges       = totalCharges +    ( (filterCharge) - (filterCharge  *  100 / 106));
				     totalTaxes          = totalTaxes    +     ((filterCharge)  - (filterCharge  *  100 / 106));
				     totalAmountDue  = totalAmountDue + filterCharge ;
			 }*/
		     ////////////////////Invoice  sum////////////////////


 		      //////////////Ledger////////////////////////
 		      Map<String , Object> pay0024dMap = new HashMap<String , Object> ();
 		      if(hasBill){
 		    	  pay0024dMap.put("srvMemId","0");
 	 		      pay0024dMap.put("srvMemDocNo","0");
 	 		  }else{
 		    	  pay0024dMap.put("srvMemId",params.get("srvMemId"));
 	 		      pay0024dMap.put("srvMemDocNo",params.get("srvMemBillNo") );
 	 		  }

 		      pay0024dMap.put("srvMemDocTypeId","542");
              pay0024dMap.put("srvMemDtTm",new Date());
              pay0024dMap.put("srvMemAmt",filterCharge);
              pay0024dMap.put("srvMemInstNo","0");
              pay0024dMap.put("srvMemBatchNo",invoiceNum);
              pay0024dMap.put("srvMemUpdUserId",params.get("userId"));
              pay0024dMap.put("srvMemUpdDt","");
              pay0024dMap.put("srvMemOrdId",sal0093dData.get("srvSalesOrdId"));
              pay0024dMap.put("srvMemQotatId",sal0093dData.get("srvMemQuotId"));
              pay0024dMap.put("r01","");

             logger.debug("filter  pay0024dMapCnt  ==>"+pay0024dMap.toString());
 			 int  pay0024dMapCnt =membershipConvSaleMapper.PAY0024D_insert(pay0024dMap);
 		     logger.debug("filter pay0024dMapCnt  ==>"+pay0024dMapCnt);
 		    //////////////Ledger////////////////////////


 		    ////////////AccOrderBill////////////////////
		    Map<String , Object> pay0016dMap = new HashMap<String , Object> ();
 		    pay0016dMap.put("accBillTaskId","0");
     	    pay0016dMap.put("accBillRefDt",new Date());
     	    pay0016dMap.put("accBillRefNo","1000");
     	    pay0016dMap.put("accBillOrdId",params.get("srvSalesOrdId"));
     	    pay0016dMap.put("accBillTypeId","1159");
     	    pay0016dMap.put("accBillModeId","1147");
     	    pay0016dMap.put("accBillSchdulId","0");
     	    pay0016dMap.put("accBillSchdulPriod","0");
     	    pay0016dMap.put("accBillAdjId","0");
     	    pay0016dMap.put("accBillSchdulAmt",filterCharge);
     	    pay0016dMap.put("accBillAdjAmt","0");
     	    pay0016dMap.put("accBillNetAmt",filterCharge);
     	    pay0016dMap.put("accBillStus","1");
     	    pay0016dMap.put("accBillRem",invoiceNum);
     	    pay0016dMap.put("accBillCrtDt",new Date());
     	    pay0016dMap.put("accBillCrtUserId",params.get("updator"));
     	    pay0016dMap.put("accBillGrpId","0");
     	    pay0016dMap.put("accBillTaxCodeId",filter_TAXCODE);
     	    pay0016dMap.put("accBillTaxRate",filter_TAXRATE);

     	    if(filter_TAXRATE ==6){
             	  //pay0016dMap.put("accBillTxsAmt",Double.toString( filterCharge -  (filterCharge  * 100 / 106))); -- without GST 6% edited by TPY 23/05/2018
     	    	pay0016dMap.put("accBillTxsAmt",Double.toString( filterCharge -  (filterCharge)));
     	    }else{
     	    	pay0016dMap.put("accBillTxsAmt","0");
     	    }

     	    pay0016dMap.put("accBillAcctCnvr","0");
     	    pay0016dMap.put("accBillCntrctId","0");

     	     logger.debug("filter  pay0016dMap  ==>"+pay0016dMap.toString());
    		 int  pay0016dMapCnt =membershipConvSaleMapper.PAY0016D_insert(pay0016dMap);
    	     logger.debug("filter pay0016dMapCnt  ==>"+pay0016dMapCnt);
 		     ////////////AccOrderBill////////////////////
         }



	     if(hasBill  ==false){
	  	     ////////////////Invoice////////////////////
	 	     this.processInvoice(invoiceNum , params , totalCharges ,totalTaxes,totalAmountDue ,package_TAXRATE ,  package_TAXCODE ,  filter_TAXRATE , filter_TAXCODE);
//	 	    		getSstRelatedInfo != null ? Integer.parseInt(getSstRelatedInfo.get("taxRate").toString()) : 0 );
	 	     ////////////////Invoice////////////////////
	 	 }
	}




	public  int  processInvoice( String invoiceNum ,
											 Map<String, Object> params   ,
											 double totalCharges,
											 double totalTaxes ,
											 double totalAmountDue,
											 int package_TAXRATE ,
											 int package_TAXCODE ,
											 int  filter_TAXRATE ,
											 int  filter_TAXCODE
											){




    		int a =0;

    		Map<String, Object>  pay31dMap = new HashMap<String, Object>();
    		logger.debug("params : " + params);
    		EgovMap newAddr = membershipConvSaleMapper.getNewAddr(params);

    		//채번
    		int taxInvcId	 = posMapper.getSeqPay0031D();

    	    pay31dMap.put("taxInvcId",taxInvcId);
     	    pay31dMap.put("taxInvcRefNo",invoiceNum);
     	    pay31dMap.put("taxInvcRefDt",new Date());
     	    pay31dMap.put("taxInvcSvcNo",params.get("srvMemQuotNo"));
     	    pay31dMap.put("taxInvcType","119");
     	    //pay31dMap.put("taxInvcCustName",params.get("srvMemQuotCustName"));
     	    //pay31dMap.put("taxInvcCntcPerson",params.get("srvMemQuotCntName"));
     	    pay31dMap.put("taxInvcCustName",newAddr.get("custName"));
     	    pay31dMap.put("taxInvcCntcPerson",newAddr.get("cntcName"));
     	    pay31dMap.put("taxInvcAddr1","");
     	    pay31dMap.put("taxInvcAddr2","");
     	    pay31dMap.put("taxInvcAddr3","");
     	    pay31dMap.put("taxInvcAddr4","");
     	    pay31dMap.put("taxInvcPostCode","");
     	    pay31dMap.put("taxInvcStateName","");
     	    pay31dMap.put("taxInvcCnty","");
     	    pay31dMap.put("taxInvcTaskId","");
     	    pay31dMap.put("taxInvcRem","");
     	    pay31dMap.put("taxInvcChrg", Double.toString(totalCharges));
     	    pay31dMap.put("taxInvcTxs",Double.toString(totalTaxes));
     	    pay31dMap.put("taxInvcAmtDue",Double.toString(totalAmountDue));
     	    pay31dMap.put("taxInvcCrtDt",new Date());
     	    pay31dMap.put("taxInvcCrtUserId",params.get("updator"));
     	    pay31dMap.put("areaId",newAddr.get("areaId"));
     	    pay31dMap.put("addrDtl",newAddr.get("addrDtl"));
     	    pay31dMap.put("street",newAddr.get("street"));


     	    logger.debug(" in Invoice master   ==>"+pay31dMap.toString());
    		 int masterCnt =membershipConvSaleMapper.PAY0031D_insert(pay31dMap);
    	     logger.debug("in Invoice master   Cnt  ==>"+masterCnt);


     	     Map<String, Object>  pay31dMap_update = new HashMap<String, Object>();
     	     pay31dMap_update.put("V_INVC_ITM_CHRG", totalCharges);
     	     pay31dMap_update.put("V_INVC_ITM_GST_TXS", totalTaxes);
     	     pay31dMap_update.put("V_INVC_ITM_AMT_DUE", totalAmountDue);

     	     pay31dMap_update.put("taxRate", filter_TAXRATE);
     	     pay31dMap_update.put("srvMemQuotId", params.get("srvMemQuotId"));
     	     pay31dMap_update.put("taxInvcId", taxInvcId);

     	     logger.debug(" in Invoice master   ==>"+pay31dMap.toString());
     		 int UPCnt =membershipConvSaleMapper.PAY0031D_INVC_ITM_UPDATE(pay31dMap_update);
     	     logger.debug("in Invoice master   Cnt  ==>"+masterCnt);


      	     //detail
     	     if(masterCnt >0){
         	         double srvMemBsAmt   =  Double.parseDouble(CommonUtils.nvl(params.get("srvMemBsAmt")));
         	         double srvMemPacAmt =  Double.parseDouble(CommonUtils.nvl(params.get("srvMemPacAmt")));

         	         logger.debug(" srvMemBsAmt==>"+srvMemBsAmt);
         	         logger.debug(" srvMemPacAmt==>"+srvMemPacAmt);

         	    	 if (srvMemPacAmt > 0 ) { //Package

         	    		 Map<String, Object>  pay32dMap = new HashMap<String, Object>();
         	    		 pay32dMap.put("taxInvcId", taxInvcId);
  		    		     pay32dMap.put("invcItmType","1266");
  		    		     pay32dMap.put("invcItmOrdNo",params.get("srvSalesOrdNo"));
  		    		     pay32dMap.put("invcItmPoNo",params.get("poNo")  );
  		    		     pay32dMap.put("invcItmCode", params.get("srvStockCode"));
  		    		     pay32dMap.put("invcItmDesc1", params.get("srvStockDesc"));    //
  		    		     pay32dMap.put("invcItmDesc2", "");
  		    		     pay32dMap.put("invcItmSerialNo", "");
  		    		     pay32dMap.put("invcItmQty", Integer.parseInt(CommonUtils.nvl(params.get("srvDur")))  / 12);
  		    		     pay32dMap.put("invcItmUnitPrc", "");
  		    		     pay32dMap.put("invcItmGstRate", package_TAXRATE);
  		    		     //pay32dMap.put("invcItmGstTxs", Double.toString( srvMemPacAmt - ( srvMemPacAmt  * 100 / 106))); - without GST 6% edited by TPY 23/05/2018
  		    		     //pay32dMap.put("invcItmChrg",   Double.toString(srvMemPacAmt  * 100 / 106 ) ); - without GST 6% edited by TPY 23/05/2018


	    				if(package_TAXRATE > 0){
	    					pay32dMap.put("invcItmGstTxs", Double.toString(totalTaxes));
			    		    pay32dMap.put("invcItmChrg",   Double.toString(totalCharges));
	    				}else{
	    					pay32dMap.put("invcItmGstTxs", Double.toString( srvMemPacAmt - ( srvMemPacAmt )));
			    		    pay32dMap.put("invcItmChrg",   Double.toString(srvMemPacAmt));
	    				}

  		    		     pay32dMap.put("invcItmAmtDue",Double.toString(srvMemPacAmt) );
  		    		     pay32dMap.put("invcItmAdd1", "");
  		    		     pay32dMap.put("invcItmAdd2","");
  		    		     pay32dMap.put("invcItmAdd3","" );
  		    		     pay32dMap.put("invcItmAdd4", "" );
  		    		     pay32dMap.put("invcItmPostCode","" );
  		    		     pay32dMap.put("invcItmAreaName", "");
  		    		     pay32dMap.put("invcItmStateName","" );
  		    		     pay32dMap.put("invcItmCnty", "");
  		    		     pay32dMap.put("invcItmInstallDt", "");
  		    		     pay32dMap.put("invcItmRetnDt", "");
  		    		     pay32dMap.put("invcItmBillRefNo","");
  		    		     pay32dMap.put("areaId",newAddr.get("areaId"));
  		    		     pay32dMap.put("addrDtl",newAddr.get("addrDtl"));
  		    		     pay32dMap.put("street",newAddr.get("street"));

      		       	     logger.debug(" in package Invoice detail   ==>"+pay32dMap.toString());
      		       		 int detailCnt =membershipConvSaleMapper.PAY0032D_insert(pay32dMap);
      		       	     logger.debug("in package Invoice detail    Cnt  ==>"+detailCnt);

                     }

         	    	if ((srvMemBsAmt-srvMemPacAmt) > 0 ) {   //Filter

        	    		 Map<String, Object>  selMap = new HashMap<String, Object>();

        	    		 selMap.put("taxInvcId", taxInvcId);
        	    		 selMap.put("srvSalesOrdNo", params.get("srvSalesOrdNo"));
        	    		 selMap.put("taxRate", filter_TAXRATE);
        	    		 selMap.put("srvMemQuotId", params.get("srvMemQuotId"));
        	    		 List<EgovMap>  list =	membershipConvSaleMapper.getFilterListData(selMap);

        	    		 if(null !=list ){
        	    			 if(list.size()>0){

        	    				 for(int i=0;i<list.size();i++){

        	    					 Map<String, Object>  get2dMap = list.get(i);
        	    					 Map<String, Object>  pay32dMap = new HashMap();

        	    					 if(Integer.parseInt(get2dMap.get("invcItmChrg").toString()) > 0) {
        	    						 pay32dMap.put("taxInvcId",    taxInvcId);
            	  		    		     pay32dMap.put("invcItmType",get2dMap.get("invcItmType"));
            	  		    		     pay32dMap.put("invcItmOrdNo",get2dMap.get("invcItmOrdNo"));
            	  		    		     pay32dMap.put("invcItmCode", get2dMap.get("invcItmCode"));
            	  		    		     pay32dMap.put("invcItmDesc1",get2dMap.get("invcItmDesc1"));
            	  		    		     pay32dMap.put("invcItmQty",   get2dMap.get("invcItmQty"));
            	  		    		     pay32dMap.put("invcItmGstRate",get2dMap.get("invcItmGstRate"));
            	  		    		     pay32dMap.put("invcItmGstTxs",get2dMap.get("invcItmGstTxs"));
            	  		    		     pay32dMap.put("invcItmChrg",  get2dMap.get("invcItmChrg"));
            	  		    		     pay32dMap.put("invcItmAmtDue",get2dMap.get("invcItmAmtDue") );


            	      		       	     logger.debug(" in Filter Invoice detail   ==>"+pay32dMap.toString());
            	      		       		 int detailCnt =membershipConvSaleMapper.PAY0032DFilter_insert(pay32dMap);
            	      		       	     logger.debug("in Filter Invoice detail    Cnt  ==>"+detailCnt);

        	    					 }
        	    				 }
        	    			 }
        	    		 }

                    }
     	     }


		return a;
	}

	@Override
	public boolean checkDuplicateRefNo (Map<String, Object> params){

		if (params.get("refNo") != null) {
    		EgovMap svmNoExist = getMembershipByRefNo(params);

    		if (svmNoExist != null)
    			return true;
    		else
    			return false;
		}
		return false;
	}


	public EgovMap getMembershipByRefNo(Map<String, Object> params) {
		return membershipConvSaleMapper.getMembershipByRefNo(params);
	}

	@Override
	public void updateEligibleEVoucher(Map<String, Object> params) {
		membershipConvSaleMapper.updateEligibleEVoucher(params);

	}
}
