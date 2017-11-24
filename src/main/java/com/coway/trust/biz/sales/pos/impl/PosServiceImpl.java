package com.coway.trust.biz.sales.pos.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.biz.sales.pos.vo.PosDetailVO;
import com.coway.trust.biz.sales.pos.vo.PosGridVO;
import com.coway.trust.biz.sales.pos.vo.PosMasterVO;
import com.coway.trust.biz.sales.pos.vo.PosMemberVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.math.BigDecimal;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("posService")
public class PosServiceImpl extends EgovAbstractServiceImpl implements PosService {

	private static final Logger LOGGER = LoggerFactory.getLogger(PosServiceImpl.class);
	
	@Resource(name = "posMapper")
	private PosMapper posMapper;
	

	@Override
	public List<EgovMap> selectPosModuleCodeList(Map<String, Object> params) throws Exception {
		
		return posMapper.selectPosModuleCodeList(params);
	}

	@Override
	public List<EgovMap> selectStatusCodeList(Map<String, Object> params) throws Exception {
		
		return posMapper.selectStatusCodeList(params);
	}

	@Override
	public List<EgovMap> selectPosJsonList(Map<String, Object> params) throws Exception {
		
		return posMapper.selectPosJsonList(params);
	}

	@Override
	public List<EgovMap> selectWhBrnchList() throws Exception {
		
		return posMapper.selectWhBrnchList();
	}

	@Override
	public EgovMap selectWarehouse(Map<String, Object> params) throws Exception {
		
		return posMapper.selectWarehouse(params);
	}

	@Override
	public List<EgovMap> selectPosTypeList(Map<String, Object> params) throws Exception {
		
		return posMapper.selectPosTypeList(params);
	}

/*	@Override
	public List<EgovMap> selectPIItmTypeList() throws Exception {
		
		return posMapper.selectPIItmTypeList();
	}*/

	/*@Override
	public List<EgovMap> selectPIItmList(Map<String, Object> params) throws Exception {
		
		return posMapper.selectPIItmList(params);
	}*/

	@Override
	public List<EgovMap> selectPosItmList(Map<String, Object> params) throws Exception {
		
		return posMapper.selectPosItmList(params);
	}

	@Override
	public List<EgovMap> chkStockList(Map<String, Object> params) throws Exception {
		
		List<EgovMap> retunList = null;
		
		retunList = posMapper.chkStockList(params);
		
		return retunList;
	}

	@Override
	public EgovMap getMemCode(Map<String, Object> params) throws Exception {
		
		return posMapper.getMemCode(params);
	}

	@Override
	public List<EgovMap> getReasonCodeList(Map<String, Object> params) throws Exception {
		
		return posMapper.getReasonCodeList(params);
	}

	@Override
	public List<EgovMap> getFilterSerialNum(Map<String, Object> params) throws Exception {
		
		return posMapper.getFilterSerialNum(params);
	}

	@Override
	public List<EgovMap> getConfirmFilterListAjax(Map<String, Object> params) throws Exception {
		
		return posMapper.getFilterSerialNum(params);
	}

	@Override
	@Transactional
	public Map<String, Object> insertPos(Map<String, Object> params) throws Exception {
		
		String docNoPsn = ""; //returnValue
		String docNoInvoice = "";
		LOGGER.info("############### get Params  ################");
		/*  ############### get Params  ################*/
		//Form
		Map<String, Object> posMap = (Map<String, Object>)params.get("form");
		//Grid1
		List<Object> basketGrid = (List<Object>)params.get("prch");
		//Grid2
		List<Object> serialGrid = (List<Object>)params.get("serial");
		//Grid3
		List<Object> memGird = (List<Object>)params.get("mem");
		
		LOGGER.info("############### get DOC Number & Sequence & full Name & Amounts  ################");
		/*############## get DOC Number & Sequence & full Name & Amounts ###########*/
		params.put("docNoId", SalesConstants.POS_DOC_NO_PSN_NO);
		docNoPsn = posMapper.getDocNo(params); ////////////////////////      PSN (144)
		params.put("docNoId", SalesConstants.POS_DOC_NO_INVOICE_NO);
		docNoInvoice = posMapper.getDocNo(params); ////////////////////   INVOICE (143)
		
		LOGGER.info("################################## docNoPsn : " + docNoPsn);
		LOGGER.info("################################## docNoInvoice : " + docNoInvoice);
		
		EgovMap nameMAp = null;
		nameMAp = posMapper.getUserFullName(posMap);
		
		BigDecimal tempTotalAmt = new BigDecimal("0");
		BigDecimal tempTotalTax = new BigDecimal("0");;
		BigDecimal tempTotalCharge = new BigDecimal("0");;
		
		BigDecimal calHundred = new BigDecimal("100");
		BigDecimal calGst = new BigDecimal(SalesConstants.POS_INV_ITM_GST_RATE);
		BigDecimal tempCal = calHundred.add(calGst);
		LOGGER.info("########################## tempCal : " + tempCal);
		for (int i = 0; i < basketGrid.size(); i++) {
			Map<String, Object> amtMap  = null;
			
			amtMap = (Map<String, Object>)basketGrid.get(i);
			BigDecimal tempQty = new BigDecimal(String.valueOf(amtMap.get("inputQty")));
			BigDecimal tempUnitPrc = new BigDecimal(String.valueOf(amtMap.get("amt")));
		
			BigDecimal tempCurAmt = tempUnitPrc.multiply(tempQty); // Prc * Qty
			BigDecimal tempCurCharge = tempCurAmt.multiply(calHundred).divide(tempCal, 2, BigDecimal.ROUND_HALF_UP); //Charges
			BigDecimal tempCurTax =  tempCurAmt.subtract(tempCurCharge); // Tax
					
			
			LOGGER.info("__________________________________________________________________________________________");
			LOGGER.info("_____________NO.["+ i +"] =  prc : " + tempUnitPrc + ",  qty : " + tempQty + " , total Amt : " + tempCurAmt + " , total Tax : " + tempCurTax + " , total Charges : " + tempCurCharge);
			LOGGER.info("__________________________________________________________________________________________");
			
			tempTotalAmt = tempTotalAmt.add(tempCurAmt);
			tempTotalTax = tempTotalTax.add(tempCurTax);
			tempTotalCharge = tempTotalCharge.add(tempCurCharge);
			
		}
		

		double rtnAmt = tempTotalAmt.doubleValue();
		double rtnTax = tempTotalTax.doubleValue();
		double rtnCharge = tempTotalCharge.doubleValue();
		
		
		LOGGER.info("_____________________________________________________________________________________");
		LOGGER.info("_______________________ TOTAL PRICE : " + rtnAmt + " , TOTAL TAX : " + rtnTax + " , TOTAL CHARGES : " + rtnCharge);
		LOGGER.info("_____________________________________________________________________________________");
		
		LOGGER.info("############### Parameter Setting , Insert and Update  ################");
		/* #### Parameter Setting , Insert and Update ######*/
		
		//1. ********************************************************************************************************* POS MASTER
		//Seq
		int posMasterSeq = posMapper.getSeqSal0057D(); //master Sequence
		
		//DRAccId , CRAccId Setting
		if(String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)){ //1352   //filter with payment
			
			posMap.put("drAccId", SalesConstants.POS_DRACC_ID_FILTER);  // 540  //122111
			posMap.put("crAccId", SalesConstants.POS_CRACC_ID_FILTER);  // 541  //414002
		}
		if(String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK)){ //1353   //itembank with payment
			
			posMap.put("drAccId", SalesConstants.POS_DRACC_ID_ITEMBANK); //540  //122111
			posMap.put("crAccId", SalesConstants.POS_CRACC_ID_ITEMBANK); //549  //601510
		}
		if(String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME) ||
				String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK_HQ)){  //1357 or 1358
	//TODO ASIS 기준으로는 하나의 아이템 타입만 구입할 수있었으니 지금은 여러가지 타입의 아이템을 구할수 있으므로 해당 로직 사용 불가함  //임의 수치 부여		
	//		EgovMap accCodeMap = null;
	//		accCodeMap = posMapper.getItemBankAccCodeByItemTypeID(posMap);
			posMap.put("drAccId", SalesConstants.POS_DRACC_ID_OTH);
			posMap.put("crAccId", SalesConstants.POS_CRACC_ID_OTH);
			
		}
	
		posMap.put("posMasterSeq", posMasterSeq); //posId = 0   -- 시퀀스 
		posMap.put("docNoPsn", docNoPsn); //posNo = 0  --문서채번
		posMap.put("posBillId", SalesConstants.POS_BILL_ID); //pos Bill Id // 0
		
		//TODO Other Income 만 사용?? Branch 없음 임시 번호 부여
		if(String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)){ // 1357 Other Income 
			
			posMap.put("othCheck", SalesConstants.POS_OTH_CHECK_PARAM);  //OTH Check
			posMap.put("posCustName", posMap.get("insPosCustName")); //posCustName = other Income만 사용함 .. 그러면 나머지는??
			params.put("memCode", params.get("userName"));
			EgovMap memCodeMap = null;
			memCodeMap = posMapper.selectMemberByMemberIDCode(params);
			
			//TODO IVYLIM is NULL
			if(memCodeMap != null){
				posMap.put("salesmanPopId", memCodeMap.get("memId"));
			}else{
				posMap.put("salesmanPopId", "0");
			}
			
			
		}else{
			posMap.put("posCustName", nameMAp.get("name")); //posCustName = other Income만 사용함 .. 그러면 나머지는??
		}
		posMap.put("posTotalAmt", rtnAmt);
		posMap.put("posCharge", rtnCharge); 
		posMap.put("posTaxes", rtnTax);
		posMap.put("posDiscount", 0);    //TODO 확인 필요
		//hidLocId  와 branch ID
		if(posMap.get("hidLocId") == null){
			posMap.put("hidLocId", "0");
		}
		posMap.put("posMtchId", 0);
		posMap.put("posCustomerId", SalesConstants.POS_CUST_ID);  //107205
		posMap.put("userId", params.get("userId"));
		posMap.put("userDeptId", params.get("userDeptId"));
		
		//Status Setting
		if((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType")))){   //2390   // POS-TYPE : POS SALES 
			
			if(String.valueOf(posMap.get("payResult")).equals("1")){ ////////////////////////////////////////////////////////////////////////////////////////// 1. WITH PAYMENT
				posMap.put("posStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); //STUS_ID  == Non Receive
			}else{  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 2. WITHOUT PAYMENT
				posMap.put("posStusId", SalesConstants.POS_SALES_STATUS_ACTIVE); //STUS_ID  == Active
			}
		}
		
		if((SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION).equals(String.valueOf(posMap.get("insPosModuleType"))) || ////2391  //POS TYPE :   DEDUCTION COMMISSION   - NO PAYMENT
				(SalesConstants.POS_SALES_MODULE_TYPE_OTH).equals(String.valueOf(posMap.get("insPosModuleType")))){  //2392 //POS TYPE : OTHER
			posMap.put("posStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); //STUS_ID  == Non Receive
		}
		
		//POS TYPE :   OTHER INCOME - NO PAYMENT
		/*if("OHTER INCOME 일때"){
			posMap.put("posStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); //STUS_ID  == Non Receive
		}*/
		
		posMap.put("userId", params.get("userId"));
		
		if(posMap.get("posReason") == null || String.valueOf(posMap.get("posReason")).equals("")){
			posMap.put("posReason", "0");
		}
		
		//Pos Master Insert
		LOGGER.info("############### 1. POS MASTER INSERT START  ################");
		LOGGER.info("############### 1. POS MASTER INSERT param : " + posMap.toString());
		posMapper.insertPosMaster(posMap);
		LOGGER.info("############### 1. POS MASTER INSERT END  ################");
      //2. ********************************************************************************************************* POS DETAIL
        
        // Grid to Map Params
		// 1). POST TYPE : POS_SALES  
		LOGGER.info("************************************* POSMAP`s Params : " + posMap.toString());
		LOGGER.info("************************************* POSMAP - type  : " + String.valueOf(posMap.get("insPosModuleType")));
		LOGGER.info("************************************* POSMAP - constans(pos_sales)  : " + SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES);
		LOGGER.info("************************************* POSMAP - constans(deduction_commission)  : " + SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION);
		
		if((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType"))) //2390
				 || (SalesConstants.POS_SALES_MODULE_TYPE_OTH).equals(String.valueOf(posMap.get("insPosModuleType")))){ //2392 
                for (int idx = 0; idx < basketGrid.size(); idx++) {  //basket Grid
                	Map<String, Object> itemMap = 	(Map<String, Object>)basketGrid.get(idx);
                	
                	int posDetailSeq = posMapper.getSeqSal0058D(); //detail Sequence
                	itemMap.put("posDetailSeq", posDetailSeq);
                	itemMap.put("posMasterSeq", posMasterSeq);
                	itemMap.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); //32
                	itemMap.put("posMemId", posMap.get("salesmanPopId")); //MEM_ID
                	itemMap.put("posRcvStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); //RCV_STUS_ID  96 == nonReceive
                	itemMap.put("userId", params.get("userId"));
                	LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT START  ################");
            		LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT param : " + itemMap.toString());
                	posMapper.insertPosDetail(itemMap);
                	LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT END  ################");
                	
                	//FILTER 유무 확인 
                	if((SalesConstants.POS_STOCK_TYPE_FILTER).equals(String.valueOf(itemMap.get("stkTypeId")))){  //62 Filter
                		
                		if(serialGrid != null){
                			for (int i = 0; i < serialGrid.size(); i++) {
                				Map<String, Object> serialMap = (Map<String, Object>)serialGrid.get(idx);
                				int serialSeq =  posMapper.getSeqSal0147M();
                				
                				serialMap.put("serialSeq", serialSeq);
                				serialMap.put("posMasterSeq", posMasterSeq);
                				serialMap.put("userId", params.get("userId"));
                				//TODO ITEM Status ID? 
                				//serialMap.put("posItmStusId", 1);  
                				
                				LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT START  ################");
                				LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT param : " + serialMap.toString());
                				posMapper.insertSerialNo(serialMap);
                				LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT END  ################");
                				
            				}
                		}
                	}//Filter insert End
        		}//Detail Insert End
		}
        // 2). POST TYPE : DEDUCTION COMMISSION  //2391
		if((SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION).equals(String.valueOf(posMap.get("insPosModuleType")))){ //2391
			for (int idx = 0; idx < basketGrid.size(); idx++) {  //basket Grid
				
				Map<String, Object> deducItemMap = 	(Map<String, Object>)basketGrid.get(idx); //item Map
				LOGGER.info("############### 2 - Member(Item) - [" + idx + "]  POS DETAIL(Member) MAP SETTING  ################");
				for (int i = 0; i < memGird.size(); i++) { 
					Map<String, Object> memMap = 	(Map<String, Object>)memGird.get(i); //item List
					int posDetailDuducSeq = posMapper.getSeqSal0058D(); //detail Sequence
					memMap.put("posDetailDuducSeq", posDetailDuducSeq);
					memMap.put("posMasterSeq", posMasterSeq);
					memMap.put("posDetailStkId", deducItemMap.get("stkId"));  //POS_ITM_STOCK_ID
					memMap.put("posDetailQty", deducItemMap.get("inputQty"));  //POS_ITM_QTY
					memMap.put("posDetailUnitPrc", deducItemMap.get("amt")); //Price
					memMap.put("posDetailTotal", deducItemMap.get("totalAmt")); //ToTal
					memMap.put("posDetailCharge", deducItemMap.get("subTotal")); //Charge 
					memMap.put("posDetailTaxs", deducItemMap.get("subChng")); //Tax 
					memMap.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); //32
					memMap.put("posRcvStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); //RCV_STUS_ID  96 == nonReceive
					memMap.put("userId", params.get("userId"));
					
					LOGGER.info("############### 2 - Member(Item ["+idx+"]) - MemLoop  [" + i + "]  POS DETAIL(Member) INSERT START  ################");
    				LOGGER.info("############### 2 - Member(Item ["+idx+"]) - MemLoop  [" + i + "]  POS DETAIL(Member) INSERT param : " + memMap.toString());
					posMapper.insertDeductionPosDetail(memMap);
					LOGGER.info("############### 2 - Member(Item ["+idx+"]) - MemLoop  [" + i + "]  POS DETAIL(Member) INSERT END  ################");
				}
				
			}
		}
        
        //3.  ********************************************************************************************************* ACC BILLING
      		Map<String, Object> accBillingMap = new HashMap<String, Object>();
      		int posBillSeq = posMapper.getSeqPay0007D();
      		accBillingMap.put("posBillSeq", posBillSeq);  // accbilling.BillID = 0;
      		accBillingMap.put("posBillTypeId", SalesConstants.POS_BILL_TYPE_ID); //accbilling.BillTypeID = 569;
      		accBillingMap.put("posBillSoId", 0); //   accbilling.BillSOID = 0;
      		accBillingMap.put("posBillMemId", 0); // accbilling.BillMemID = 0;
      		accBillingMap.put("posBillAsId", 0);  //accbilling.BillASID = 0;
      		accBillingMap.put("posBillPayTypeId", 0);  //accbilling.BillPayTypeID = 0;
      		accBillingMap.put("docNoPsn", docNoPsn); // accbilling.BillNo = ""; //update later //POS RefNo.
      		accBillingMap.put("posMemberShipNo", ""); //accbilling.BillMemberShipNo = "";
      		accBillingMap.put("posBillAmt", rtnAmt); // accbilling.BillAmt = Convert.ToDouble(totalcharges);
      		accBillingMap.put("posBillRem", posMap.get("posRemark")); //accbilling.BillRemark = this.txtRemark.Text.Trim();
      		accBillingMap.put("posBillIsPaid", 1); //accbilling.BillIsPaid = true;
      		accBillingMap.put("posBillIsComm", 0); // accbilling.BillIsComm = false;
      		accBillingMap.put("userId", params.get("userId"));
      		accBillingMap.put("posSyncChk", 1); //accbilling.SyncCheck = true;
      		accBillingMap.put("posCourseId", 0); //accbilling.CourseID = 0;
      		accBillingMap.put("posStatusId", 1);// accbilling.StatusID = 1;
      		LOGGER.info("############### 3. POS ACC BILLING INSERT START  ################");
    		LOGGER.info("############### 3. POS ACC BILLING INSERT param : " + accBillingMap.toString());
      		posMapper.insertPosBilling(accBillingMap);
      		LOGGER.info("############### 3. POS ACC BILLING INSERT END  ################");
      		
      	//4.  ********************************************************************************************************* POS MASTER UPDATE BILL_ID
      		Map<String, Object> posUpMap = new HashMap<String, Object>();
      		posUpMap.put("posBillSeq", posBillSeq);
      		posUpMap.put("posMasterSeq", posMasterSeq);
      		LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE START  ################");
    		LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE param : " + posUpMap.toString());
      		posMapper.updatePosMasterPosBillId(posUpMap);
      		LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE END  ################");
      		
      	//5.  ********************************************************************************************************* ACC ORDER BILL

    		//3. ACCORDERBILLING
    		Map<String, Object> accOrdBillingMap = new HashMap<String, Object>();
    		int accOrderBillSeq = posMapper.getSeqPay0016D();
    		
    		accOrdBillingMap.put("posOrderBillSeq", accOrderBillSeq); //accorderbill.AccBillID = 0;
    		accOrdBillingMap.put("posOrdBillTaskId", 0);  // accorderbill.AccBillTaskID = 0;
    		accOrdBillingMap.put("posOrdBillRefNo",  "1000"); //accorderbill.AccBillRefNo = "1000"; //update later //at db
    		accOrdBillingMap.put("posOrdBillOrdId", 0); //accorderbill.AccBillOrderID = 0;
    		accOrdBillingMap.put("posOrdBillOrdNo", ""); //accorderbill.AccBillOrderNo = "";
    		accOrdBillingMap.put("posOrdBillTypeId", SalesConstants.POS_ORD_BILL_TYPE_ID); //accorderbill.AccBillTypeID = 1159; //System Generate Bill
    		accOrdBillingMap.put("posOrdBillModeId", SalesConstants.POS_ORD_BILL_MODE_ID); //accorderbill.AccBillModeID = 1351; //SOI Bill (POS New Version)
    		accOrdBillingMap.put("posOrdBillScheduleId", 0); // accorderbill.AccBillScheduleID = 0;
    		accOrdBillingMap.put("posOrdBillSchedulePeriod", 0); //accorderbill.AccBillSchedulePeriod = 0;
    		accOrdBillingMap.put("posOrdBillAdjustmentId", 0); //accorderbill.AccBillAdjustmentID = 0;
    		accOrdBillingMap.put("posOrdBillScheduleAmt", rtnAmt); //accorderbill.AccBillScheduleAmount = decimal.Parse(totalcharges);
    		accOrdBillingMap.put("posOrdBillAdjustmentAmt", 0); //accorderbill.AccBillAdjustmentAmount = 0;
    		accOrdBillingMap.put("posOrdBillTaxesAmt", rtnTax); //accorderbill.AccBillTaxesAmount = Convert.ToDecimal(string.Format("{0:0.00}", decimal.Parse(totalcharges) - (System.Convert.ToDecimal(totalcharges) * 100 / 106)));
    		accOrdBillingMap.put("posOrdBillNetAmount", rtnAmt); // accorderbill.AccBillNetAmount = decimal.Parse(totalcharges);
    		accOrdBillingMap.put("posOrdBillStatus", 1); //accorderbill.AccBillStatus = 1;
    		accOrdBillingMap.put("posOrdBillRem", docNoInvoice); //accorderbill.AccBillRemark = ""; //Invoice No.
    		accOrdBillingMap.put("userId", params.get("userId"));
    		accOrdBillingMap.put("posOrdBillGroupId", 0); //accorderbill.AccBillGroupID = 0;
    		accOrdBillingMap.put("posOrdBillTaxCodeId", SalesConstants.POS_ORD_BILL_TAX_CODE_ID); //accorderbill.AccBillTaxCodeID = 32;
    		accOrdBillingMap.put("posOrdBillTaxRate", SalesConstants.POS_ORD_BILL_TAX_RATE); //accorderbill.AccBillTaxRate = 6;  
    		accOrdBillingMap.put("posOrdBillAcctCnvr", 0); //TODO ASIS 소스 없음
    		accOrdBillingMap.put("posOrdBillCntrctId", 0); //TODO ASIS 소스 없음
    		
    		LOGGER.info("############### 5. POS ACC ORDER BILL INSERT START  ################");
    		LOGGER.info("############### 5. POS ACC ORDER BILL INSERT param : " + accOrdBillingMap.toString());
    		posMapper.insertPosOrderBilling(accOrdBillingMap);
    		LOGGER.info("############### 5. POS ACC ORDER BILL INSERT END  ################");
    		
    	//6.  ********************************************************************************************************* ACC TAX INVOICE MISCELLANEOUS

    		Map<String, Object> accTaxInvoiceMiscellaneouMap = new HashMap<String, Object>();
    		int accTaxInvMiscSeq = posMapper.getSeqPay0031D();
    		
    		accTaxInvoiceMiscellaneouMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq); //InvMiscMaster.TaxInvoiceID = 0;
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvRefNo", docNoInvoice); //InvMiscMaster.TaxInvoiceRefNo = ""; //update later
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvSvcNo", docNoPsn); //InvMiscMaster.TaxInvoiceServiceNo = ""; //SOI No.
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvType", SalesConstants.POS_TAX_INVOICE_TYPE); //  InvMiscMaster.TaxInvoiceType = 142; //pos new version
    		
    		if(String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)){ // 1357 Other Income 
    			accTaxInvoiceMiscellaneouMap.put("posTaxInvCustName", posMap.get("insPosCustName")); //   InvMiscMaster.TaxInvoiceCustName = this.txtCustName.Text.Trim();
    			accTaxInvoiceMiscellaneouMap.put("posTaxInvCntcPerson", posMap.get("insPosCustName")); // InvMiscMaster.TaxInvoiceContactPerson = this.txtCustName.Text.Trim();
    			
    		}else{
    			accTaxInvoiceMiscellaneouMap.put("posTaxInvCustName", nameMAp.get("name")); //   InvMiscMaster.TaxInvoiceCustName = this.txtCustName.Text.Trim();
    			accTaxInvoiceMiscellaneouMap.put("posTaxInvCntcPerson", nameMAp.get("name")); // InvMiscMaster.TaxInvoiceContactPerson = this.txtCustName.Text.Trim();
    		}
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvTaskId", 0); //InvMiscMaster.TaxInvoiceTaskID = 0;
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvUserName", params.get("userName")); // InvMiscMaster.TaxInvoiceRemark = li.LoginID;
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvCharges", rtnCharge); //  InvMiscMaster.TaxInvoiceCharges = Convert.ToDecimal(string.Format("{0:0.00}", (decimal.Parse(totalcharges) * 100 / 106)));
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvTaxes", rtnTax); //InvMiscMaster.TaxInvoiceTaxes = Convert.ToDecimal(string.Format("{0:0.00}", decimal.Parse(totalcharges) - (decimal.Parse(totalcharges) * 100 / 106)));
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvTotalCharges", rtnAmt); //InvMiscMaster.TaxInvoiceAmountDue = decimal.Parse(totalcharges);
    		accTaxInvoiceMiscellaneouMap.put("userId", params.get("userId"));
    		
    		//TODO 추후 삭제
    		/* Magic Address 미구현 추후 삭제*/
    		/*accTaxInvoiceMiscellaneouMap.put("addr1", "");
    		accTaxInvoiceMiscellaneouMap.put("addr2", "");
    		accTaxInvoiceMiscellaneouMap.put("addr3", "");
    		accTaxInvoiceMiscellaneouMap.put("addr4", "");
    		accTaxInvoiceMiscellaneouMap.put("postCode", "");
    		accTaxInvoiceMiscellaneouMap.put("stateName", "");
    		accTaxInvoiceMiscellaneouMap.put("cnty", "");*/
    		
    		LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS INSERT START  ################");
    		LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS INSERT param : " + accTaxInvoiceMiscellaneouMap.toString());
    		posMapper.insertPosTaxInvcMisc(accTaxInvoiceMiscellaneouMap);
    		LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS END  ################");
    	//7.  ********************************************************************************************************* ACC TAX INVOICE MISCELLANEOUS_SUB 
    		int invItemTypeID = 0;
            if (String.valueOf(params.get("insPosType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)){ //filter
            	invItemTypeID = 1355;
            }
            if (String.valueOf(params.get("insPosType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK)){ //item bank
            	invItemTypeID = 1356;
            }
            if (String.valueOf(params.get("insPosType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)) { //other income
            	invItemTypeID = 1359;
            }
            if (String.valueOf(params.get("insPosType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK_HQ)){ //item bank-HQ
            	invItemTypeID = 1360;
            }
            for (int idx = 0; idx < basketGrid.size(); idx++) {
            	Map<String, Object> invDetailMap  = new HashMap<String, Object>();
            	invDetailMap = (Map<String, Object>)basketGrid.get(idx);
            	int invDetailSeq = posMapper.getSeqPay0032D();
            	
            	invDetailMap.put("invDetailSeq", invDetailSeq); //InvMiscD.InvocieItemID = 0;
            	invDetailMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq); //InvMiscD.TaxInvoiceID = 0; //update later
            	invDetailMap.put("invItemTypeID", invItemTypeID); //InvMiscD.InvoiceItemType = invItemTypeID;
            	invDetailMap.put("posTaxInvSubOrdNo", ""); //InvMiscD.InvoiceItemOrderNo = "";
            	invDetailMap.put("posTaxInvSubItmPoNo", ""); //InvMiscD.InvoiceItemPONo = "";
            	// InvMiscD.InvoiceItemCode = itm.GetDataKeyValue("ItemStkCode").ToString();
            	//InvMiscD.InvoiceItemDescription1 = itm.GetDataKeyValue("ItemStkDesc").ToString();
            	invDetailMap.put("posTaxInvSubDescSub", ""); //InvMiscD.InvoiceItemDescription2 = "";
            	invDetailMap.put("posTaxInvSubSerialNo", ""); //InvMiscD.InvoiceItemSerialNo = "";
            	//InvMiscD.InvoiceItemQuantity = int.Parse(itm.GetDataKeyValue("ItemQty").ToString());
            	//InvMiscD.InvoiceItemUnitPrice = decimal.Parse(itm.GetDataKeyValue("ItemUnitPrice").ToString());
            	invDetailMap.put("posTaxInvSubGSTRate", SalesConstants.POS_INV_ITM_GST_RATE);  //InvMiscD.InvoiceItemGSTRate = 6;
            	//InvMiscD.InvoiceItemGSTTaxes = Convert.ToDecimal(string.Format("{0:0.00}", decimal.Parse(itm["ItemTotalAmt"].Text) - (decimal.Parse(itm["ItemTotalAmt"].Text) * 100 / 106)));
            	//InvMiscD.InvoiceItemCharges = Convert.ToDecimal(string.Format("{0:0.00}", (decimal.Parse(itm["ItemTotalAmt"].Text) * 100 / 106)));
            	//InvMiscD.InvoiceItemAmountDue = decimal.Parse(itm.GetDataKeyValue("ItemTotalAmt").ToString());
            	
            	//TODO 추후 삭제
            	/*### Masic Address 미반영  ###*/
            	/*invDetailMap.put("posTaxInvSubAddr1", ""); //InvMiscD.InvoiceItemAdd1 = "";
            	invDetailMap.put("posTaxInvSubAddr2", ""); //InvMiscD.InvoiceItemAdd2 = "";
            	invDetailMap.put("posTaxInvSubAddr3", ""); //InvMiscD.InvoiceItemAdd3 = "";
            	invDetailMap.put("posTaxInvSubAddr4", ""); ////InvMiscD.InvoiceItemAdd3 = null;
            	invDetailMap.put("posTaxInvSubPostCode", ""); //InvMiscD.InvoiceItemPostCode = "";
            	invDetailMap.put("posTaxInvSubAreaName", ""); // areaName
            	invDetailMap.put("posTaxInvSubStateName", ""); //InvMiscD.InvoiceItemStateName = "";
            	invDetailMap.put("posTaxInvSubCntry", ""); //InvMiscD.InvoiceItemCountry = "";
*/            	
            	LOGGER.info("############### 7 - "+idx+" POS ACC TAX INVOICE MISCELLANEOUS_SUB  INSERT START  ################");
        		LOGGER.info("############### 7 - "+idx+" POS ACC TAX INVOICE MISCELLANEOUS_SUB  INSERT param : " + invDetailMap.toString());
            	posMapper.insertPosTaxInvcMiscSub(invDetailMap);
            	LOGGER.info("############### 7 - "+idx+" POS ACC TAX INVOICE MISCELLANEOUS END  ################");
			}
            
          //8.  ********************************************************************************************************* InvStkRecordCard --> Only For Filter/Spare Part Type
            
            if(String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)){  //insPosSystemType == 1352   POS_SALES_TYPE_FILTER  posMap
            	
            	for (int idx = 0; idx < basketGrid.size(); idx++) {
                 	
            		Map<String, Object> recordlMap  = (Map<String, Object>)basketGrid.get(idx);
            		
            		//LOG0014D
            		int stkRecordSeq =  posMapper.getSeqLog0014D();
            		
            		recordlMap.put("stkRecordSeq", stkRecordSeq); //invStkCard.SRCardID = 0;
            		//TODO brnchId 를 넣을건지 , locId 를 넣을 건지 선택해야함 (현재는 BranchId)
            	    // Location ID? Branch ID? == Location Id (now)
            		//invStkCard.StockID = int.Parse(itm.GetDataKeyValue("ItemStkID").ToString());
            		//invStkCard.EntryDate = Convert.ToDateTime(this.dpSalesDate.SelectedDate);
            		recordlMap.put("invStkRecordTypeId", SalesConstants.POS_INV_STK_TYPE_ID); //invStkCard.TypeID = 571;
            		recordlMap.put("invStkRecordRefNo", docNoPsn); //invStkCard.RefNo = ""; //update later //POS No. 144Doc 
            		recordlMap.put("invStkRecordOrdId", 0); //invStkCard.SalesOrderId = 0;
            		recordlMap.put("invStkRecordItmNo", idx); //   invStkCard.ItemNo = count;
            		recordlMap.put("invStkRecordSourceId", SalesConstants.POS_INV_SOURCE_ID); //   invStkCard.SourceID = 477;
            		recordlMap.put("invStkRecordProjectId", 0); //invStkCard.ProjectID = 0;
            		recordlMap.put("invStkRecordBatchNo", 0); //invStkCard.BatchNo = 0;
            		//invStkCard.Qty = -int.Parse(itm.GetDataKeyValue("ItemQty").ToString());
            		recordlMap.put("invStkRecordCurrId", SalesConstants.POS_INV_CURR_ID); //invStkCard.CurrID = 479;
            		recordlMap.put("invStkRecordCurrRate", SalesConstants.POS_INV_CURR_RATE); //invStkCard.CurrRate = 1;
            		recordlMap.put("invStkRecordCost", 0); //invStkCard.Cost = 0;
            		recordlMap.put("invStkRecordPrice", 0); //invStkCard.Price = 0;
            		recordlMap.put("invStkRecordRem", posMap.get("posRemark")); //invStkCard.Remark = !string.IsNullOrEmpty(this.txtRemark.Text.Trim()) ? this.txtRemark.Text.Trim() : "";
            		recordlMap.put("invStkRecordSerialNo", ""); //invStkCard.SerialNo = "";
            		recordlMap.put("invStkRecordInstallNo", ""); //invStkCard.InstallNo = "";
            		//invStkCard.CostDate = DateTime.Now;
            		recordlMap.put("invStkRecordAppTypeId", 0); //invStkCard.AppTypeID = 0;
            		recordlMap.put("invStkRecordStkGrade", ""); //invStkCard.StkGrade = string.Empty;
            		recordlMap.put("invStkRecordInstallFail", 0); //invStkCard.InstallFail = false;
            		recordlMap.put("invStkRecordIsSynch", 0); //invStkCard.IsSynch = false;
            		recordlMap.put("invStkRecordEntryMthId", 0);  //ENTRY_MTH_ID
            		
            		LOGGER.info("############### 8. POS InvStkRecordCard INSERT START  ################");
            		LOGGER.info("############### 8. POS InvStkRecordCard INSERT param : " + recordlMap.toString());
            		posMapper.insertStkRecord(recordlMap);
            		LOGGER.info("############### 8. POS InvStkRecordCard END  ################");
                 	
            	 }
         	}// end 8
        
           //  *********************   PAYMENT LOGIC START *********************   //
            // When   'POS SALES' Case 
/*            if((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType")))){  //2390 -- POS SALES
            	
            	int trxNo = int.Parse(this.GetDOCNumberOnlyNumber(23)); //TRX No.
                this.UpdateDOCNumber(23);
                orNo = this.GetDOCNumber(3); //WOR No.
                this.UpdateDOCNumber(3);

                #region Data.PayTrx
                entity.PayTrxes.Add(paytrx);
                entity.SaveChanges();
                #endregion

                #region Data.PayM || Data.PayD || Data.AccGLRoute
                payM.ORNo = orNo;
                payM.BillID = accbilling.BillID;
                payM.TrxID = paytrx.TrxID;
                payM.AccBillID = accorderbill.AccBillID;
                payM.TaxInvoiceRefNo = InvoiceNum;
                payM.TaxInvoiceRefDate = InvMiscMaster.TaxInvoiceRefDate;

                entity.PayMs.Add(payM);
                entity.SaveChanges();
            	
            	//9.  ********************************************************************************************************* PAY X
            	Map<String, Object> payXMap = new HashMap<String, Object>();
            	
            	//PayTrx Params Setting
            	 paytrx.TrxDate = this.dpSalesDate.SelectedDate;
                paytrx.TrxType = 577;
                paytrx.TrxAmount = Convert.ToDouble(totalpay);
                paytrx.TrxMatchNo = "";
            	
            	//Doc No (23)
            	//Doc No (3)
            	
            	//SAVE
            	
            	
            	//10.  ********************************************************************************************************* PAY D (LOOP)
            	
            	//PAYMENT GRID 가져옴
            	
            	Data.PayD payD = new Data.PayD();
                payD.PayItemID = 0;
                payD.PayID = 0; //update later
                payD.PayItemModeID = int.Parse(itm["PaymodeID"].Text);
                payD.PayItemRefNo = itm["RefNo"].Text.ToUpper().Replace("&NBSP;", "");
                payD.PayItemCCNo = string.IsNullOrEmpty(itm["CCNo"].Text.Trim()) ? null : EncryptionProvider.Encrypt(itm["CCNo"].Text);
                payD.PayItemIssuedBankID = int.Parse(itm["IssueBankID"].Text);
                payD.PayItemAmt = double.Parse(itm["PayAmount"].Text);
                payD.PayItemIsOnline = itm["CRCMode"].Text == "ONLINE" ? true : false;
                payD.PayItemBankAccID = int.Parse(itm["BankAccID"].Text);
                if (itm["RefDate"].Text == "&nbsp;" || string.IsNullOrEmpty(itm["RefDate"].Text))
                {
                   
                    payD.PayItemRefDate = defaultDate;
                }
                else
                {
                    
                    string strrefdate = itm["RefDate"].Text;
                    
                    DateTime refdate = DateTime.ParseExact(strrefdate, "dd-MM-yyyy", CultureInfo.InvariantCulture);
                    // DateTime refdate = DateTime.ParseExact(strrefdate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    
                    payD.PayItemRefDate = refdate;
                    
                }
               
                payD.PayItemAppvNo = itm["ApproveNo"].Text.Replace("&nbsp;", "");
                payD.PayitemRemark = itm["Remark"].Text.Replace("&nbsp;", "");
                payD.PayItemCCTypeID = int.Parse(itm["CRCTypeID"].Text);
                payD.PayItemStatusID = 1;
                payD.PayItemOriCCNo = itm["CCNo"].Text.Replace("&nbsp;", "");
                payD.IsFundTransfer = false;
                payD.SkipRecon = false;
                
                payDList.Add(payD);
                }
                return payDList;
            	
            	//그리드 사이즈 만큼의 리스트 생성
            	
            	
            	//LOOP SIZE > PAYD`S SIZE (위에서 생성된 리스트만큼 INSERT)
            	
            	pd.PayID = payM.PayID;
                entity.PayDs.Add(pd);
                entity.SaveChanges();
            	
            	
            	// SUSPENDACCID 와  SETTLEACCID 세팅
            	 int SuspendAccID = 0;
                 int SettleAccID = 0;
            	

                if (pd.PayItemModeID == 105) //Cash
                {
                    SuspendAccID = 531;
                    SettleAccID = (int)pd.PayItemBankAccID;
                }
                else if (pd.PayItemModeID == 107) //Credit Card
                {
                    SuspendAccID = (int)pd.PayItemBankAccID;

                    switch ((int)pd.PayItemBankAccID)
                    {
                        case 99:
                            SettleAccID = 83;
                            break;
                        case 100:
                            SettleAccID = 90;
                            break;
                        case 101:
                            SettleAccID = 84;
                            break;
                        case 103:
                            SettleAccID = 83;
                            break;
                        case 104:
                            SettleAccID = 86;
                            break;
                        case 105:
                            SettleAccID = 85;
                            break;
                        case 106:
                            SettleAccID = 84;
                            break;
                        case 107:
                            SettleAccID = 88;
                            break;
                        case 110:
                            SettleAccID = 89;
                            break;
                        case 497:
                            SettleAccID = 497;
                            break;
                        default:
                            break;
                    }
                }
                else if (pd.PayItemModeID == 108) //Online
                {
                    SuspendAccID = 533;
                    SettleAccID = (int)pd.PayItemBankAccID;
                }
            	// SETTING AND
            	
            	
            	//11.  ********************************************************************************************************* ACCGLROUTE (LOOP)
            	 Data.AccGLRoute glroute = new Data.AccGLRoute();
                 glroute.ID = 0;
                 glroute.GLPostingDate = DateTime.Now;
                 glroute.GLFiscalDate = DateTime.Parse(string.Format("{0:dd/MM/yyyy}", "1900-01-01"));
                 glroute.GLBatchNo = paytrx.TrxID.ToString(); 
                 glroute.GLBatchTypeDesc = "";
                 glroute.GLBatchTotal = (double)payM.TotalAmt;
                 glroute.GLReceiptNo = orNo; 
                 glroute.GLReceiptTypeID = 577;
                 glroute.GLReceiptBranchID = (int)payM.BranchID;
                 glroute.GLReceiptSettleAccID = SettleAccID;
                 glroute.GLReceiptAccountID = SuspendAccID;
                 glroute.GLReceiptItemID = pd.PayItemID; 
                 glroute.GLReceiptItemModeID = (int)pd.PayItemModeID;
                 glroute.GLReverseReceiptItemID = 0;
                 glroute.GLReceiptItemAmount = (double)pd.PayItemAmt;
                 glroute.GLReceiptItemCharges = 0;
                 glroute.GLReceiptItemRCLStatus = "N";
                 glroute.GLConversionStatus = "Y";
                 entity.AccGLRoutes.Add(glroute);
                 entity.SaveChanges();
            	
            	//SAVE
            	
            	
            }*/
            
            
           //  *********************   PAYMENT LOGIC END *********************   //
            
            
            
          	//10.  ********************************************************************************************************* BOOKING 

        
    		Map<String, Object>  logPram = new HashMap<String, Object>();
    		
    		logPram.put("psno", docNoPsn);
    		logPram.put("retype", "POS");  
    		logPram.put("pType", "PS01");   // PS02 - cancel
    		logPram.put("pPrgNm", "PSR");  
    		logPram.put("userId", Integer.parseInt(String.valueOf(params.get("userId"))));   
    		
    		LOGGER.info("############### 10. POS BOOKING  START  ################");
    		LOGGER.info("#########  call Procedure Params : " + logPram.toString());
    		posMapper.posBookingCallSP_LOGISTIC_REQUEST(logPram);
    		LOGGER.debug("############ Procedure Result  ");
    		LOGGER.info("############### 10. POS BOOKING  END  ################");
            
            
            LOGGER.info("################################## return value(docNoPsn): "  + docNoPsn);
            
            
            //retrun Map
            Map<String, Object> rtnMap = new HashMap<String, Object>();
            rtnMap.put("reqDocNo", docNoPsn);
            
            LOGGER.info("##################### POS Request Success!!! ######################################");
            LOGGER.info("##################### POS Request Success!!! ######################################");
            LOGGER.info("##################### POS Request Success!!! ######################################");
		return rtnMap;
	}

	@Override
	public List<EgovMap> getUploadMemList(Map<String, Object> params) throws Exception {
		
		return posMapper.getUploadMemList(params);
	}

	@Override
	public EgovMap posReversalDetail(Map<String, Object> params) throws Exception {
		
		return posMapper.posReversalDetail(params);
	}

	@Override
	public List<EgovMap> getPosDetailList(Map<String, Object> params) throws Exception {
		
		return posMapper.getPosDetailList(params);
	}

	@Override
	public EgovMap chkReveralBeforeReversal(Map<String, Object> params) throws Exception {
		
		return posMapper.chkReveralBeforeReversal(params);
	}

	@Override
	@Transactional
	public EgovMap insertPosReversal(Map<String, Object> params) throws Exception {
		
			/*########### get Params ###############*/
    		double rtnAmt = 0;
    		double rtnCharge = 0;
    		double rtnTax = 0;
    		double rtnDisc = 0;
    		double tempBillAmt = 0;
    		
    		String posRefNo = "";   // SOI no. (144)
			String voidNo = "";    // Void no.  (112)
			String rptNo = "";   // RD no. (18) 
			String cnno = "";   //CN-New (134)
			
			int posMasterSeq = 0;
			int posDetailDuducSeq = 0;
			int posBillSeq = 0;
			int memoAdjSeq = 0;
			int noteSeq = 0;
			int miscSubSeq = 0;
			int noteSubSeq = 0;
			int ordVoidSeq = 0;
			int ordVoidSubSeq = 0;
			int stkSeq = 0;
			
			
			/*################################### Get Doc No #############################*/
					
			params.put("docNoId", SalesConstants.POS_DOC_NO_PSN_NO); //(144)
			posRefNo = posMapper.getDocNo(params);
			
			params.put("docNoId", SalesConstants.POS_DOC_NO_VOID_NO); //(112)
			voidNo = posMapper.getDocNo(params);
			
			params.put("docNoId", SalesConstants.POS_DOC_NO_RD_NO); //(18)
			rptNo = posMapper.getDocNo(params);
			
			params.put("docNoId", SalesConstants.POS_DOC_NO_CN_NEW_NO); //(134)
			cnno = posMapper.getDocNo(params);
			
			//1. ********************************************************************************************************* POS MASTER
			
			//Price and Qty Setting
			
			rtnAmt = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotAmt")));
			rtnCharge = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotChrg")));
			rtnTax = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotTxs"))); 
			rtnDisc = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotDscnt")));  
			
			//Seq
			posMasterSeq = posMapper.getSeqSal0057D(); //master Sequence
			Map<String, Object> posMap = new HashMap<String, Object>();
			
			posMap.put("posMasterSeq", posMasterSeq); //posId = 0   -- 시퀀스 
			posMap.put("docNoPsn", posRefNo); //posNo = 0  --문서채번
			posMap.put("posBillId", SalesConstants.POS_BILL_ID); //pos Bill Id // 0
			
			posMap.put("posCustName", params.get("rePosCustName")); //posCustName = other Income만 사용함 .. 그러면 나머지는??
			posMap.put("insPosModuleType", params.get("rePosModuleTypeId"));
			posMap.put("insPosSystemType", SalesConstants.POS_SALES_TYPE_REVERSAL); // 1361
			posMap.put("posTotalAmt", rtnAmt);
			posMap.put("posCharge", rtnCharge); 
			posMap.put("posTaxes", rtnTax);
			posMap.put("posDiscount", rtnDisc); 
			posMap.put("hidLocId", params.get("rePosWhId"));
			posMap.put("posRemark", params.get("reversalRem"));
			posMap.put("posMtchId", params.get("rePosId")); //pos Old ID
			posMap.put("salesmanPopId", params.get("rePosMemId"));
			posMap.put("posCustomerId", SalesConstants.POS_CUST_ID);  //107205
			posMap.put("userId", params.get("userId"));
			posMap.put("userDeptId", params.get("userDeptId"));
			posMap.put("crAccId", params.get("rePosCrAccId"));
			posMap.put("drAccId", params.get("rePosDrAccId"));
			posMap.put("posReason", params.get("rePosResnId"));
			posMap.put("cmbWhBrnchIdPop", params.get("rePosBrnchId")); //Brnch
			posMap.put("recvDate", params.get("rePosRcvDt"));
			posMap.put("posStusId",params.get("rePosStusId"));
			
			if(params.get("rePosModuleTypeId").equals(SalesConstants.POS_SALES_MODULE_TYPE_OTH)){
				posMap.put("chkOth", SalesConstants.POS_OTH_CHECK_PARAM);
				posMap.put("getAreaId", params.get("getAreaId"));
				posMap.put("addrDtl", params.get("addrDtl"));
				posMap.put("streetDtl", params.get("streetDtl"));
			}
			
			//Pos Master Insert
			LOGGER.info("############### 1. POS MASTER REVERSAL INSERT START  ################");
			LOGGER.info("############### 1. POS MASTER REVERSAL INSERT param : " + posMap.toString());
			posMapper.insertPosReversalMaster(posMap);
			LOGGER.info("############### 1. POS MASTER REVERSAL INSERT END  ################");
			
			//2. ********************************************************************************************************* POS DETAIL
			
			List<EgovMap> oldDetailList = null;
			oldDetailList = posMapper.getOldDetailList(params); //Old Pos Id == param
			//old pos id 로 디테일 리스트 불러옴
			if(oldDetailList != null && oldDetailList.size() > 0){ //for (old List) 
				
				for (int idx = 0; idx < oldDetailList.size(); idx++) {
					
					EgovMap revDetailMap = null;
					double tempTot = 0 ;
					double tempChrg = 0;
					double tempTxs = 0;
					int tempQty = 0;
					
					revDetailMap = oldDetailList.get(idx); // map 생성   --parameter // params setting >>  old List.get(i)    >> Map 에 put
					
					posDetailDuducSeq = posMapper.getSeqSal0058D(); //detail Sequence
					
					//detail 생성 ....
					revDetailMap.put("posDetailDuducSeq", posDetailDuducSeq); //seq
					revDetailMap.put("posMasterSeq", posMasterSeq);  //master Seq
					
					
					tempQty = Integer.parseInt(String.valueOf(revDetailMap.get("posItmQty")));
					tempQty = -1 * tempQty;
					revDetailMap.put("posDetailQty", tempQty);
					
					tempTot = Double.parseDouble(String.valueOf(revDetailMap.get("posItmTot")));
					tempTot = -1 * tempTot;
					revDetailMap.put("posDetailTotal", tempTot);
					
					tempChrg = Double.parseDouble(String.valueOf(revDetailMap.get("posItmChrg")));
					tempChrg = -1 * tempChrg;
					revDetailMap.put("posDetailCharge", tempChrg);
					
					tempTxs = Double.parseDouble(String.valueOf(revDetailMap.get("posItmTxs")));
					tempTxs = -1 * tempTxs;
					revDetailMap.put("posDetailTaxs", tempTxs);
					
					revDetailMap.put("posRcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE); //RCV_STUS_ID  == 96 (Non Receive)
					revDetailMap.put("userId", params.get("userId"));
					
					if(revDetailMap != null){
						LOGGER.info("############### 2 - ["+idx+"]  POS DETAIL REVERSAL INSERT START  ################");
						LOGGER.info("############### 2 - ["+idx+"]  POS DETAIL REVERSAL INSERT param : " + revDetailMap.toString());
						posMapper.insertPosReversalDetail(revDetailMap);
						LOGGER.info("############### 2 - ["+idx+"]  POS DETAIL REVERSAL INSERT END  ################");
					}
				}
				
			}
			
			EgovMap billInfoMap = null;
			billInfoMap = posMapper.getBillInfo(params);

			if(billInfoMap != null){
				   //3.  ********************************************************************************************************* ACC BILLING
        			tempBillAmt = Double.parseDouble(String.valueOf(billInfoMap.get("billAmt")));
        			tempBillAmt = -1 * tempBillAmt;
        			
        			posBillSeq = posMapper.getSeqPay0007D(); //seq
        			
        			billInfoMap.put("billAmt", tempBillAmt);
        			billInfoMap.put("posBillSeq", posBillSeq);
        			billInfoMap.put("docNoPsn", posRefNo); //posNo = 0  --문서채번
        			billInfoMap.put("userId", params.get("userId"));
        		
        			//insert
        			LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE START  ################");
        			LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE PARAM : " + billInfoMap.toString());
        			posMapper.insertPosReversalBilling(billInfoMap);
        			LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE END  ################");
        			//4.  ********************************************************************************************************* POS MASTER UPDATE BILL_ID
        			//posMaster 의 만들어진 시퀀스 번호가 조건일때   posBillId == accBilling 의 시퀀스 ()
        			Map<String, Object> posUpMap = new HashMap<String, Object>();
              		posUpMap.put("posBillSeq", posBillSeq);
              		posUpMap.put("posMasterSeq", posMasterSeq);
              		LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER START  ################");
            		LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER param : " + posUpMap.toString());
              		posMapper.updatePosMasterPosBillId(posUpMap);
              		LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER END  ################");
      		
			}
      	    
      		EgovMap taxInvMap = null;
      		EgovMap getAccMap = null;
      		taxInvMap = posMapper.getTaxInvoiceMisc(params);  //PAY0031D   miscM  // MISC(M)  MASTER
      		
      		if(taxInvMap != null){
      		   //5.  ********************************************************************************************************* ACC ORDER BILL
      			Map<String, Object> accInfoMap = new HashMap<String, Object>();
      			accInfoMap.put("taxInvcRefNo", taxInvMap.get("taxInvcRefNo"));
      			
      			getAccMap = 	posMapper.getAccOrderBill(accInfoMap); //인서트 칠 인포메이션 ACC_BILL_ID //
      			
      			if(getAccMap != null){
      			
          			Map<String, Object> accOrdUpMap = new HashMap<String, Object>();
          			
          			accOrdUpMap.put("accBillId", getAccMap.get("accBillId"));
          			accOrdUpMap.put("accBillStatus", SalesConstants.POS_ACC_BILL_STATUS);  //74
          			accOrdUpMap.put("accBillTaskId", SalesConstants.POS_ACC_BILL_TASK_ID);
          			
          			LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE START  ################");
          			LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE PARAM  : " + accOrdUpMap.toString());
          			posMapper.updateAccOrderBillingWithPosReversal(accOrdUpMap);
          			LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE END  ################");
      			}
      		   //6.  ********************************************************************************************************* INVOICE ADJUSTMENT (MASTER)
      			
      			Map<String, Object> adjMap =  new HashMap<String, Object>();
      			
      			memoAdjSeq = posMapper.getSeqPay0011D();
      			
      			adjMap.put("memoAdjSeq", memoAdjSeq);  
      			adjMap.put("memoAdjRefNo", cnno); // 134  //InvAdjM.MemoAdjustRefNo = ""; //update later
      			adjMap.put("memoAdjReptNo", rptNo); //18 //InvAdjM.MemoAdjustReportNo = ""; //update later
      			adjMap.put("memoAdjTypeId", SalesConstants.POS_INV_ADJM_MEMO_TYPE_ID);   //InvAdjM.MemoAdjustTypeID = 1293; //Type - CN
      			adjMap.put("memoAdjInvNo", taxInvMap.get("taxInvcRefNo")); //TAX_INVC_REF_NO InvAdjM.MemoAdjustInvoiceNo = ""; //update later-InvoiceNo BR68..
      			adjMap.put("memoAdjInvTypeId", SalesConstants.POS_INV_ADJM_MEMO_INVOICE_TYPE_ID); //InvAdjM.MemoAdjustInvoiceTypeID = 128; // Invoice-Miscellaneous
      			adjMap.put("memoAdjStatusId", SalesConstants.POS_INV_ADJM_MEMO_STATUS_ID); //InvAdjM.MemoAdjustStatusID = 4;
      			adjMap.put("memoAdjReasonId", SalesConstants.POS_INV_ADJM_MEMO_RESN_ID); //InvAdjM.MemoAdjustReasonID = 2038; // Invoice Reversal
      			adjMap.put("memoAdjRem", params.get("reversalRem")); //rem   InvAdjM.MemoAdjustRemark = this.txtReversalRemark.Text.Trim();
      			adjMap.put("memoAdjTotTxs", taxInvMap.get("taxInvcTxs"));	 //TAX_INVC_TXS InvAdjM.MemoAdjustTaxesAmount = miscM.TaxInvoiceTaxes;
      			adjMap.put("memoAdjTotAmt", taxInvMap.get("taxInvcAmtDue"));	 //TAX_INVC_AMT_DUE InvAdjM.MemoAdjustTotalAmount = miscM.TaxInvoiceAmountDue;
      			adjMap.put("userId", params.get("userId"));
      			
      			//insert
      			LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT START  ################");
      			LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT PARAM : " + adjMap.toString());
      			posMapper.insertInvAdjMemo(adjMap);
      			LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT END  ################");
      			
      		   //7.  ********************************************************************************************************* ACC TAX DEBIT CREDIT NOTE
      			
      			Map<String, Object> noteMap = new HashMap<String, Object>();
      			
      			noteSeq = posMapper.getSeqPay0027D();
      			
      			noteMap.put("noteSeq", noteSeq);  //seq
      			noteMap.put("memoAdjSeq", memoAdjSeq); // dcnM.NoteEntryID = InvAdjM.MemoAdjustID;
      			noteMap.put("noteTypeId", SalesConstants.POS_NOTE_TYPE_ID); //dcnM.NoteTypeID = 1293; //CN
      			noteMap.put("noteGrpNo", taxInvMap.get("taxInvcSvcNo")); //dcnM.NoteGroupNo = miscM.TaxInvoiceServiceNo;  TAX_INVC_SVC_NO
      			noteMap.put("noteRefNo", cnno); // dcnM.NoteRefNo = InvAdjM.MemoAdjustRefNo;
      			noteMap.put("noteRefDate", taxInvMap.get("taxInvcRefDt")); // TAX_INVC_REF_DT  //dcnM.NoteRefDate = miscM.TaxInvoiceRefDate;
      			noteMap.put("noteInvNo", taxInvMap.get("taxInvcRefNo")); //dcnM.NoteInvoiceNo = InvAdjM.MemoAdjustInvoiceNo;
      			noteMap.put("noteInvTypeId", SalesConstants.POS_NOTE_INVOICE_TYPE_ID); //dcnM.NoteInvoiceTypeID = 128; //MISC
      			noteMap.put("noteInvCustName", taxInvMap.get("taxInvcCustName")); //dcnM.NoteCustName = miscM.TaxInvoiceCustName;  //TAX_INVC_CUST_NAME,
      			noteMap.put("noteCntcPerson", taxInvMap.get("taxInvcCntcPerson"));  //  dcnM.NoteContatcPerson = miscM.TaxInvoiceContactPerson;  //TAX_INVC_CNTC_PERSON,
              /*dcnM.NoteAddress1 = miscM.TaxInvoiceAddress1;
                 dcnM.NoteAddress2 = miscM.TaxInvoiceAddress2;
                 dcnM.NoteAddress3 = miscM.TaxInvoiceAddress3;
                 dcnM.NoteAddress4 = miscM.TaxInvoiceAddress4;
                 dcnM.NotePostCode = miscM.TaxInvoicePostCode;
                 dcnM.NoteAreaName = "";
                 dcnM.NoteStateName = miscM.TaxInvoiceStateName;
                 dcnM.NoteCountryName = miscM.TaxInvoiceCountry;*/
      			noteMap.put("noteInvTxs", taxInvMap.get("taxInvcTxs")); // dcnM.NoteTaxes = miscM.TaxInvoiceTaxes;
      			noteMap.put("noteInvChrg", taxInvMap.get("taxInvcChrg"));  // dcnM.NoteCharges = miscM.TaxInvoiceCharges;  //  TAX_INVC_CHRG,
      			noteMap.put("noteInvAmt", taxInvMap.get("taxInvcAmtDue")); //dcnM.NoteAmountDue = miscM.TaxInvoiceAmountDue;
      			
      			String soRem = String.valueOf(taxInvMap.get("taxInvcSvcNo"));
      			noteMap.put("noteRem", SalesConstants.POS_REM_SOI_COMMENT + soRem); //dcnM.NoteRemark = "SOI Reversal - " + miscM.TaxInvoiceServiceNo;
      			noteMap.put("noteStatusId", SalesConstants.POS_NOTE_STATUS_ID); //dcnM.NoteStatusID = 4;
      			noteMap.put("userId", params.get("userId"));
      			
      			LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT START  ################");
      			LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT PARAM :  " + noteMap.toString());
      			posMapper.insertTaxDebitCreditNote(noteMap);
      			LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT END  ################");
      			
      			Map<String, Object> miscSubMap = new HashMap<String, Object>();
    			miscSubMap.put("taxInvcId", taxInvMap.get("taxInvcId"));
    			List<EgovMap> miscSubList = null;
    			miscSubList = posMapper.getMiscSubList(miscSubMap);
    			
    			if( null != miscSubList && miscSubList.size() > 0){
    				
    				for (int idx = 0; idx < miscSubList.size(); idx++) {
    					//8.  ********************************************************************************************************* INVOICE ADJUSTMENT SUB
    					EgovMap tempSubMap = null;
    					tempSubMap = miscSubList.get(idx);
    					
    					miscSubSeq = posMapper.getSeqPay0012D();
    					Map<String, Object> accInvSubMap = new HashMap<String, Object>();
    					accInvSubMap.put("miscSubSeq", miscSubSeq);
    					accInvSubMap.put("memoAdjSeq", memoAdjSeq); //memoAdjSeq
    					accInvSubMap.put("memoSubItmInvItmId", tempSubMap.get("invcItmId"));  //INVC_ITM_ID
    					accInvSubMap.put("memoSubItmInvItmQty", tempSubMap.get("invcItmQty"));  //INVC_ITM_QTY
    					
    					accInvSubMap.put("memoSubItmCrditAccId", params.get("rePosCrAccId"));  
    					accInvSubMap.put("memoSubItmDebtAccId", params.get("rePosDrAccId"));
    					accInvSubMap.put("memoSubItmTaxCodeId", getAccMap.get("accBillTaxCodeId"));
    					accInvSubMap.put("memoSubItmStusId", SalesConstants.POS_MEMO_ITM_STATUS_ID);  //1
    					accInvSubMap.put("memoSubItmRem", params.get("reversalRem"));  ////InvAdjM.MemoAdjustRemark;
    					
    					accInvSubMap.put("memoSubItmInvItmGSTRate", tempSubMap.get("invcItmGstRate"));  //INVC_ITM_GST_RATE
    					accInvSubMap.put("memoSubItmInvItmCharges", tempSubMap.get("invcItmChrg"));  //INVC_ITM_CHRG
    					accInvSubMap.put("memoSubItmInvItmTaxes", tempSubMap.get("invcItmGstTxs"));  //INVC_ITM_GST_TXS
    					accInvSubMap.put("memoSubItmInvItmAmount", tempSubMap.get("invcItmAmtDue"));  //INVC_ITM_AMT_DUE
    					
    					LOGGER.info("############### 8 - ["+idx+"] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT START  ################");
    					LOGGER.info("############### 8 - ["+idx+"] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT PARAM : " +  accInvSubMap.toString());
    					posMapper.insertInvAdjMemoSub(accInvSubMap);
    					LOGGER.info("############### 8 - ["+idx+"] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT END  ################");
    					
    					//9.  ********************************************************************************************************* ACC TAX DEBIT CREDIT NOTE SUB
    					
    					Map<String, Object> noteSubMap = new HashMap<String, Object>();
    					noteSubSeq = posMapper.getSeqPay0028D();
    					
    					noteSubMap.put("noteSubSeq", noteSubSeq);
    					noteSubMap.put("noteSeq", noteSeq); //dcnS.NoteID = dcnM.NoteID;
    					noteSubMap.put("noteSubItmId", tempSubMap.get("invcItmId")); //dcnS.NoteItemInvoiceItemID = miscSub.InvocieItemID;
    					noteSubMap.put("noteSubOrdNo", tempSubMap.get("invcItmOrdNo")); //dcnS.NoteItemOrderNo = miscSub.InvoiceItemOrderNo;
    					noteSubMap.put("noteSubItmProductModel", tempSubMap.get("invcItmDesc1")); //dcnS.NoteItemProductModel = miscSub.InvoiceItemDescription1;
    					noteSubMap.put("noteSubItmSerialNo", tempSubMap.get("invcItmSerialNo")); //dcnS.NoteItemSerialNo = miscSub.InvoiceItemSerialNo;
    					noteSubMap.put("noteSubItmInstDt", tempSubMap.get("invcItmInstallDt")); //dcnS.NoteItemInstallationDate = miscSub.InvoiceItemInstallDate;
    					/* dcnS.NoteItemAdd1 = miscSub.InvoiceItemAdd1;
                         dcnS.NoteItemAdd2 = miscSub.InvoiceItemAdd2;
                         dcnS.NoteItemAdd3 = miscSub.InvoiceItemAdd3;
                         dcnS.NoteItemAdd4 = miscSub.InvoiceItemAdd4;
                         dcnS.NoteItemPostcode = miscSub.InvoiceItemPostCode;
                         dcnS.NoteItemAreaName = miscSub.InvoiceItemAreaName;
                         dcnS.NoteItemStateName = miscSub.InvoiceItemStateName;
                         dcnS.NoteItemCountry = miscSub.InvoiceItemCountry;*/
    					noteSubMap.put("noteSubItmQty", tempSubMap.get("invcItmQty")); //dcnS.NoteItemQuantity = miscSub.InvoiceItemQuantity;
    					noteSubMap.put("noteSubItmUnitPrc", tempSubMap.get("invcItmUnitPrc")); //dcnS.NoteItemUnitPrice = miscSub.InvoiceItemUnitPrice;
    					noteSubMap.put("noteSubItmGstRate", tempSubMap.get("invcItmGstRate")); //dcnS.NoteItemGSTRate = miscSub.InvoiceItemGSTRate;
    					noteSubMap.put("noteSubItmGstTxs", tempSubMap.get("invcItmGstTxs")); //dcnS.NoteItemGSTTaxes = miscSub.InvoiceItemGSTTaxes;
    					noteSubMap.put("noteSubItmChrg", tempSubMap.get("invcItmChrg")); //dcnS.NoteItemCharges = miscSub.InvoiceItemCharges;
    					noteSubMap.put("noteSubItmDueAmt", tempSubMap.get("invcItmAmtDue")); //dcnS.NoteItemDueAmount = miscSub.InvoiceItemAmountDue;
    					
    					LOGGER.info("############### 9 - ["+idx+"] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT START  ################");
    					LOGGER.info("############### 9 - ["+idx+"] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT PARAM : " +noteSubMap.toString());
    					posMapper.insertTaxDebitCreditNoteSub(noteSubMap);
    					LOGGER.info("############### 9 - ["+idx+"] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT END  ################");
    				}
    				
    			}
    			
    			//10.  ********************************************************************************************************* ACC ORDER VOID INVOICE
    			Map<String, Object> ordVoidInvMap = new HashMap<String, Object>(); 
    			
    			ordVoidSeq = posMapper.getSeqPay0017D();
    			
    			ordVoidInvMap.put("ordVoidSeq", ordVoidSeq); //nvVoidM.AccInvVoidID = 0;
    			ordVoidInvMap.put("voidNo", voidNo); //InvVoidM.AccInvVoidRefNo = VoidNo;
    			ordVoidInvMap.put("accInvVoidRefNo", taxInvMap.get("taxInvcRefNo")); //InvVoidM.AccInvVoidInvoiceNo = miscM.TaxInvoiceRefNo;
    			ordVoidInvMap.put("accInvVoidInvcAmt", params.get("rePosTotAmt")); //ACC_INV_VOID_INVC_AMT
    			String voidRem = String.valueOf(params.get("rePosNo"));
    			ordVoidInvMap.put("accInvVoidRem", SalesConstants.POS_REM_SOI_COMMENT_INV_VOID +  voidRem); //ACC_INV_VOID_REM //  InvVoidM.AccInvVoidRemark = "SOI Reversal_" + this.txtReferenceNo.Text.Trim();
    			ordVoidInvMap.put("accInvVoidStausId", SalesConstants.POS_ACC_INV_VOID_STATUS); //InvVoidM.AccInvVoidStatusID = 1;
    			ordVoidInvMap.put("userId", params.get("userId"));
    			
    			LOGGER.info("############### 10. POS ACC ORDER VOID INVOICE REVERSAL INSERT START  ################");
    			LOGGER.info("############### 10. POS ACC ORDER VOID INVOICE REVERSAL INSERT PARAM : " + ordVoidInvMap.toString());
    			posMapper.insertAccOrderVoidInv(ordVoidInvMap);
    			LOGGER.info("############### 10. POS ACC ORDER VOID INVOICE REVERSAL INSERT END  ################");
    			
    			//11.  ********************************************************************************************************* ACC ORDER VOID INVOICE SUB
    			Map<String, Object> ordVoidSubMap = new HashMap<String, Object>();
    			
    			ordVoidSubSeq = posMapper.getSeqPay0018D();
    			
    			ordVoidSubMap.put("ordVoidSubSeq", ordVoidSubSeq);
    			ordVoidSubMap.put("ordVoidSeq", ordVoidSeq); //InvVoidS.AccInvVoidID = InvVoidM.AccInvVoidID;
    			ordVoidSubMap.put("ordVoidSubOrdId", SalesConstants.POS_ACC_INV_VOID_ORD_ID); //InvVoidS.AccInvVoidSubOrderID = 0;
    			ordVoidSubMap.put("ordVoidSubBillId", getAccMap.get("accBillId")); //InvVoidS.AccInvVoidSubBillID = accorderbill.AccBillID;
    			ordVoidSubMap.put("ordVoidSubBillAmt",  params.get("rePosTotAmt")); //ACC_INV_VOID_SUB_BILL_AMT   InvVoidS.AccInvVoidSubBillAmt = decimal.Parse(totalcharges);
    			ordVoidSubMap.put("ordVoidSubCrditNote", cnno); //ACC_INV_VOID_SUB_CRDIT_NOTE // InvVoidS.AccInvVoidSubCreditNote = InvAdjM.MemoAdjustRefNo;
    			ordVoidSubMap.put("ordVoidSubCrditNoteId", memoAdjSeq); //InvVoidS.AccInvVoidSubCreditNoteID = InvAdjM.MemoAdjustID;
    			String voidSubRem= String.valueOf(params.get("rePosNo"));
    			ordVoidSubMap.put("ordVoidSubRem", SalesConstants.POS_REM_SOI_COMMENT_INV_VOID + voidSubRem);
    			
    			LOGGER.info("############### 11. POS ACC ORDER VOID INVOICE SUB REVERSAL INSERT START  ################");
    			LOGGER.info("############### 11. POS ACC ORDER VOID INVOICE SUB REVERSAL INSERT PARAM : " + ordVoidSubMap.toString());
    			posMapper.insertAccOrderVoidInvSub(ordVoidSubMap);
    			LOGGER.info("############### 11. POS ACC ORDER VOID INVOICE SUB REVERSAL INSERT END  ################");
    			
      		}// taxInvMap not null (miscM)
			
      		
      	   //12.  ********************************************************************************************************* STOCK RECORD CARD 
      		if(SalesConstants.POS_SALES_TYPE_FILTER.equals(String.valueOf(params.get("rePosSysTypeId")))){ //1352  filter & spare part
      			Map<String, Object> stkMap = new HashMap<String, Object>();
      			List<EgovMap> stkList = null;
      			
      			stkMap.put("rePosNo", params.get("rePosNo"));
      			stkList = posMapper.selectStkCardRecordList(stkMap);
      			
      			if(stkList != null && stkList.size() > 0){
      				for (int idx = 0; idx < stkList.size(); idx++) {
      				   EgovMap reStkMap =	 null;
      				   reStkMap = stkList.get(idx);
      				   
      				   stkSeq = posMapper.getSeqLog0014D();
      				   
      				   reStkMap.put("stkSeq", stkSeq);
      				   reStkMap.put("posRefNo", posRefNo); // irc.RefNo = posRefNo;
      				  
      				   int stkTempQty =  Integer.parseInt(String.valueOf(reStkMap.get("qty")));
      				   stkTempQty = -1 * stkTempQty;
      				   reStkMap.put("stkTempQty", stkTempQty); //     irc.Qty = -1 * irc.Qty;
      				   
      				   reStkMap.put("stkRem", SalesConstants.POS_REM_SOI_COMMENT_INV_VOID + String.valueOf(params.get("rePosNo")));
      					
      				   LOGGER.info("############### 12 - ["+idx+"] POS STOCK RECORD CARD REVERSAL INSERT START  ################");
      				   LOGGER.info("############### 12 - ["+idx+"] POS STOCK RECORD CARD REVERSAL INSERT PARAM : " + reStkMap.toString());
      				   posMapper.insertStkCardRecordReversal(reStkMap);
      				   LOGGER.info("############### 12 - ["+idx+"] POS STOCK RECORD CARD REVERSAL INSERT END  ################");
      					
					}
      			}
      		}
      		
      	EgovMap rtnMap = new EgovMap();
      	rtnMap.put("posRefNo", posRefNo);
      	
		return rtnMap;
	}

	@Override
	public List<EgovMap> getPurchMemList(Map<String, Object> params) throws Exception {
		
		return posMapper.getPurchMemList(params);
	}

	@Override
	@Transactional
	public void updatePosMStatus(PosGridVO pgvo) throws Exception {
		
		GridDataSet<PosMasterVO> posMGridDataSetList = pgvo.getPosStatusDataSetList();
		
		List<PosMasterVO> updateList = posMGridDataSetList.getUpdate();
		
		//Update PosMaster
		for(PosMasterVO pvo : updateList){
			
			//Update Pos Master
			posMapper.updatePosMStatus(pvo);
		
			//Complete to Update Pos Detail  
			if(pvo.getStusId() == SalesConstants.POS_SALES_STATUS_COMPLETE){  // to 4
				pvo.setChangeStatus(SalesConstants.POS_DETAIL_RECEIVE); //to Detail Status  85
				posMapper.updatePosDStatus(pvo);
			}
		}
	}
	
	
	@Override
	@Transactional
	public void updatePosDStatus(PosGridVO pgvo) throws Exception {
		
		GridDataSet<PosDetailVO> posDGridDataSetList = pgvo.getPosDetailStatusDataSetList();
		
		List<PosDetailVO> updateList = posDGridDataSetList.getUpdate();
		
		//Update Pos Detail by PosItemID
		for(PosDetailVO pdvo : updateList){
			
			posMapper.updatePosDStatusByPosItmId(pdvo);
			
		}
		
		//Check Detail Status
		if(updateList != null && updateList.size() > 0){
			
			int posId =  updateList.get(0).getPosId();  //posId
			
			Map<String, Object> getDetMap = new HashMap<String, Object>();
			getDetMap.put("rePosId", posId);
			
			List<EgovMap> detailList = null;
			detailList = posMapper.getPosDetailList(getDetMap);
			
			int cnt = 0;
			
			for (int idx = 0; idx < detailList.size(); idx++) {
				EgovMap tempMap = detailList.get(idx);
				LOGGER.info("#########################  tempMap.get(rcvStusId)  : ===  " + tempMap.get("rcvStusId"));
				LOGGER.info("#########################  cccccccccccccccccccc   : ===  " + SalesConstants.POS_DETAIL_NON_RECEIVE);
				if(Integer.parseInt(String.valueOf(tempMap.get("rcvStusId"))) == (SalesConstants.POS_DETAIL_NON_RECEIVE)){  //96
					LOGGER.info("##################  NonReceive HAS!!!!@##########################");
					cnt++;
				}
			}
			
			LOGGER.info("######################### cnt : " + cnt);
			//Update Pos M Status to Complete
			if(cnt == 0){
				
				PosMasterVO pvo = new PosMasterVO();
				pvo.setPosId(posId);
				pvo.setStusId(SalesConstants.POS_SALES_STATUS_COMPLETE);
				
				posMapper.updatePosMStatus(pvo);
			}
		}
	}

	@Override
	public void updatePosMemStatus(PosGridVO pgvo) throws Exception {
		
		GridDataSet<PosMemberVO> posMemGridDataSetList = pgvo.getPosMemberStatusDataSetList();
		
		List<PosMemberVO> updateList = posMemGridDataSetList.getUpdate();
		
		//Update Pos Detail by PosItemID
		for(PosMemberVO pdvo : updateList){
			
			posMapper.updatePosMemStatus(pdvo); //posId memId
			
		}
		
		//Check Detail Status
		if(updateList != null && updateList.size() > 0){
			
			int posId =  updateList.get(0).getPosId();  //posId
			
			Map<String, Object> getDetMap = new HashMap<String, Object>();
			getDetMap.put("rePosId", posId);
			
			List<EgovMap> detailList = null;
			detailList = posMapper.getPosDetailList(getDetMap);
			
			int cnt = 0;
			
			for (int idx = 0; idx < detailList.size(); idx++) {
				EgovMap tempMap = detailList.get(idx);
				LOGGER.info("#########################  tempMap.get(rcvStusId)  : ===  " + tempMap.get("rcvStusId"));
				LOGGER.info("#########################  cccccccccccccccccccc   : ===  " + SalesConstants.POS_DETAIL_NON_RECEIVE);
				if(Integer.parseInt(String.valueOf(tempMap.get("rcvStusId"))) == (SalesConstants.POS_DETAIL_NON_RECEIVE)){  //96
					LOGGER.info("##################  NonReceive HAS!!!!@##########################");
					cnt++;
				}
			}
			
			LOGGER.info("######################### cnt : " + cnt);
			//Update Pos M Status to Complete
			if(cnt == 0){
				
				PosMasterVO pvo = new PosMasterVO();
				pvo.setPosId(posId);
				pvo.setStusId(SalesConstants.POS_SALES_STATUS_COMPLETE);
				
				posMapper.updatePosMStatus(pvo);
			}
		}
		
	}

}
